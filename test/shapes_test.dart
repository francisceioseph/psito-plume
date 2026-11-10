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

Future<PlumeController> sheet(Tool tool) async {
  final c = PlumeController(clipboard: MemoryImageClipboard());
  await c.newImage(100, 100);
  return c
    ..setTool(tool)
    ..setColor(const Color(red));
}

void drag(PlumeController c, Offset from, Offset to) {
  c
    ..pointerDown(from)
    ..pointerMove(to)
    ..pointerUp();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a filled rounded rectangle leaves its corners as paper', () async {
    final c = await sheet(Tool.roundedRectangle)..setFilled(true);
    drag(c, const Offset(10, 10), const Offset(90, 90));
    expect(await pixel(c, 50, 50), red);
    expect(await pixel(c, 11, 11), white);
    expect(await pixel(c, 50, 11), red);
  });

  test('an arrow has a head at the end', () async {
    final c = await sheet(Tool.arrow)..setSize(1);
    drag(c, const Offset(10, 50), const Offset(90, 50));
    expect(await pixel(c, 50, 50), red);
    // The wings go back from the tip, above and below the line.
    expect(await pixel(c, 84, 47), red);
    expect(await pixel(c, 84, 53), red);
  });

  test('a curve waits for its bend and goes through it', () async {
    final c = await sheet(Tool.curve)..setSize(2);
    drag(c, const Offset(10, 80), const Offset(90, 80));
    await c.idle;
    expect(c.canUndo, isFalse, reason: 'still waiting for the bend');
    expect(c.live, isA<CurveOp>());
    drag(c, const Offset(50, 20), const Offset(50, 20));
    expect(c.live, isNull);
    expect(await pixel(c, 50, 20), red);
    expect(await pixel(c, 50, 80), white);
  });

  test('a polygon closes on its first corner', () async {
    final c = await sheet(Tool.polygon)..setFilled(true);
    for (final corner in const [
      Offset(10, 10),
      Offset(90, 10),
      Offset(90, 90),
      Offset(10, 90),
    ]) {
      c
        ..hover(corner)
        ..pointerDown(corner)
        ..pointerUp();
    }
    expect(c.canUndo, isFalse);
    c
      ..pointerDown(const Offset(11, 11))
      ..pointerUp();
    expect(c.live, isNull);
    expect(await pixel(c, 50, 50), red);
  });

  test('Enter finishes an open polygon, Escape gives one up', () async {
    final c = await sheet(Tool.polygon)..setSize(2);
    for (final corner in const [Offset(10, 10), Offset(90, 10), Offset(90, 90)]) {
      c
        ..pointerDown(corner)
        ..pointerUp();
    }
    c.finishShape();
    expect(await pixel(c, 50, 10), red);
    expect(await pixel(c, 50, 50), white, reason: 'open, so not filled');

    c
      ..pointerDown(const Offset(10, 50))
      ..pointerUp()
      ..pointerDown(const Offset(60, 50))
      ..pointerUp()
      ..cancelShape();
    expect(c.live, isNull);
    expect(await pixel(c, 30, 50), white);
  });

  test('spray dots stay around the path and repeat for the same seed', () async {
    final op = SprayOp(
      points: const [Offset(50, 50), Offset(52, 50)],
      color: const Color(red),
      radius: 10,
      seed: 3,
    );
    final dots = op.dots().toList();
    expect(dots, isNotEmpty);
    for (final dot in dots) {
      expect((dot - const Offset(51, 50)).distance, lessThanOrEqualTo(11));
    }
    expect(op.dots().toList(), dots);

    final c = await sheet(Tool.spray)..setSize(2);
    drag(c, const Offset(20, 20), const Offset(80, 20));
    await c.idle;
    expect(c.canUndo, isTrue);
  });

  test('changing tool puts a waiting curve in the drawing', () async {
    final c = await sheet(Tool.curve);
    drag(c, const Offset(10, 50), const Offset(90, 50));
    c.setTool(Tool.brush);
    expect(await pixel(c, 50, 50), red);
  });
}
