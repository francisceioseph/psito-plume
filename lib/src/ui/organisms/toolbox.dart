import 'package:flutter/material.dart';

import '../../paint/operations.dart';
import '../../paint/plume_controller.dart';
import '../atoms/colors.dart';
import '../atoms/panel_divider.dart';
import '../molecules/fill_picker.dart';
import '../molecules/font_picker.dart';
import '../molecules/size_picker.dart';
import '../molecules/stamp_picker.dart';
import '../molecules/tool_grid.dart';

/// The tools, and under them the options of the one in use.
class Toolbox extends StatelessWidget {
  const Toolbox({super.key, required this.controller});

  static const width = 104.0;

  final PlumeController controller;

  @override
  Widget build(BuildContext context) {
    final tool = controller.tool;
    return Container(
      width: width,
      color: PsitoColors.panel,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ToolGrid(selected: tool, onChosen: controller.setTool),
            if (tool.hasSizes) ...[
              const PanelDivider(),
              SizePicker(
                sizes: tool.sizes,
                selected: controller.sizeIndex,
                onChosen: controller.setSize,
              ),
            ],
            if (tool == Tool.rectangle || tool == Tool.ellipse) ...[
              const PanelDivider(),
              FillPicker(
                filled: controller.filled,
                round: tool == Tool.ellipse,
                onChanged: controller.setFilled,
              ),
            ],
            if (tool == Tool.text) ...[
              const PanelDivider(),
              FontPicker(
                serif: controller.textSerif,
                onChanged: controller.setTextSerif,
              ),
            ],
            if (tool == Tool.stamp) ...[
              const PanelDivider(),
              StampPicker(
                selected: controller.stampLevel,
                onChosen: controller.setStamp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
