import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_plume/src/paint/operations.dart';
import 'package:psito_plume/src/paint/pixels.dart';
import 'package:psito_plume/src/paint/plume_controller.dart';
import 'package:psito_plume/src/platform/image_clipboard.dart';

const white = 0xFFFFFFFF;
const red = 0xFFFF0000;

Future<int> pixel(PlumeController c, int x, int y) async {
  await c.idle;
  final data = await c.image!.toByteData(format: ui.ImageByteFormat.rawRgba);
  return pixelAt(data!.buffer.asUint8List(), c.width, x, y);
}

/// A 40 × 30 sheet with one red pixel on the top left corner.
Future<PlumeController> sheet() async {
  final c = PlumeController(clipboard: MemoryImageClipboard());
  await c.newImage(40, 30);
  c
    ..setTool(Tool.pencil)
    ..setSize(0)
    ..setColor(const Color(red))
    ..pointerDown(const Offset(0.5, 0.5))
    ..pointerUp();
  await c.idle;
  return c;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('rotating right swaps the sides and takes the corner along', () async {
    final c = await sheet();
    await c.turn(Turn.right);
    expect((c.width, c.height), (30, 40));
    expect(await pixel(c, 29, 0), red);
    expect(await pixel(c, 0, 0), white);
  });

  test('rotating left and half', () async {
    final left = await sheet();
    await left.turn(Turn.left);
    expect(await pixel(left, 0, 39), red);
    final half = await sheet();
    await half.turn(Turn.half);
    expect(await pixel(half, 39, 29), red);
  });

  test('mirrors', () async {
    final h = await sheet();
    await h.turn(Turn.flipHorizontal);
    expect(await pixel(h, 39, 0), red);
    final v = await sheet();
    await v.turn(Turn.flipVertical);
    expect(await pixel(v, 0, 29), red);
  });

  test('each change can be undone', () async {
    final c = await sheet();
    await c.turn(Turn.right);
    await c.undo();
    expect((c.width, c.height), (40, 30));
    expect(await pixel(c, 0, 0), red);
  });

  test('resizing stretches the drawing', () async {
    final c = await sheet();
    await c.resize(80, 60);
    expect((c.width, c.height), (80, 60));
    expect(await pixel(c, 0, 0), isNot(white));
  });

  test('a bigger sheet adds paper, a smaller one cuts', () async {
    final c = await sheet();
    await c.resizeSheet(100, 20);
    expect((c.width, c.height), (100, 20));
    expect(await pixel(c, 0, 0), red);
    expect(await pixel(c, 90, 10), white);
  });

  test('with a selection, only the selection turns', () async {
    final c = await sheet();
    c
      ..setTool(Tool.select)
      ..pointerDown(Offset.zero)
      ..pointerMove(const Offset(10, 4))
      ..pointerUp();
    await c.turn(Turn.flipHorizontal);
    await c.dropSelection();
    expect((c.width, c.height), (40, 30));
    expect(await pixel(c, 9, 0), red);
    expect(await pixel(c, 0, 0), white);
  });

  test('the size to resize from is the selection, or the drawing', () async {
    final c = await sheet();
    expect(c.resizableSize, const Size(40, 30));
    c
      ..setTool(Tool.select)
      ..pointerDown(Offset.zero)
      ..pointerMove(const Offset(10, 4))
      ..pointerUp();
    expect(c.resizableSize, const Size(10, 4));
  });

  test('cropping keeps only the selection', () async {
    final c = await sheet();
    expect(await c.cropToSelection(), isFalse);
    c
      ..setTool(Tool.select)
      ..pointerDown(Offset.zero)
      ..pointerMove(const Offset(10, 4))
      ..pointerUp();
    expect(await c.cropToSelection(), isTrue);
    expect((c.width, c.height), (10, 4));
    expect(await pixel(c, 0, 0), red);
  });
}
