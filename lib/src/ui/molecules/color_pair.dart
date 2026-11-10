import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/colors.dart';
import '../labels.dart';

/// The two colours in use: the main one in front, for the left button, and
/// the second one behind, for the right button. A click on either opens more
/// colours for it, and the arrows swap them.
class ColorPair extends StatelessWidget {
  const ColorPair({
    super.key,
    required this.primary,
    required this.secondary,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
    required this.onSwap,
  });

  final Color primary;
  final Color secondary;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;
  final VoidCallback onSwap;

  static const _side = 34.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget square(Color color, String label, VoidCallback onTap) => Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: GestureDetector(
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: _side,
              height: _side,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: PsitoColors.onFelt, width: 2),
              ),
            ),
          ),
        ),
      ),
    );
    return SizedBox(
      width: _side + 22,
      height: _side + 14,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: square(
              secondary,
              l10n.secondaryColor(hexOf(secondary)),
              onSecondaryTap,
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: square(
              primary,
              l10n.primaryColor(hexOf(primary)),
              onPrimaryTap,
            ),
          ),
          Positioned(
            right: -6,
            top: -8,
            child: IconButton(
              tooltip: '${l10n.swapColors}  (X)',
              onPressed: onSwap,
              iconSize: 15,
              visualDensity: VisualDensity.compact,
              color: PsitoColors.onFeltMuted,
              icon: const Icon(Icons.swap_horiz_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
