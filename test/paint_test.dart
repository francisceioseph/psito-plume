import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_plume/src/paint/operations.dart';
import 'package:psito_plume/src/paint/pixels.dart';
import 'package:psito_plume/src/paint/plume_controller.dart';

/// A [width] × [height] buffer of one colour.
Uint8List plain(int width, int height, int argb) {
  final out = Uint8List(width * height * 4);
  for (var i = 0; i < width * height; i++) {
    out[i * 4] = argb >> 16 & 0xFF;
    out[i * 4 + 1] = argb >> 8 & 0xFF;
    out[i * 4 + 2] = argb & 0xFF;
    out[i * 4 + 3] = argb >> 24 & 0xFF;
  }
  return out;
}

void put(Uint8List rgba, int width, int x, int y, int argb) {
  final i = (y * width + x) * 4;
  rgba[i] = argb >> 16 & 0xFF;
  rgba[i + 1] = argb >> 8 & 0xFF;
  rgba[i + 2] = argb & 0xFF;
  rgba[i + 3] = argb >> 24 & 0xFF;
}

const white = 0xFFFFFFFF;
const black = 0xFF000000;
const red = 0xFFFF0000;

Future<int> pixel(PlumeController c, int x, int y) async {
  await c.idle;
  final data = await c.image!.toByteData(format: ui.ImageByteFormat.rawRgba);
  return pixelAt(data!.buffer.asUint8List(), c.width, x, y);
}

