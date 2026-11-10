import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/bar_button.dart';
import '../atoms/colors.dart';

/// Zoom out, the zoom in use (a click goes back to 100%) and zoom in.
class ZoomControls extends StatelessWidget {
  const ZoomControls({
    super.key,
    required this.zoom,
    required this.onZoomOut,
    required this.onZoomIn,
    required this.onActualSize,
  });

  final double zoom;
  final VoidCallback? onZoomOut;
  final VoidCallback? onZoomIn;
  final VoidCallback onActualSize;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BarButton(
          tooltip: '${l10n.zoomOut}  (Ctrl+-)',
          icon: Icons.zoom_out_rounded,
          onPressed: onZoomOut,
        ),
        Tooltip(
          message: '${l10n.actualSize}  (Ctrl+0)',
          child: TextButton(
            onPressed: onActualSize,
            style: TextButton.styleFrom(
              foregroundColor: PsitoColors.onFelt,
              minimumSize: const Size(52, 36),
              padding: const EdgeInsets.symmetric(horizontal: 6),
            ),
            child: Text(
              '${(zoom * 100).round()}%',
              style: const TextStyle(
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        BarButton(
          tooltip: '${l10n.zoomIn}  (Ctrl++)',
          icon: Icons.zoom_in_rounded,
          onPressed: onZoomIn,
        ),
      ],
    );
  }
}
