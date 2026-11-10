import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../paint/plume_controller.dart';
import '../atoms/bar_button.dart';
import '../atoms/colors.dart';
import '../molecules/drawing_title.dart';
import '../molecules/zoom_controls.dart';
import 'dialogs.dart';

/// What the bar asks the page to do with files.
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

/// A line of the menu, with the action it runs.
class MenuAction {
  const MenuAction(this.label, this.run);

  final String label;
  final VoidCallback run;
}

/// The bar above the sheet: the name of the drawing and the actions.
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.controller,
    required this.files,
    this.menu = const [],
  });

  static const _compact = 760.0;

  final PlumeController controller;
  final FileActions files;

  /// More actions of the page, shown in the menu before the help.
  final List<MenuAction> menu;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final c = controller;
    final items = [
      MenuAction('${l10n.saveAs}  (Ctrl+Shift+S)', files.saveAs),
      ...menu,
      MenuAction(l10n.howToUse, () => showHowToUse(context)),
      MenuAction(l10n.about, () => showAboutPlume(context)),
    ];
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
        builder: (context, box) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            children: [
              Expanded(
                child: DrawingTitle(
                  path: c.path,
                  dirty: c.dirty,
                  showAppName: box.maxWidth >= _compact,
                ),
              ),
              BarButton(
                tooltip: '${l10n.newImage}  (Ctrl+N)',
                icon: Icons.note_add_outlined,
                onPressed: files.newImage,
              ),
              BarButton(
                tooltip: '${l10n.open}  (Ctrl+O)',
                icon: Icons.folder_open_outlined,
                onPressed: files.open,
              ),
              BarButton(
                tooltip: '${l10n.save}  (Ctrl+S)',
                icon: Icons.save_outlined,
                onPressed: files.save,
              ),
              const SizedBox(width: 10),
              BarButton(
                tooltip: '${l10n.undo}  (Ctrl+Z)',
                icon: Icons.undo_rounded,
                onPressed: c.canUndo ? c.undo : null,
              ),
              BarButton(
                tooltip: '${l10n.redo}  (Ctrl+Y)',
                icon: Icons.redo_rounded,
                onPressed: c.canRedo ? c.redo : null,
              ),
              const SizedBox(width: 10),
              ZoomControls(
                zoom: c.zoom,
                onZoomOut: c.zoom > zoomLevels.first ? c.zoomOut : null,
                onZoomIn: c.zoom < zoomLevels.last ? c.zoomIn : null,
                onActualSize: () => c.setZoom(1),
              ),
              PopupMenuButton<int>(
                tooltip: l10n.moreOptions,
                iconColor: PsitoColors.onFelt,
                icon: const Icon(Icons.more_vert_rounded, size: 21),
                onSelected: (index) => items[index].run(),
                itemBuilder: (context) => [
                  for (var i = 0; i < items.length; i++)
                    PopupMenuItem(value: i, child: Text(items[i].label)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
