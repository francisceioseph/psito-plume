import 'package:flutter/material.dart';

import 'colors.dart';

/// The line between the groups of the toolbox.
class PanelDivider extends StatelessWidget {
  const PanelDivider({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Divider(height: 1, color: PsitoColors.panelLight),
  );
}
