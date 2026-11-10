import 'package:flutter/material.dart';

import 'colors.dart';

/// An icon button of the top bar.
class BarButton extends StatelessWidget {
  const BarButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: Icon(icon, size: 21),
    style: IconButton.styleFrom(
      visualDensity: VisualDensity.compact,
      foregroundColor: PsitoColors.onFelt,
      disabledForegroundColor: PsitoColors.feltLight.withValues(alpha: .55),
      hoverColor: const Color(0x1AFFFFFF),
    ),
  );
}