Future<ui.Image> square(Color color, int side) {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRect(
    Rect.fromLTWH(0, 0, side.toDouble(), side.toDouble()),
    Paint()..color = color,
  );
  return recorder.endRecording().toImage(side, side);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('fill', () {
    test('paints the connected area and stops at walls', () {
      final rgba = plain(5, 5, white);
      for (var y = 0; y < 5; y++) {
        put(rgba, 5, 2, y, black);
      }
      final out = floodFill(
        FillRequest(rgba: rgba, width: 5, height: 5, x: 0, y: 0, color: red),
      )!;
      expect(pixelAt(out, 5, 1, 4), red);
      expect(pixelAt(out, 5, 2, 2), black);
      expect(pixelAt(out, 5, 3, 0), white);
    });

    test('a click on the same colour or outside changes nothing', () {
      final rgba = plain(3, 3, red);
      FillRequest at(int x) =>
          FillRequest(rgba: rgba, width: 3, height: 3, x: x, y: 0, color: red);
      expect(floodFill(at(0)), isNull);
      expect(floodFill(at(9)), isNull);
    });

    test('takes in the soft edges close to the colour', () {
      final rgba = plain(3, 1, white);
      put(rgba, 3, 1, 0, 0xFFF0F0F0);
      put(rgba, 3, 2, 0, 0xFF808080);
      final out = floodFill(
        FillRequest(rgba: rgba, width: 3, height: 1, x: 0, y: 0, color: red),
      )!;
      expect(pixelAt(out, 3, 1, 0), red);
      expect(pixelAt(out, 3, 2, 0), 0xFF808080);
    });
  });

  group('shapes with Shift', () {
    test('lines snap to 45 degrees', () {
      final end = constrainEnd(Tool.line, Offset.zero, const Offset(10, 2));
      expect(end.dy, closeTo(0, 1e-9));
      final diagonal = constrainEnd(Tool.line, Offset.zero, const Offset(10, 9));
      expect(diagonal.dx, closeTo(diagonal.dy, 1e-9));
    });

    test('rectangles become squares, in any direction', () {
      expect(
        constrainEnd(Tool.rectangle, Offset.zero, const Offset(-10, 4)),
        const Offset(-10, 10),
      );
    });
  });

  group('controller', () {
    Future<PlumeController> sheet([int width = 40, int height = 30]) async {
      final c = PlumeController(loadStamp: (_) => square(const Color(0xFF00FF00), 10));
      await c.newImage(width, height);
      return c;
    }

    test('a new sheet is blank paper and has nothing to undo', () async {
      final c = await sheet();
      expect(c.width, 40);
      expect(await pixel(c, 39, 29), white);
      expect(c.canUndo, isFalse);
      expect(c.dirty, isFalse);
    });

    test('a brush stroke paints, and undo and redo follow it', () async {
      final c = await sheet()..setColor(const Color(red));
      c.pointerDown(const Offset(5, 15));
      c.pointerMove(const Offset(35, 15));
      c.pointerUp();
      expect(await pixel(c, 20, 15), red);
      expect(c.dirty, isTrue);

      await c.undo();
      expect(await pixel(c, 20, 15), white);
      await c.redo();
      expect(await pixel(c, 20, 15), red);
    });

    test('a new change forgets what could be redone', () async {
      final c = await sheet();
      c.pointerDown(const Offset(5, 5));
      c.pointerUp();
      await c.undo();
      expect(c.canRedo, isTrue);
      c.pointerDown(const Offset(9, 9));
      c.pointerUp();
      await c.idle;
      expect(c.canRedo, isFalse);
    });

    test('the eraser paints paper', () async {
      final c = await sheet()..setColor(const Color(black));
      c.pointerDown(const Offset(20, 15));
      c.pointerUp();
      c.setTool(Tool.eraser);
      c.pointerDown(const Offset(20, 15));
      c.pointerUp();
      expect(await pixel(c, 20, 15), white);
    });

    test('the pencil is hard, with no soft edges', () async {
      final c = await sheet()
        ..setTool(Tool.pencil)
        ..setSize(0)
        ..setColor(const Color(black));
      c.pointerDown(const Offset(3.7, 4.2));
      c.pointerUp();
      expect(await pixel(c, 3, 4), black);
      expect(await pixel(c, 4, 4), white);
      expect(await pixel(c, 3, 5), white);
    });

    test('a filled rectangle covers its inside', () async {
      final c = await sheet()
        ..setTool(Tool.rectangle)
        ..setFilled(true)
        ..setColor(const Color(red));
      c.pointerDown(const Offset(5, 5));
      c.pointerMove(const Offset(20, 20));
      c.pointerUp();
      expect(await pixel(c, 12, 12), red);
      expect(await pixel(c, 30, 12), white);
    });

    test('the bucket fills the sheet and the picker takes the colour back', () async {
      final c = await sheet()
        ..setTool(Tool.fill)
        ..setColor(const Color(red));
      await c.fill(const Offset(1, 1));
      expect(await pixel(c, 39, 29), red);

      c
        ..setColor(const Color(black))
        ..setTool(Tool.picker);
      await c.pick(const Offset(10, 10));
      expect(c.color.toARGB32(), red);
      expect(c.tool, Tool.fill);
    });

    test('a stamp lands centred on the click', () async {
      final c = await sheet(100, 100)..setSize(0);
      c.setStamp(3);
      await c.stamp(const Offset(50, 50));
      expect(await pixel(c, 50, 50), 0xFF00FF00);
      expect(await pixel(c, 50, 80), white);
      expect(await pixel(c, 2, 2), white);
    });

    test('the history keeps only the last changes', () async {
      final c = PlumeController(maxHistory: 3);
      await c.newImage(10, 10);
      for (var i = 0; i < 5; i++) {
        c.pointerDown(Offset(i.toDouble(), 1));
        c.pointerUp();
      }
      await c.idle;
      var undone = 0;
      while (c.canUndo) {
        await c.undo();
        undone++;
      }
      expect(undone, 3);
    });

    test('an opened picture becomes the sheet, on paper', () async {
      final c = await sheet();
      final picture = await square(const Color(0x00000000), 12);
      await c.openImage(picture, '/tmp/a.png');
      expect(c.width, 12);
      expect(await pixel(c, 5, 5), white);
      expect(c.path, '/tmp/a.png');
      expect(c.dirty, isFalse);
    });

    test('the zoom stays in its steps and fits big sheets', () async {
      final c = await sheet(2000, 1000);
      c.zoomIn();
      expect(c.zoom, 2);
      for (var i = 0; i < 10; i++) {
        c.zoomIn();
      }
      expect(c.zoom, zoomLevels.last);
      expect(c.fittingZoom(const Size(1100, 700)), .5);
      expect(max(c.fittingZoom(const Size(5000, 5000)), 1), 2);
    });
  });
}
