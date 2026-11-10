import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/colors.dart';

/// Takes files dragged from other programs, and says so while they hover.
class DropZone extends StatefulWidget {
  const DropZone({super.key, required this.onFiles, required this.child});

  final ValueChanged<List<String>> onFiles;
  final Widget child;

  @override
  State<DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<DropZone> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) => DropTarget(
    onDragEntered: (_) => setState(() => _hovering = true),
    onDragExited: (_) => setState(() => _hovering = false),
    onDragDone: (details) {
      setState(() => _hovering = false);
      final paths = [for (final file in details.files) file.path];
      if (paths.isNotEmpty) widget.onFiles(paths);
    },
    child: Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_hovering)
          IgnorePointer(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0x55000000),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: PsitoColors.accent, width: 3),
              ),
              alignment: Alignment.center,
              child: Text(
                context.l10n.dropHint,
                style: const TextStyle(
                  color: PsitoColors.onFelt,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
