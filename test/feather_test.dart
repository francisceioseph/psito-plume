import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_plume/src/paint/operations.dart';
import 'package:psito_plume/src/paint/pixels.dart';
import 'package:psito_plume/src/paint/plume_controller.dart';
import 'package:psito_plume/src/platform/image_clipboard.dart';

/// A white bar standing in for the feather picture.
Future<ui.Image> bar() {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRect(
    const Rect.fromLTWH(0, 0, 4, 16),
    Paint()..color = const Color(0xFFFFFFFF),
  );
  return recorder.endRecording().toImage(4, 16);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('feathers go along the path, alternating sides, the same each time', () {
    final op = FeatherOp(
      points: const [Offset(0, 0), Offset(100, 0)],
      color: const Color(0xFFFF0000),
      size: 20,
      seed: 4,
    );
    final placements = op.placements().toList();
    // One every 9 pixels along 100 pixels, and one at the start.
    expect(placements.length, 12);
    final leans = [for (final (_, angle) in placements.skip(1)) angle.sign];
    for (var i = 1; i < leans.length; i++) {
      expect(leans[i], -leans[i - 1], reason: 'they alternate sides');
    }
    expect(op.placements().toList(), placements);
  });

  test('the brush paints tinted feathers and can be undone', () async {
    final c = PlumeController(
      clipboard: MemoryImageClipboard(),
      loadFeather: bar,
    );
    await c.newImage(120, 60);
    c
      ..setTool(Tool.feather)
      ..setSize(1)
      ..setColor(const Color(0xFF00FF00))
      ..pointerDown(const Offset(10, 40))
      ..pointerMove(const Offset(110, 40))
      ..pointerUp();
    await c.idle;
    final data = await c.image!.toByteData(format: ui.ImageByteFormat.rawRgba);
    final rgba = data!.buffer.asUint8List();
    var green = 0;
    for (var y = 0; y < 60; y++) {
      for (var x = 0; x < 120; x++) {
        if (pixelAt(rgba, 120, x, y) == 0xFF00FF00) green++;
      }
    }
    expect(green, greaterThan(100), reason: 'white times green is green');
    expect(c.canUndo, isTrue);
    expect(c.featherBrush, isNotNull);
  });
}
