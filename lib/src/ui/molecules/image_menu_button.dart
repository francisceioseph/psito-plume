import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../atoms/colors.dart';

/// What can be done to the whole picture, or to the selection.
enum ImageAction {
  resize,
  sheetSize,
  rotateRight,
  rotateLeft,
  rotateHalf,
  flipHorizontal,
  flipVertical,
  crop,
}

/// The button of the bar that opens the image menu.
class ImageMenuButton extends StatelessWidget {
  const ImageMenuButton({
    super.key,
    required this.onSelected,
    required this.canCrop,
  });

  final ValueChanged<ImageAction> onSelected;
  final bool canCrop;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    PopupMenuItem<ImageAction> item(
      ImageAction action,
      IconData icon,
      String label, {
      bool enabled = true,
    }) => PopupMenuItem(
      value: action,
      enabled: enabled,
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Text(label),
        ],
      ),
    );
    return PopupMenuButton<ImageAction>(
      tooltip: l10n.imageMenu,
      iconColor: PsitoColors.onFelt,
      icon: const Icon(Icons.transform_rounded, size: 21),
      onSelected: onSelected,
      itemBuilder: (context) => [
        item(
          ImageAction.resize,
          Icons.photo_size_select_large_rounded,
          '${l10n.resize}  (Ctrl+W)',
        ),
        item(
          ImageAction.sheetSize,
          Icons.aspect_ratio_rounded,
          '${l10n.sheetSize}  (Ctrl+E)',
        ),
        const PopupMenuDivider(),
        item(
          ImageAction.rotateRight,
          Icons.rotate_right_rounded,
          '${l10n.rotateRight}  (Ctrl+R)',
        ),
        item(
          ImageAction.rotateLeft,
          Icons.rotate_left_rounded,
          '${l10n.rotateLeft}  (Ctrl+Shift+R)',
        ),
        item(ImageAction.rotateHalf, Icons.sync_rounded, l10n.rotateHalf),
        item(ImageAction.flipHorizontal, Icons.flip_rounded, l10n.flipHorizontal),
        item(
          ImageAction.flipVertical,
          Icons.flip_rounded,
          l10n.flipVertical,
        ),
        const PopupMenuDivider(),
        item(
          ImageAction.crop,
          Icons.crop_rounded,
          '${l10n.crop}  (Ctrl+Shift+X)',
          enabled: canCrop,
        ),
      ],
    );
  }
}
