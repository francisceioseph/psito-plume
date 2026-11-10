import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/colors.dart';

/// Where the pointer is on the drawing, and how big the drawing is.
class StatusInfo extends StatelessWidget {
  const StatusInfo({
    super.key,
    required this.cursor,
    required this.width,
    required this.height,
  });

  final Offset? cursor;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final point = cursor;
    final inside = point != null &&
        point.dx >= 0 &&
        point.dy >= 0 &&
        point.dx < width &&
        point.dy < height;
    return DefaultTextStyle(
      style: const TextStyle(
        color: PsitoColors.onFeltMuted,
        fontSize: 12,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(inside ? l10n.position(point.dx.floor(), point.dy.floor()) : ''),
          Text(l10n.imageSize(width, height)),
        ],
      ),
    );
  }
}
