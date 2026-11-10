import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'src/ui/atoms/colors.dart';
import 'src/ui/pages/plume_page.dart';

/// A file given on the command line, as "Open with" does, opens at once.
void main(List<String> args) =>
    runApp(PsitoPlumeApp(initialPath: args.isEmpty ? null : args.first));

class PsitoPlumeApp extends StatelessWidget {
  const PsitoPlumeApp({super.key, this.initialPath});

  final String? initialPath;

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: PsitoColors.felt,
        brightness: Brightness.light,
      ),
    ),
    home: PlumePage(initialPath: initialPath),
  );
}
