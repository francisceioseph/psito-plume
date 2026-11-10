import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_plume/l10n/app_localizations.dart';
import 'package:psito_plume/src/paint/operations.dart';
import 'package:psito_plume/src/paint/pixels.dart';
import 'package:psito_plume/src/paint/plume_controller.dart';
import 'package:psito_plume/src/platform/close_guard.dart';
import 'package:psito_plume/src/ui/pages/plume_page.dart';

/// How many pixels of a band of the drawing are not paper.
Future<int> inked(PlumeController c, Rect area) async {
  await c.idle;
  final data = await c.image!.toByteData(format: ui.ImageByteFormat.rawRgba);
  final rgba = data!.buffer.asUint8List();
  var count = 0;
  for (var y = area.top.toInt(); y < area.bottom; y++) {
    for (var x = area.left.toInt(); x < area.right; x++) {
      if (pixelAt(rgba, c.width, x, y) != 0xFFFFFFFF) count++;
    }
  }
  return count;
}

Future<void> settle(WidgetTester tester, PlumeController c) async {
  var done = false;
  c.idle.then((_) => done = true);
  for (var i = 0; i < 200 && !done; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 5)),
    );
    await tester.pump();
  }
}

void main() {
  group('controller', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    test('a typed text becomes pixels where it was started', () async {
      final c = PlumeController();
      await c.newImage(200, 80);
      c
        ..setTool(Tool.text)
        ..setSize(3)
        ..pointerDown(const Offset(10, 10));
      c.textDraft!.text = 'Psito';
      c.commitText();
      expect(c.textDraft, isNull);
      expect(await inked(c, const Rect.fromLTWH(10, 10, 150, 60)), greaterThan(200));
      expect(await inked(c, const Rect.fromLTWH(0, 0, 200, 8)), 0);
      expect(c.canUndo, isTrue);
    });

    test('an empty text leaves nothing', () async {
      final c = PlumeController();
      await c.newImage(50, 50);
      c
        ..setTool(Tool.text)
        ..pointerDown(const Offset(5, 5))
        ..commitText();
      await c.idle;
      expect(c.canUndo, isFalse);
    });

    test('a click elsewhere or another tool finishes the text', () async {
      final c = PlumeController();
      await c.newImage(200, 120);
      c
        ..setTool(Tool.text)
        ..pointerDown(const Offset(5, 5));
      c.textDraft!.text = 'um';
      c.pointerDown(const Offset(5, 60));
      expect(c.textDraft!.position, const Offset(5, 60));
      c.textDraft!.text = 'dois';
      c.setTool(Tool.brush);
      expect(c.textDraft, isNull);
      expect(await inked(c, const Rect.fromLTWH(0, 0, 200, 50)), greaterThan(0));
      expect(await inked(c, const Rect.fromLTWH(0, 60, 200, 50)), greaterThan(0));
    });

    test('colour, size and font follow the draft while it is typed', () async {
      final c = PlumeController();
      await c.newImage(50, 50);
      c
        ..setTool(Tool.text)
        ..pointerDown(const Offset(5, 5))
        ..setColor(const Color(0xFFFF0000))
        ..setSize(2)
        ..setTextSerif(true);
      final draft = c.textDraft!;
      expect(draft.color, const Color(0xFFFF0000));
      expect(draft.size, Tool.text.sizes[2]);
      expect(draft.serif, isTrue);
    });
  });

  testWidgets('typing on the sheet, then Enter, writes the text', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final c = PlumeController();
    addTearDown(c.dispose);
    final ready = c.newImage(300, 200);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PlumePage(controller: c, closeGuard: FakeCloseGuard()),
      ),
    );
    await settle(tester, c);
    await ready;
    await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
    expect(c.tool, Tool.text);

    final handle = tester.ensureSemantics();
    final sheet = find.bySemanticsLabel(RegExp('^Folha de desenho'));
    await tester.tapAt(tester.getTopLeft(sheet) + const Offset(20, 20));
    await tester.pump();
    handle.dispose();
    expect(find.byType(TextField), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'pato');
    await tester.sendKeyEvent(LogicalKeyboardKey.keyP);
    expect(c.tool, Tool.text, reason: 'a letter typed in the text picks no tool');

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await settle(tester, c);
    expect(c.textDraft, isNull);
    expect(find.byType(TextField), findsNothing);
    expect(c.canUndo, isTrue);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}
