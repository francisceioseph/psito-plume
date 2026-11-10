import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/l10n.dart';
import '../labels.dart';
import '../molecules/palette_grid.dart';

Future<Color?> showColorDialog(BuildContext context, Color initial) =>
    showDialog<Color>(
      context: context,
      builder: (_) => ColorDialog(initial: initial),
    );

/// More colours: a grid of shades and a field for a colour code.
class ColorDialog extends StatefulWidget {
  const ColorDialog({super.key, required this.initial});

  final Color initial;

  @override
  State<ColorDialog> createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {
  late Color _color = widget.initial;
  late final _hex = TextEditingController(text: hexOf(widget.initial));

  static final _shades = [
    for (var row = 0; row < 6; row++)
      for (var hue = 0; hue < 12; hue++)
        HSLColor.fromAHSL(1, hue * 30.0, .75, .2 + row * .13).toColor(),
    for (var grey = 0; grey < 12; grey++)
      HSLColor.fromAHSL(1, 0, 0, grey / 11).toColor(),
  ];

  @override
  void dispose() {
    _hex.dispose();
    super.dispose();
  }

  void _choose(Color color) {
    setState(() => _color = color);
    _hex.text = hexOf(color);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.moreColors),
      content: SizedBox(
        width: 12 * 26,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PaletteGrid(
              colors: _shades,
              selected: _color,
              onChosen: _choose,
              perRow: 12,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0x33000000)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _hex,
                    maxLength: 7,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[#0-9a-fA-F]')),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.colorCode,
                      prefixText: '#',
                      border: const OutlineInputBorder(),
                      counterText: '',
                    ),
                    onChanged: (text) {
                      final parsed = parseHex(text);
                      if (parsed != null) setState(() => _color = parsed);
                    },
                    onSubmitted: (_) => Navigator.of(context).pop(_color),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_color),
          child: Text(l10n.choose),
        ),
      ],
    );
  }
}
