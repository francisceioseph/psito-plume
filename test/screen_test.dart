import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_plume/l10n/app_localizations.dart';
import 'package:psito_plume/src/paint/operations.dart';
import 'package:psito_plume/src/paint/pixels.dart';
import 'package:psito_plume/src/paint/plume_controller.dart';
import 'package:psito_plume/src/platform/close_guard.dart';
import 'package:psito_plume/src/ui/pages/plume_page.dart';

final guard = FakeCloseGuard();

Future<PlumeController> pumpScreen(
  WidgetTester tester, [
  Size size = const Size(1280, 800),
]) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final controller = PlumeController();
  addTearDown(controller.dispose);
  final ready = controller.newImage(300, 200);
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PlumePage(controller: controller, closeGuard: guard),
    ),
  );
  await tester.pump();
  await settle(tester, controller);
  await ready;
  return controller;
}

/// Lets the drawing queue finish: it waits on the engine, which only answers
/// in real time, and goes on in the test zone, which only moves with pumps.
Future<void> settle(WidgetTester tester, PlumeController c) async {
  var done = false;
  c.idle.then((_) => done = true);
  for (var i = 0; i < 200 && !done; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 5)),
    );
    await tester.pump();
  }
  expect(done, isTrue, reason: 'the drawing queue did not finish');
}

Future<void> finish(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

Finder get sheet => find.bySemanticsLabel(RegExp('^Folha de desenho'));

Future<int> pixel(WidgetTester tester, PlumeController c, int x, int y) async {
  var value = 0;
  await settle(tester, c);
  await tester.runAsync(() async {
    final data = await c.image!.toByteData(format: ui.ImageByteFormat.rawRgba);
    value = pixelAt(data!.buffer.asUint8List(), c.width, x, y);
  });
  return value;
}

void main() {
  testWidgets('dragging on the sheet draws', (tester) async {
    final handle = tester.ensureSemantics();
    final c = await pumpScreen(tester);
    final topLeft = tester.getTopLeft(sheet);
    await tester.dragFrom(topLeft + const Offset(20, 100), const Offset(200, 0));
    await tester.pump();
    expect(await pixel(tester, c, 120, 100), isNot(0xFFFFFFFF));
    expect(c.dirty, isTrue);
    expect(find.textContaining('Sem título *'), findsOneWidget);
    handle.dispose();
    await finish(tester);
  });

  testWidgets('the letters pick the tools', (tester) async {
    final c = await pumpScreen(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyE);
    expect(c.tool, Tool.eraser);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
    await tester.pump();
    expect(c.tool, Tool.stamp);
    expect(find.byTooltip('Rainha dourada'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('a click on the palette changes the colour', (tester) async {
    final c = await pumpScreen(tester);
    await tester.tap(find.bySemanticsLabel('Cor D9442E'));
    expect(c.color, const Color(0xFFD9442E));
    await finish(tester);
  });

  testWidgets('the colour code picks any colour', (tester) async {
    final handle = tester.ensureSemantics();
    final c = await pumpScreen(tester);
    await tester.tap(find.bySemanticsLabel(RegExp('^Cor principal')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '12AB34');
    await tester.tap(find.text('Escolher'));
    await tester.pumpAndSettle();
    expect(c.color, const Color(0xFF12AB34));
    handle.dispose();
    await finish(tester);
  });

  testWidgets('a new drawing asks before losing changes', (tester) async {
    final c = await pumpScreen(tester);
    c.dirty = true;
    await tester.tap(find.byTooltip('Novo desenho  (Ctrl+N)'));
    await tester.pumpAndSettle();
    expect(find.text('Descartar o desenho?'), findsOneWidget);
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '64');
    await tester.enterText(find.byType(TextField).last, '48');
    await tester.pump();
    await tester.tap(find.text('Criar'));
    await settle(tester, c);
    expect(c.width, 64);
    expect(c.height, 48);
    expect(c.dirty, isFalse);
    await finish(tester);
  });

  testWidgets('undo is in the bar once something is drawn', (tester) async {
    final c = await pumpScreen(tester);
    final undo = find.byTooltip('Desfazer  (Ctrl+Z)');
    expect(
      tester.widget<IconButton>(
        find.ancestor(of: undo, matching: find.byType(IconButton)),
      ).onPressed,
      isNull,
    );
    c.pointerDown(const Offset(10, 10));
    c.pointerUp();
    await settle(tester, c);
    expect(c.canUndo, isTrue);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyZ);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await settle(tester, c);
    expect(c.canUndo, isFalse);
    expect(c.canRedo, isTrue);
    await finish(tester);
  });

  testWidgets('fits small and large windows without overflowing', (tester) async {
    for (final size in const [Size(640, 420), Size(1920, 1080), Size(800, 1200)]) {
      await pumpScreen(tester, size);
      expect(tester.takeException(), isNull);
    }
    await finish(tester);
  });

  testWidgets('closing with nothing new closes at once', (tester) async {
    await pumpScreen(tester);
    expect(await guard.canClose!(), isTrue);
    await finish(tester);
  });

  testWidgets('closing with changes asks first', (tester) async {
    final c = await pumpScreen(tester);
    c.dirty = true;
    var closes = guard.canClose!();
    await tester.pumpAndSettle();
    expect(find.text('Salvar as mudanças em Sem título?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(await closes, isFalse);

    closes = guard.canClose!();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Não salvar'));
    await tester.pumpAndSettle();
    expect(await closes, isTrue);
    await finish(tester);
  });

  testWidgets('resizing keeps the proportion', (tester) async {
    final c = await pumpScreen(tester);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyW);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(find.text('Manter a proporção'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, '600');
    await tester.pump();
    expect(find.text('400'), findsOneWidget);
    await tester.tap(find.text('Aplicar'));
    await tester.pump();
    await settle(tester, c);
    expect((c.width, c.height), (600, 400));
    await finish(tester);
  });

  testWidgets('the right button paints with the second colour', (tester) async {
    final handle = tester.ensureSemantics();
    final c = await pumpScreen(tester);
    c.setSecondary(const Color(0xFF00FF00));
    final topLeft = tester.getTopLeft(sheet);
    final gesture = await tester.startGesture(
      topLeft + const Offset(20, 60),
      buttons: kSecondaryMouseButton,
      kind: PointerDeviceKind.mouse,
    );
    await gesture.moveBy(const Offset(150, 0));
    await gesture.up();
    await tester.pump();
    expect(await pixel(tester, c, 90, 60), 0xFF00FF00);
    handle.dispose();
    await finish(tester);
  });

  testWidgets('X swaps the colours and the palette takes the right button', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final c = await pumpScreen(tester);
    await tester.tap(
      find.bySemanticsLabel('Cor D9442E'),
      buttons: kSecondaryMouseButton,
    );
    expect(c.secondary, const Color(0xFFD9442E));
    final before = c.color;
    await tester.sendKeyEvent(LogicalKeyboardKey.keyX);
    expect(c.color, const Color(0xFFD9442E));
    expect(c.secondary, before);
    handle.dispose();
    await finish(tester);
  });
}
