import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/choice_button.dart';

/// Outline only or filled, for the shapes that have an inside.
class FillPicker extends StatelessWidget {
  const FillPicker({
    super.key,
    required this.filled,
    required this.round,
    required this.onChanged,
  });

  final bool filled;

  /// Draws the choices as circles instead of squares.
  final bool round;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: 4,
      children: [
        ChoiceButton(
          tooltip: l10n.outline,
          selected: !filled,
          onPressed: () => onChanged(false),
          child: Icon(
            round ? Icons.circle_outlined : Icons.crop_square_rounded,
            size: 20,
          ),
        ),
        ChoiceButton(
          tooltip: l10n.filled,
          selected: filled,
          onPressed: () => onChanged(true),
          child: Icon(
            round ? Icons.circle : Icons.square_rounded,
            size: 20,
          ),
        ),
      ],
    );
  }
}
