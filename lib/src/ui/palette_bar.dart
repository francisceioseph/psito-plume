import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../paint/plume_controller.dart';
import 'colors.dart';

String hexOf(Color color) =>
    (color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase();

Color? parseHex(String text) {
  final clean = text.trim().replaceFirst('#', '');
  if (clean.length != 6) return null;
  final value = int.tryParse(clean, radix: 16);
  return value == null ? null : Color(0xFF000000 | value);
}

/// The colour in use, the palette and, on the right, where the pointer is.
class PaletteBar extends StatelessWidget {
  const PaletteBar({super.key, required this.controller});

  final PlumeController controller;

  Future<void> _more(BuildContext context) async {
    final chosen = await showDialog<Color>(
      context: context,
      builder: (_) => ColorDialog(initial: controller.color),
    );
    if (chosen != null) controller.setColor(chosen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cursor = controller.cursor;
    final inside = cursor != null &&
        cursor.dx >= 0 &&
        cursor.dy >= 0 &&
        cursor.dx < controller.width &&
        cursor.dy < controller.height;
    return Container(
      color: PsitoColors.panel,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Tooltip(
            message: l10n.moreColors,
            child: Semantics(
              button: true,
              label: l10n.currentColor(hexOf(controller.color)),
              excludeSemantics: true,
              child: InkWell(
                onTap: () => _more(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: controller.color,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: PsitoColors.onFelt, width: 2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final row in [
                      paletteColors.sublist(0, 10),
                      paletteColors.sublist(10),
                    ])
                      Row(
                        children: [
                          for (final color in row)
                            _Swatch(
                              color: color,
                              selected: color == controller.color,
                              label: l10n.colorSwatch(hexOf(color)),
                              onTap: () => controller.setColor(color),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          DefaultTextStyle(
            style: const TextStyle(
              color: PsitoColors.onFeltMuted,
              fontSize: 12,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  inside
                      ? l10n.position(cursor.dx.floor(), cursor.dy.floor())
                      : '',
                ),
                Text(l10n.imageSize(controller.width, controller.height)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: label,
    excludeSemantics: true,
    child: GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 22,
          height: 22,
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
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.moreColors),
      content: SizedBox(
        width: 12 * 26,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              children: [
                for (final shade in _shades)
                  _Swatch(
                    color: shade,
                    selected: shade == _color,
                    label: l10n.colorSwatch(hexOf(shade)),
                    onTap: () => _choose(shade),
                  ),
              ],
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
