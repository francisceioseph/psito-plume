import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'src/ui/colors.dart';
import 'src/ui/plume_screen.dart';

void main() => runApp(const PsitoPlumeApp());

class PsitoPlumeApp extends StatelessWidget {
  const PsitoPlumeApp({super.key});

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
    home: const PlumeScreen(),
  );
}
