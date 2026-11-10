import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/choice_button.dart';
import '../atoms/colors.dart';

/// The four sizes of a tool, drawn as dots that grow.
class SizePicker extends StatelessWidget {
  const SizePicker({
    super.key,
    required this.sizes,
    required this.selected,
    required this.onChosen,
  });

  final List<double> sizes;
  final int selected;
  final ValueChanged<int> onChosen;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 4,
    runSpacing: 4,
    children: [
      for (var i = 0; i < sizes.length; i++)
        ChoiceButton(
          tooltip: context.l10n.sizeOption(sizes[i].round()),
          selected: selected == i,
          onPressed: () => onChosen(i),
          child: Container(
            width: 4.0 + i * 4,
            height: 4.0 + i * 4,
            decoration: const BoxDecoration(
              color: PsitoColors.onFelt,
              shape: BoxShape.circle,
            ),
          ),
        ),
    ],
  );
}
