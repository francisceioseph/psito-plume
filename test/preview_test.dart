import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_plume/src/paint/operations.dart';
import 'package:psito_plume/src/paint/plume_controller.dart';

Future<ui.Image> dot() {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRect(
    const Rect.fromLTWH(0, 0, 4, 4),
    Paint()..color = const Color(0xFF00FF00),
  );
  return recorder.endRecording().toImage(4, 4);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('moving the pointer tells only who follows the pointer', () async {
    final c = PlumeController();
    await c.newImage(10, 10);
    var whole = 0;
    var pointer = 0;
    c.addListener(() => whole++);
    c.pointer.addListener(() => pointer++);
    c.setCursor(const Offset(3, 4));
    expect(c.cursor, const Offset(3, 4));
    expect(pointer, 1);
    expect(whole, 0);
  });

  test('picking the stamp loads it, so that the preview can show it', () async {
    final asked = <int>[];
    final c = PlumeController(loadStamp: (level) async {
      asked.add(level);
      return dot();
    });
    await c.newImage(10, 10);
    c.setTool(Tool.stamp);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(asked, [c.stampLevel]);
    expect(c.stamps.containsKey(c.stampLevel), isTrue);
    c.setStamp(2);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(asked, [6, 2]);
    c.setStamp(6);
    expect(asked, [6, 2], reason: 'a stamp is loaded only once');
  });
}
