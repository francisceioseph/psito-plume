import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../paint/plume_controller.dart';
import '../version.dart';
import 'colors.dart';

enum _MenuItem { saveAs, howToUse, about }

/// What the bar asks the screen to do with files.
class FileActions {
  const FileActions({
    required this.newImage,
    required this.open,
    required this.save,
    required this.saveAs,
  });

  final VoidCallback newImage;
  final VoidCallback open;
  final VoidCallback save;
  final VoidCallback saveAs;
}

String fileName(AppLocalizations l10n, String? path) =>
    path == null ? l10n.untitled : path.split(RegExp(r'[/\\]')).last;

/// The bar above the sheet: the name of the drawing and the actions.
class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.controller, required this.files});

  static const _compact = 760.0;

  final PlumeController controller;
  final FileActions files;

  void _about(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showAboutDialog(
      context: context,
      applicationName: l10n.appTitle,
      applicationVersion: appVersion,
      applicationIcon: Image.asset('assets/mascot/peek.png', width: 48),
      applicationLegalese: l10n.aboutLegal,
      children: [
        const SizedBox(height: 16),
        Text(l10n.aboutBody),
        const SizedBox(height: 8),
        const SelectableText('https://francisceioseph.github.io/psito-plume/'),
      ],
    );
  }

  void _howToUse(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.howToUse),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(child: Text(l10n.howToUseBody)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final name = fileName(l10n, controller.path);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [PsitoColors.barTop, PsitoColors.barBottom],
        ),
        border: Border(bottom: BorderSide(color: Color(0x33000000))),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final compact = box.maxWidth < _compact;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
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
                        if (!compact)
                          TextSpan(
                            text: '${l10n.appTitle}   ',
                            style: const TextStyle(
                              fontFamily: 'CardSerif',
                              fontSize: 19,
                              color: PsitoColors.onFelt,
                            ),
                          ),
                        TextSpan(
                          text: controller.dirty ? '$name *' : name,
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
                _BarButton(
                  tooltip: '${l10n.newImage}  (Ctrl+N)',
                  icon: Icons.note_add_outlined,
                  onPressed: files.newImage,
                ),
                _BarButton(
                  tooltip: '${l10n.open}  (Ctrl+O)',
                  icon: Icons.folder_open_outlined,
                  onPressed: files.open,
                ),
                _BarButton(
                  tooltip: '${l10n.save}  (Ctrl+S)',
                  icon: Icons.save_outlined,
                  onPressed: files.save,
                ),
                const _Gap(),
                _BarButton(
                  tooltip: '${l10n.undo}  (Ctrl+Z)',
                  icon: Icons.undo_rounded,
                  onPressed: controller.canUndo ? controller.undo : null,
                ),
                _BarButton(
                  tooltip: '${l10n.redo}  (Ctrl+Y)',
                  icon: Icons.redo_rounded,
                  onPressed: controller.canRedo ? controller.redo : null,
                ),
                const _Gap(),
                _BarButton(
                  tooltip: '${l10n.zoomOut}  (Ctrl+-)',
                  icon: Icons.zoom_out_rounded,
                  onPressed: controller.zoom > zoomLevels.first
                      ? controller.zoomOut
                      : null,
                ),
                Tooltip(
                  message: '${l10n.actualSize}  (Ctrl+0)',
                  child: TextButton(
                    onPressed: () => controller.setZoom(1),
                    style: TextButton.styleFrom(
                      foregroundColor: PsitoColors.onFelt,
                      minimumSize: const Size(52, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    child: Text(
                      '${(controller.zoom * 100).round()}%',
                      style: const TextStyle(
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
                _BarButton(
                  tooltip: '${l10n.zoomIn}  (Ctrl++)',
                  icon: Icons.zoom_in_rounded,
                  onPressed: controller.zoom < zoomLevels.last
                      ? controller.zoomIn
                      : null,
                ),
                PopupMenuButton<_MenuItem>(
                  tooltip: l10n.moreOptions,
                  iconColor: PsitoColors.onFelt,
                  icon: const Icon(Icons.more_vert_rounded, size: 21),
                  onSelected: (item) => switch (item) {
                    _MenuItem.saveAs => files.saveAs(),
                    _MenuItem.howToUse => _howToUse(context),
                    _MenuItem.about => _about(context),
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _MenuItem.saveAs,
                      child: Text('${l10n.saveAs}  (Ctrl+Shift+S)'),
                    ),
                    PopupMenuItem(
                      value: _MenuItem.howToUse,
                      child: Text(l10n.howToUse),
                    ),
                    PopupMenuItem(
                      value: _MenuItem.about,
                      child: Text(l10n.about),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) => const SizedBox(width: 10);
}

class _BarButton extends StatelessWidget {
  const _BarButton({
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
