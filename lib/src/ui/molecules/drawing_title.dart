import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/colors.dart';
import '../labels.dart';

/// The mascot, the name of the program and the name of the drawing, with a
/// star while there are changes not saved.
class DrawingTitle extends StatelessWidget {
  const DrawingTitle({
    super.key,
    required this.path,
    required this.dirty,
    required this.showAppName,
  });

  final String? path;
  final bool dirty;
  final bool showAppName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = fileName(l10n, path);
    return Row(
      children: [
        ExcludeSemantics(
          child: Image.asset(
            'assets/mascot/peek.png',
            height: 34,
            filterQuality: FilterQuality.medium,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                if (showAppName)
                  TextSpan(
                    text: '${l10n.appTitle}   ',
                    style: const TextStyle(
                      fontFamily: 'CardSerif',
                      fontSize: 19,
                      color: PsitoColors.onFelt,
                    ),
                  ),
                TextSpan(
                  text: dirty ? '$name *' : name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: PsitoColors.onFeltMuted,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
