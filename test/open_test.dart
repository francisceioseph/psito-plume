import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_plume/l10n/app_localizations.dart';
import 'package:psito_plume/src/paint/plume_controller.dart';
import 'package:psito_plume/src/platform/close_guard.dart';
import 'package:psito_plume/src/ui/pages/plume_page.dart';

/// Writes a [width] × [height] PNG to a temporary folder.
Future<String> png(int width, int height) async {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRect(
    Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    Paint()..color = const Color(0xFF3366CC),
  );
  final image = await recorder.endRecording().toImage(width, height);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  final folder = await Directory.systemTemp.createTemp('plume');
  final file = File('${folder.path}/bird.png');
  await file.writeAsBytes(data!.buffer.asUint8List());
  return file.path;
}

/// Pumps until [done], letting files and the drawing queue answer.
Future<void> until(WidgetTester tester, bool Function() done) async {
  for (var i = 0; i < 300 && !done(); i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 5)),
    );
    await tester.pump();
  }
  expect(done(), isTrue);
}

Future<PlumeController> pump(WidgetTester tester, {String? initialPath}) async {
  tester.view.physicalSize = const Size(1280, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final c = PlumeController();
  addTearDown(c.dispose);
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PlumePage(
        controller: c,
        closeGuard: FakeCloseGuard(),
        initialPath: initialPath,
      ),
    ),
  );
  await until(tester, () => c.image != null);
  return c;
}

void main() {
  testWidgets('a picture given at the start opens', (tester) async {
    final path = (await tester.runAsync(() => png(64, 32)))!;
    final c = await pump(tester, initialPath: path);
    await until(tester, () => c.width == 64);
    await tester.pump();
    expect(c.path, path);
    expect(find.textContaining('bird.png'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a missing file says it could not be opened', (tester) async {
    await pump(tester, initialPath: '/no/such/picture.png');
    await until(
      tester,
      () => find.text('Não foi possível abrir picture.png.').evaluate().isNotEmpty,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a dropped picture opens, asking first if there are changes', (
    tester,
  ) async {
    final path = (await tester.runAsync(() => png(20, 10)))!;
    final c = await pump(tester);
    c.dirty = true;
    final page = tester.state<PlumePageState>(find.byType(PlumePage));
    page.openDropped([path]);
    await tester.pumpAndSettle();
    expect(find.text('Descartar o desenho?'), findsOneWidget);
    await tester.tap(find.text('Descartar'));
    await tester.pump();
    await until(tester, () => c.width == 20);
    await tester.pumpWidget(const SizedBox());
  });
}
