import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/choice_button.dart';
import '../labels.dart';

const stampCount = 11;

/// The cockatiels that can be stamped.
class StampPicker extends StatelessWidget {
  const StampPicker({super.key, required this.selected, required this.onChosen});

  final int selected;
  final ValueChanged<int> onChosen;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 4,
    runSpacing: 4,
    children: [
      for (var level = 1; level <= stampCount; level++)
        ChoiceButton(
          tooltip: birdName(context.l10n, level),
          selected: selected == level,
          onPressed: () => onChosen(level),
          child: Image.asset(
            stampAsset(level),
            width: 30,
            height: 30,
            filterQuality: FilterQuality.medium,
          ),
        ),
    ],
  );
}
