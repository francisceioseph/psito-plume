import 'package:flutter/material.dart';

import 'colors.dart';

/// A square button of the toolbox that stays marked while it is chosen.
class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    super.key,
    required this.tooltip,
    required this.selected,
    required this.onPressed,
    required this.child,
    this.size = 40,
  });

  final String tooltip;
  final bool selected;
  final VoidCallback onPressed;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Semantics(
      button: true,
      selected: selected,
      label: tooltip,
      excludeSemantics: true,
      child: Material(
        color: selected ? PsitoColors.panelLight : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: selected ? PsitoColors.accent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: IconTheme(
            data: const IconThemeData(color: PsitoColors.onFelt),
            child: SizedBox.square(
              dimension: size,
              child: Center(child: child),
            ),
          ),
        ),
      ),
    ),
  );
}
