import 'package:flutter/material.dart';

import '../../paint/plume_controller.dart';
import '../atoms/colors.dart';
import '../molecules/color_pair.dart';
import '../molecules/palette_grid.dart';
import '../molecules/status_info.dart';
import 'color_dialog.dart';

/// The colour in use, the palette and, on the right, where the pointer is.
class PaletteBar extends StatelessWidget {
  const PaletteBar({super.key, required this.controller});

  final PlumeController controller;

  Future<void> _more(BuildContext context, {bool secondary = false}) async {
    final c = controller;
    final chosen = await showColorDialog(
      context,
      secondary ? c.secondary : c.color,
    );
    if (chosen == null) return;
    secondary ? c.setSecondary(chosen) : c.setColor(chosen);
  }

  @override
  Widget build(BuildContext context) => Container(
    color: PsitoColors.panel,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    child: Row(
      children: [
        ColorPair(
          primary: controller.color,
          secondary: controller.secondary,
          onPrimaryTap: () => _more(context),
          onSecondaryTap: () => _more(context, secondary: true),
          onSwap: controller.swapColors,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: PaletteGrid(
                colors: paletteColors,
                selected: controller.color,
                onChosen: controller.setColor,
                onSecondaryChosen: controller.setSecondary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        StatusInfo(
          cursor: controller.cursor,
          width: controller.width,
          height: controller.height,
        ),
      ],
    ),
  );
}
