import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/l10n.dart';
import '../../paint/operations.dart';
import '../../paint/plume_controller.dart';

/// Where the text of the text tool is typed, over the sheet and at its zoom.
/// Enter puts it in the drawing, Shift+Enter starts a new line and Escape
/// gives up.
class TextDraftField extends StatefulWidget {
  const TextDraftField({
    super.key,
    required this.draft,
    required this.zoom,
    required this.onCommit,
    required this.onCancel,
  });

  final TextDraft draft;
  final double zoom;
  final VoidCallback onCommit;
  final VoidCallback onCancel;

  @override
  State<TextDraftField> createState() => _TextDraftFieldState();
}

class _TextDraftFieldState extends State<TextDraftField> {
  late final _text = TextEditingController(text: widget.draft.text);
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void dispose() {
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final style = plumeTextStyle(
      size: draft.size * widget.zoom,
      color: draft.color,
      serif: draft.serif,
    );
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.enter): widget.onCommit,
        const SingleActivator(LogicalKeyboardKey.numpadEnter): widget.onCommit,
        const SingleActivator(LogicalKeyboardKey.escape): widget.onCancel,
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x99000000)),
          color: const Color(0x14FFFFFF),
        ),
        child: IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 24 * widget.zoom),
            child: TextField(
              controller: _text,
              focusNode: _focus,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: style,
              cursorColor: draft.color,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: context.l10n.typeHere,
                hintStyle: style.copyWith(color: const Color(0x66000000)),
              ),
              onChanged: (value) => draft.text = value,
            ),
          ),
        ),
      ),
    );
  }
}
