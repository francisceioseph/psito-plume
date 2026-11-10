import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../paint/operations.dart';
import '../paint/plume_controller.dart';
import 'colors.dart';

String toolName(AppLocalizations l10n, Tool tool) => switch (tool) {
  Tool.pencil => l10n.toolPencil,
  Tool.brush => l10n.toolBrush,
  Tool.eraser => l10n.toolEraser,
  Tool.fill => l10n.toolFill,
  Tool.picker => l10n.toolPicker,
  Tool.line => l10n.toolLine,
  Tool.rectangle => l10n.toolRectangle,
  Tool.ellipse => l10n.toolEllipse,
  Tool.stamp => l10n.toolStamp,
};

/// The key that picks each tool.
String toolKey(Tool tool) => switch (tool) {
  Tool.pencil => 'P',
  Tool.brush => 'B',
  Tool.eraser => 'E',
  Tool.fill => 'F',
  Tool.picker => 'I',
  Tool.line => 'L',
  Tool.rectangle => 'R',
  Tool.ellipse => 'O',
  Tool.stamp => 'S',
};

IconData _icon(Tool tool) => switch (tool) {
  Tool.pencil => Icons.edit_rounded,
  Tool.brush => Icons.brush_rounded,
  Tool.eraser => Icons.auto_fix_normal_rounded,
  Tool.fill => Icons.format_color_fill_rounded,
  Tool.picker => Icons.colorize_rounded,
  Tool.line => Icons.horizontal_rule_rounded,
  Tool.rectangle => Icons.crop_square_rounded,
  Tool.ellipse => Icons.circle_outlined,
  Tool.stamp => Icons.approval_rounded,
};

String birdName(AppLocalizations l10n, int level) => switch (level) {
  1 => l10n.bird1,
  2 => l10n.bird2,
  3 => l10n.bird3,
  4 => l10n.bird4,
  5 => l10n.bird5,
  6 => l10n.bird6,
  7 => l10n.bird7,
  8 => l10n.bird8,
  9 => l10n.bird9,
  10 => l10n.bird10,
  _ => l10n.bird11,
};

/// The tools, and under them the options of the one in use.
class Toolbox extends StatelessWidget {
  const Toolbox({super.key, required this.controller});

  static const width = 104.0;

  final PlumeController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tool = controller.tool;
    return Container(
      width: width,
      color: PsitoColors.panel,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final each in Tool.values)
                  _Choice(
                    tooltip: '${toolName(l10n, each)}  (${toolKey(each)})',
                    selected: tool == each,
                    onPressed: () => controller.setTool(each),
                    child: Icon(_icon(each), size: 20),
                  ),
              ],
            ),
            if (tool.hasSizes) ...[
              const _Divider(),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (var i = 0; i < 4; i++)
                    _Choice(
                      tooltip: l10n.sizeOption(tool.sizes[i].round()),
                      selected: controller.sizeIndex == i,
                      onPressed: () => controller.setSize(i),
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
              ),
            ],
            if (tool == Tool.rectangle || tool == Tool.ellipse) ...[
              const _Divider(),
              Wrap(
                spacing: 4,
                children: [
                  _Choice(
                    tooltip: l10n.outline,
                    selected: !controller.filled,
                    onPressed: () => controller.setFilled(false),
                    child: Icon(
                      tool == Tool.ellipse
                          ? Icons.circle_outlined
                          : Icons.crop_square_rounded,
                      size: 20,
                    ),
                  ),
                  _Choice(
                    tooltip: l10n.filled,
                    selected: controller.filled,
                    onPressed: () => controller.setFilled(true),
                    child: Icon(
                      tool == Tool.ellipse
                          ? Icons.circle
                          : Icons.square_rounded,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
            if (tool == Tool.stamp) ...[
              const _Divider(),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (var level = 1; level <= 11; level++)
                    _Choice(
                      tooltip: birdName(l10n, level),
                      selected: controller.stampLevel == level,
                      onPressed: () => controller.setStamp(level),
                      child: Image.asset(
                        'assets/stamps/$level.png',
                        width: 30,
                        height: 30,
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Divider(height: 1, color: PsitoColors.panelLight),
  );
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.tooltip,
    required this.selected,
    required this.onPressed,
    required this.child,
  });

  final String tooltip;
  final bool selected;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Semantics(
      button: true,
      selected: selected,
      label: tooltip,
      excludeSemantics: true,
      child: Material(
        color: selected ? PsitoColors.panelLight : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: selected ? PsitoColors.accent : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: IconTheme(
            data: const IconThemeData(color: PsitoColors.onFelt),
            child: SizedBox.square(dimension: 40, child: Center(child: child)),
          ),
        ),
      ),
    ),
  );
}
