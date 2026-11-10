import 'package:flutter/material.dart';

import 'colors.dart';

/// A small square of colour that can be clicked.
class ColorSwatchButton extends StatelessWidget {
  const ColorSwatchButton({
    super.key,
    required this.color,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.onSecondaryTap,
    this.size = 22,
  });

  final Color color;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onSecondaryTap;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: label,
    excludeSemantics: true,
    child: GestureDetector(
      onTap: onTap,
      onSecondaryTap: onSecondaryTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: size,
          height: size,
          margin: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: selected ? PsitoColors.accent : const Color(0x33000000),
              width: selected ? 2 : 1,
            ),
          ),
        ),
      ),
    ),
  );
}
