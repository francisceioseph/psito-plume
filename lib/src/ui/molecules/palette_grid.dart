import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/color_swatch.dart';
import '../labels.dart';

/// Colours in rows of [perRow].
class PaletteGrid extends StatelessWidget {
  const PaletteGrid({
    super.key,
    required this.colors,
    required this.selected,
    required this.onChosen,
    this.onSecondaryChosen,
    this.perRow = 10,
  });

  final List<Color> colors;
  final Color selected;
  final ValueChanged<Color> onChosen;
  final ValueChanged<Color>? onSecondaryChosen;
  final int perRow;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var start = 0; start < colors.length; start += perRow)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final color in colors.skip(start).take(perRow))
                ColorSwatchButton(
                  color: color,
                  selected: color == selected,
                  label: l10n.colorSwatch(hexOf(color)),
                  onTap: () => onChosen(color),
                  onSecondaryTap: onSecondaryChosen == null
                      ? null
                      : () => onSecondaryChosen!(color),
                ),
            ],
          ),
      ],
    );
  }
}
