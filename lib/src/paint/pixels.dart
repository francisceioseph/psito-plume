import 'dart:typed_data';

/// The colour at [x], [y] of an RGBA buffer, as 0xAARRGGBB.
int pixelAt(Uint8List rgba, int width, int x, int y) {
  final i = (y * width + x) * 4;
  return rgba[i + 3] << 24 | rgba[i] << 16 | rgba[i + 1] << 8 | rgba[i + 2];
}

/// Paints [to] where [mask] has ink and [rgba] is close to [from]. Null when
/// no pixel changes.
Uint8List? replaceUnderMask({
  required Uint8List rgba,
  required Uint8List mask,
  required int from,
  required int to,
  int tolerance = 40,
}) {
  final out = Uint8List.fromList(rgba);
  final source = [from >> 16 & 0xFF, from >> 8 & 0xFF, from & 0xFF];
  final target = [to >> 16 & 0xFF, to >> 8 & 0xFF, to & 0xFF, to >> 24 & 0xFF];
  var changed = false;
  for (var i = 0; i < rgba.length; i += 4) {
    if (mask[i + 3] == 0) continue;
    var close = true;
    for (var c = 0; c < 3; c++) {
      if ((rgba[i + c] - source[c]).abs() > tolerance) close = false;
    }
    if (!close) continue;
    for (var c = 0; c < 4; c++) {
      out[i + c] = target[c];
    }
    changed = true;
  }
  return changed ? out : null;
}

/// What the paint bucket needs. A class, so that it can go to an isolate.
class FillRequest {
  const FillRequest({
    required this.rgba,
    required this.width,
    required this.height,
    required this.x,
    required this.y,
    required this.color,
    this.tolerance = 40,
  });

  final Uint8List rgba;
  final int width;
  final int height;
  final int x;
  final int y;

  /// The new colour, as 0xAARRGGBB.
  final int color;

  /// How far, in each channel, a pixel can be from the clicked one and still
  /// be painted. Some room is needed for the soft edges of brush strokes.
  final int tolerance;
}

/// Paints the area connected to the clicked pixel. Null when there is nothing
/// to change: the click was outside, or the area already has the colour.
Uint8List? floodFill(FillRequest request) {
  final width = request.width;
  final height = request.height;
  final x = request.x;
  final y = request.y;
  if (x < 0 || y < 0 || x >= width || y >= height) return null;
  final source = request.rgba;
  final start = (y * width + x) * 4;
  final target = [
    source[start],
    source[start + 1],
    source[start + 2],
    source[start + 3],
  ];
  final fill = [
    request.color >> 16 & 0xFF,
    request.color >> 8 & 0xFF,
    request.color & 0xFF,
    request.color >> 24 & 0xFF,
  ];
  var same = true;
  for (var c = 0; c < 4; c++) {
    if (target[c] != fill[c]) same = false;
  }
  if (same) return null;

  final tolerance = request.tolerance;
  bool matches(int pixel) {
    final i = pixel * 4;
    for (var c = 0; c < 4; c++) {
      if ((source[i + c] - target[c]).abs() > tolerance) return false;
    }
    return true;
  }

  final out = Uint8List.fromList(source);
  final seen = Uint8List(width * height);
  final queue = Int32List(width * height);
  var head = 0;
  var tail = 0;
  queue[tail++] = y * width + x;
  seen[y * width + x] = 1;
  while (head < tail) {
    final pixel = queue[head++];
    final i = pixel * 4;
    for (var c = 0; c < 4; c++) {
      out[i + c] = fill[c];
    }
    final px = pixel % width;
    final py = pixel ~/ width;
    void visit(int nx, int ny) {
      if (nx < 0 || ny < 0 || nx >= width || ny >= height) return;
      final next = ny * width + nx;
      if (seen[next] == 1 || !matches(next)) return;
      seen[next] = 1;
      queue[tail++] = next;
    }

    visit(px - 1, py);
    visit(px + 1, py);
    visit(px, py - 1);
    visit(px, py + 1);
  }
  return out;
}
