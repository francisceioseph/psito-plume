import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/choice_button.dart';
import '../atoms/colors.dart';

/// The two fonts of the text tool, each shown in itself.
class FontPicker extends StatelessWidget {
  const FontPicker({super.key, required this.serif, required this.onChanged});

  final bool serif;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget sample(String family) => Text(
      'Aa',
      style: TextStyle(
        fontFamily: family,
        fontSize: 17,
        color: PsitoColors.onFelt,
      ),
    );
    return Wrap(
      spacing: 4,
      children: [
        ChoiceButton(
          tooltip: l10n.fontSans,
          selected: !serif,
          onPressed: () => onChanged(false),
          child: sample('PlumeSans'),
        ),
        ChoiceButton(
          tooltip: l10n.fontSerif,
          selected: serif,
          onPressed: () => onChanged(true),
          child: sample('CardSerif'),
        ),
      ],
    );
  }
}
