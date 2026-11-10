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

Future<int> pixel(PlumeController c, int x, int y) async {
  await c.idle;
  final data = await c.image!.toByteData(format: ui.ImageByteFormat.rawRgba);
  return pixelAt(data!.buffer.asUint8List(), c.width, x, y);
}

/// A 40 × 30 sheet with a red square from (5, 5) to (15, 15).
Future<(PlumeController, MemoryImageClipboard)> sheet() async {
  final clipboard = MemoryImageClipboard();
  final c = PlumeController(clipboard: clipboard);
  await c.newImage(40, 30);
  c
    ..setTool(Tool.rectangle)
    ..setFilled(true)
    ..setColor(const Color(red));
  c.pointerDown(const Offset(5, 5));
  c.pointerMove(const Offset(15, 15));
  c.pointerUp();
  await c.idle;
  c.setTool(Tool.select);
  return (c, clipboard);
}

void select(PlumeController c, Offset from, Offset to) {
  c.pointerDown(from);
  c.pointerMove(to);
  c.pointerUp();
}

void drag(PlumeController c, Offset from, Offset to) {
  c.pointerDown(from);
  c.pointerMove(to);
  c.pointerUp();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('dragging marks a rectangle on whole pixels, inside the sheet', () async {
    final (c, _) = await sheet();
    select(c, const Offset(4.4, 4.6), const Offset(60, 16.2));
    expect(c.selection, const Rect.fromLTRB(4, 5, 40, 16));
  });

  test('a click without a drag chooses nothing', () async {
    final (c, _) = await sheet();
    select(c, const Offset(4, 4), const Offset(4, 4));
    expect(c.selection, isNull);
  });

  test('moving the selection leaves paper behind', () async {
    final (c, _) = await sheet();
    select(c, const Offset(5, 5), const Offset(15, 15));
    drag(c, const Offset(8, 8), const Offset(28, 18));
    await c.idle;
    expect(c.floating, isNotNull);
    await c.dropSelection();
    expect(await pixel(c, 7, 7), white);
    expect(await pixel(c, 27, 17), red);
    expect(c.floating, isNull);
  });

  test('undo while moving puts everything back', () async {
    final (c, _) = await sheet();
    select(c, const Offset(5, 5), const Offset(15, 15));
    drag(c, const Offset(8, 8), const Offset(28, 18));
    await c.undo();
    expect(c.floating, isNull);
    expect(await pixel(c, 7, 7), red);
    expect(await pixel(c, 27, 17), white);
  });

  test('another tool puts the selection down', () async {
    final (c, _) = await sheet();
    select(c, const Offset(5, 5), const Offset(15, 15));
    drag(c, const Offset(8, 8), const Offset(28, 8));
    await c.idle;
    c.setTool(Tool.brush);
    expect(await pixel(c, 27, 7), red);
    expect(c.selection, isNull);
  });

  test('copy and paste make a second square that floats', () async {
    final (c, clipboard) = await sheet();
    select(c, const Offset(5, 5), const Offset(15, 15));
    expect(await c.copySelection(), isTrue);
    expect(clipboard.image!.width, 10);
    await c.dropSelection();
    expect(await c.paste(), isTrue);
    await c.idle;
    expect(c.floating!.position, Offset.zero);
    drag(c, const Offset(2, 2), const Offset(27, 2));
    await c.dropSelection();
    expect(await pixel(c, 26, 1), red);
    expect(await pixel(c, 7, 7), red);
  });

  test('a picture copied in another program is pasted', () async {
    final (c, clipboard) = await sheet();
    clipboard.image = ClipboardImage(
      width: 2,
      height: 2,
      rgba: Uint8List.fromList(
        [for (var i = 0; i < 4; i++) ...[0, 0, 255, 255]],
      ),
    );
    await c.paste();
    await c.dropSelection();
    expect(await pixel(c, 1, 1), blue);
    expect(await pixel(c, 2, 2), white);
  });

  test('undo takes a paste away', () async {
    final (c, clipboard) = await sheet();
    select(c, const Offset(5, 5), const Offset(15, 15));
    await c.copySelection();
    await c.dropSelection();
    await c.paste();
    await c.undo();
    expect(c.floating, isNull);
    expect(await pixel(c, 1, 1), white);
    expect(await pixel(c, 7, 7), red);
  });

  test('cut copies and clears', () async {
    final (c, clipboard) = await sheet();
    select(c, const Offset(5, 5), const Offset(15, 15));
    expect(await c.cutSelection(), isTrue);
    expect(await pixel(c, 7, 7), white);
    expect(clipboard.image, isNotNull);
  });

  test('nothing chosen, nothing copied, and nothing to paste', () async {
    final (c, _) = await sheet();
    expect(await c.copySelection(), isFalse);
    expect(await c.paste(), isFalse);
  });

  test('select all chooses the whole sheet', () async {
    final (c, _) = await sheet();
    c.setTool(Tool.brush);
    c.selectAll();
    expect(c.tool, Tool.select);
    expect(c.selection, const Rect.fromLTWH(0, 0, 40, 30));
    await c.deleteSelection();
    expect(await pixel(c, 7, 7), white);
  });

  test('saving puts a floating selection down first', () async {
    final (c, _) = await sheet();
    select(c, const Offset(5, 5), const Offset(15, 15));
    drag(c, const Offset(8, 8), const Offset(28, 8));
    await c.pngBytes();
    expect(c.floating, isNull);
    expect(await pixel(c, 27, 7), red);
  });
}
