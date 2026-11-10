part of 'plume_controller.dart';

enum Turn { right, left, half, flipHorizontal, flipVertical }

/// [source] turned or mirrored.
Future<ui.Image> turned(ui.Image source, Turn turn) {
  final w = source.width.toDouble();
  final h = source.height.toDouble();
  final sideways = turn == Turn.right || turn == Turn.left;
  final width = sideways ? source.height : source.width;
  final height = sideways ? source.width : source.height;
  return _draw(width, height, (canvas) {
    switch (turn) {
      case Turn.right:
        canvas
          ..translate(h, 0)
          ..rotate(pi / 2);
      case Turn.left:
        canvas
          ..translate(0, w)
          ..rotate(-pi / 2);
      case Turn.half:
        canvas
          ..translate(w, h)
          ..rotate(pi);
      case Turn.flipHorizontal:
        canvas
          ..translate(w, 0)
          ..scale(-1, 1);
      case Turn.flipVertical:
        canvas
          ..translate(0, h)
          ..scale(1, -1);
    }
    canvas.drawImage(
      source,
      Offset.zero,
      Paint()..filterQuality = FilterQuality.none,
    );
  });
}

/// [source] stretched to [width] × [height].
Future<ui.Image> stretched(ui.Image source, int width, int height) =>
    _draw(width, height, (canvas) {
      canvas.drawImageRect(
        source,
        Rect.fromLTWH(0, 0, source.width.toDouble(), source.height.toDouble()),
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
        Paint()..filterQuality = FilterQuality.high,
      );
    });

/// Turning, mirroring, stretching and cropping. With a selection they act on
/// it, lifting it first; without one, on the whole drawing.
extension Transforms on PlumeController {
  /// The size [resize] starts from: the selection, or the drawing.
  Size get resizableSize =>
      selectedRect?.size ?? Size(width.toDouble(), height.toDouble());

  Future<void> turn(Turn turn) => _onSelectionOrImage(
    (picture) => turned(picture, turn),
  );

  Future<void> resize(int newWidth, int newHeight) => _onSelectionOrImage(
    (picture) => stretched(picture, newWidth, newHeight),
  );

  Future<void> _onSelectionOrImage(
    Future<ui.Image> Function(ui.Image) change,
  ) {
    commitText();
    final rect = selection;
    if (floating == null && rect != null) _lift(rect);
    return _run(() async {
      final lifted = floating;
      if (lifted != null) {
        final next = await change(lifted.image);
        lifted.image.dispose();
        floating = Floating(next, lifted.position);
        _changed();
        return;
      }
      final next = await change(image!);
      selection = null;
      _push(next);
      _changed();
    });
  }

  /// A sheet of [newWidth] × [newHeight]: the drawing stays on the top left,
  /// cut where the sheet is smaller and with paper where it is bigger.
  Future<void> resizeSheet(int newWidth, int newHeight) async {
    await dropSelection();
    commitText();
    return _run(() async {
      final base = image!;
      final next = await _draw(newWidth, newHeight, (canvas) {
        canvas
          ..drawRect(
            Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
            Paint()..color = paperColor,
          )
          ..drawImage(base, Offset.zero, Paint());
      });
      _push(next);
      _changed();
    });
  }

  /// Keeps only what is selected. False when nothing is.
  Future<bool> cropToSelection() async {
    final rect = selectedRect;
    if (rect == null) return false;
    await placeSelection();
    final area = selection;
    if (area == null || area.isEmpty) return false;
    await _run(() async {
      final next = await _crop(image!, area);
      selection = null;
      _push(next);
      _changed();
    });
    return true;
  }
}
