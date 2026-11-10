import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../paint/operations.dart';

/// Names, keys and icons shown for the things of the program, in one place,
/// so that the toolbox, the menus and the help always say the same.

String toolName(AppLocalizations l10n, Tool tool) => switch (tool) {
  Tool.select => l10n.toolSelect,
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
  Tool.select => 'M',
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

IconData toolIcon(Tool tool) => switch (tool) {
  Tool.select => Icons.highlight_alt_rounded,
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

String stampAsset(int level) => 'assets/stamps/$level.png';

String hexOf(Color color) => (color.toARGB32() & 0xFFFFFF)
    .toRadixString(16)
    .padLeft(6, '0')
    .toUpperCase();

Color? parseHex(String text) {
  final clean = text.trim().replaceFirst('#', '');
  if (clean.length != 6) return null;
  final value = int.tryParse(clean, radix: 16);
  return value == null ? null : Color(0xFF000000 | value);
}

String fileName(AppLocalizations l10n, String? path) =>
    path == null ? l10n.untitled : path.split(RegExp(r'[/\\]')).last;
