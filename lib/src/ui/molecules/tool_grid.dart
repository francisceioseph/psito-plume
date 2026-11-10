import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../paint/operations.dart';
import '../atoms/choice_button.dart';
import '../labels.dart';

/// Every tool, two by two.
class ToolGrid extends StatelessWidget {
  const ToolGrid({super.key, required this.selected, required this.onChosen});

  final Tool selected;
  final ValueChanged<Tool> onChosen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final tool in Tool.values)
          ChoiceButton(
            tooltip: '${toolName(l10n, tool)}  (${toolKey(tool)})',
            selected: selected == tool,
            onPressed: () => onChosen(tool),
            child: Icon(toolIcon(tool), size: 20),
          ),
      ],
    );
  }
}
