part of 'plume_controller.dart';

/// Text being typed on the sheet. It becomes pixels when it is committed.
class TextDraft {
  TextDraft({
    required this.position,
    required this.size,
    required this.color,
    required this.serif,
  });

  final Offset position;
  double size;
  Color color;
  bool serif;
  String text = '';

  TextOp toOperation() => TextOp(
    text: text,
    position: position,
    size: size,
    color: color,
    serif: serif,
  );
}

/// The text tool: a click opens a draft, and the next click, another tool or
/// a save puts it in the drawing. An empty draft leaves nothing.
extension TextTool on PlumeController {
  void startText(Offset point) {
    commitText();
    textDraft = TextDraft(
      position: point,
      size: Tool.text.sizes[sizeIndex],
      color: color,
      serif: textSerif,
    );
    _changed();
  }

  void setTextSerif(bool serif) {
    textSerif = serif;
    textDraft?.serif = serif;
    _changed();
  }

  void commitText() {
    final draft = textDraft;
    if (draft == null) return;
    textDraft = null;
    if (draft.text.trim().isEmpty) {
      _changed();
      return;
    }
    _commitOperation(draft.toOperation());
  }

  void cancelText() {
    if (textDraft == null) return;
    textDraft = null;
    _changed();
  }
}
