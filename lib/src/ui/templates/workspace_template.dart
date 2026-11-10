import 'package:flutter/material.dart';

import '../atoms/colors.dart';

/// Where each part of the program goes: the bar on top, the tools on the left,
/// the sheet in the middle, with [overlay] above it, and the palette below.
class WorkspaceTemplate extends StatelessWidget {
  const WorkspaceTemplate({
    super.key,
    required this.topBar,
    required this.toolbox,
    required this.canvas,
    required this.bottomBar,
    this.overlay = const SizedBox.shrink(),
  });

  final Widget topBar;
  final Widget toolbox;
  final Widget canvas;
  final Widget bottomBar;
  final Widget overlay;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      topBar,
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            toolbox,
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        radius: 1.1,
                        colors: [
                          PsitoColors.feltGlow,
                          PsitoColors.felt,
                          PsitoColors.feltDark,
                        ],
                        stops: [0, .6, 1],
                      ),
                    ),
                  ),
                  canvas,
                  overlay,
                ],
              ),
            ),
          ],
        ),
      ),
      bottomBar,
    ],
  );
}
