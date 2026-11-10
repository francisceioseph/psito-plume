import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_plume/src/paint/operations.dart';
import 'package:psito_plume/src/paint/pixels.dart';
import 'package:psito_plume/src/paint/plume_controller.dart';
import 'package:psito_plume/src/platform/image_clipboard.dart';

const white = 0xFFFFFFFF;
const red = 0xFFFF0000;
const blue = 0xFF0000FF;
const green = 0xFF00FF00;

Future<int> pixel(PlumeController c, int x, int y) async {
  await c.idle;
  final data = await c.image!.toByteData(format: ui.ImageByteFormat.rawRgba);
  return pixelAt(data!.buffer.asUint8List(), c.width, x, y);
}

Future<PlumeController> sheet() async {
  final c = PlumeController(clipboard: MemoryImageClipboard());
  await c.newImage(60, 40);
  return c;
}

void stroke(PlumeController c, Offset from, Offset to, {bool right = false}) {
  c.pointerDown(from, secondary: right);
  c.pointerMove(to);
  c.pointerUp();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('only the pixels near the colour, under the stroke, change', () {
    final rgba = Uint8List.fromList([
      255, 0, 0, 255, // red
      250, 10, 5, 255, // almost red
      0, 0, 255, 255, // blue
      255, 0, 0, 255, // red, outside the stroke
    ]);
    final mask = Uint8List.fromList([
      ...[255, 255, 255, 255],
      ...[255, 255, 255, 255],
      ...[255, 255, 255, 255],
      ...[0, 0, 0, 0],
    ]);
    final out = replaceUnderMask(rgba: rgba, mask: mask, from: red, to: white)!;
    expect(pixelAt(out, 4, 0, 0), white);
    expect(pixelAt(out, 4, 1, 0), white);
    expect(pixelAt(out, 4, 2, 0), blue);
    expect(pixelAt(out, 4, 3, 0), red);
    expect(
      replaceUnderMask(rgba: rgba, mask: mask, from: green, to: white),
      isNull,
    );
  });

  test('the right button paints, fills and draws shapes with the second colour', () async {
    final c = await sheet()
      ..setSecondary(const Color(green));
    stroke(c, const Offset(5, 5), const Offset(50, 5), right: true);
    expect(await pixel(c, 30, 5), green);

    c
      ..setTool(Tool.rectangle)
      ..setFilled(true);
    stroke(c, const Offset(5, 20), const Offset(15, 30), right: true);
    expect(await pixel(c, 10, 25), green);

    c
      ..setSecondary(const Color(blue))
      ..setTool(Tool.fill);
    c.pointerDown(const Offset(40, 30), secondary: true);
    expect(await pixel(c, 55, 38), blue);
  });

  test('the picker with the right button takes the second colour', () async {
    final c = await sheet()..setColor(const Color(red));
    stroke(c, const Offset(5, 5), const Offset(50, 5));
    c.setTool(Tool.picker);
    await c.pick(const Offset(30, 5), secondary: true);
    expect(c.secondary.toARGB32(), red);
    expect(c.color.toARGB32(), red);
  });

  test('the eraser with the right button takes away only the main colour', () async {
    final c = await sheet()
      ..setTool(Tool.rectangle)
      ..setFilled(true)
      ..setColor(const Color(blue));
    stroke(c, const Offset(0, 0), const Offset(30, 40));
    c
      ..setColor(const Color(red))
      ..setTool(Tool.rectangle);
    stroke(c, const Offset(30, 0), const Offset(60, 40));
    c
      ..setTool(Tool.eraser)
      ..setSize(0);
    stroke(c, const Offset(5, 20), const Offset(55, 20), right: true);
    expect(await pixel(c, 45, 20), white, reason: 'red under the stroke goes');
    expect(await pixel(c, 15, 20), blue, reason: 'blue under the stroke stays');
    expect(await pixel(c, 45, 2), red, reason: 'red away from the stroke stays');
  });

  test('swapping the colours', () async {
    final c = await sheet()
      ..setColor(const Color(red))
      ..setSecondary(const Color(blue))
      ..swapColors();
    expect(c.color.toARGB32(), blue);
    expect(c.secondary.toARGB32(), red);
  });
}
