import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/colors.dart';
import '../labels.dart';

/// The colour in use, which opens more colours when clicked.
class CurrentColorButton extends StatelessWidget {
  const CurrentColorButton({
    super.key,
    required this.color,
    required this.onTap,
  });

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Tooltip(
      message: l10n.moreColors,
      child: Semantics(
        button: true,
        label: l10n.currentColor(hexOf(color)),
        excludeSemantics: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: PsitoColors.onFelt, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
