import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/l10n.dart';
import '../../paint/plume_controller.dart';
import '../../version.dart';

/// Asks whether the changes that were not saved can be lost.
Future<bool> askDiscard(BuildContext context) async {
  final l10n = context.l10n;
  final answer = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.discardTitle),
      content: Text(l10n.discardBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.discard),
        ),
      ],
    ),
  );
  return answer ?? false;
}

enum CloseAnswer { save, dontSave, cancel }

/// Asks what to do with the changes before the window closes.
Future<CloseAnswer> askBeforeClosing(BuildContext context, String name) async {
  final l10n = context.l10n;
  final answer = await showDialog<CloseAnswer>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.closeTitle(name)),
      content: Text(l10n.closeBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(CloseAnswer.dontSave),
          child: Text(l10n.dontSave),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(CloseAnswer.cancel),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          autofocus: true,
          onPressed: () => Navigator.of(context).pop(CloseAnswer.save),
          child: Text(l10n.save),
        ),
      ],
    ),
  );
  return answer ?? CloseAnswer.cancel;
}

Future<(int, int)?> askImageSize(
  BuildContext context, {
  required String title,
  required int width,
  required int height,
}) => showDialog<(int, int)>(
  context: context,
  builder: (_) => SizeDialog(title: title, width: width, height: height),
);

void showHowToUse(BuildContext context) {
  final l10n = context.l10n;
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.howToUse),
      content: SizedBox(
        width: 460,
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

void showAboutPlume(BuildContext context) {
  final l10n = context.l10n;
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

/// A width and a height in pixels, for a new drawing or a new size.
class SizeDialog extends StatefulWidget {
  const SizeDialog({
    super.key,
    required this.title,
    required this.width,
    required this.height,
  });

  final String title;
  final int width;
  final int height;

  @override
  State<SizeDialog> createState() => _SizeDialogState();
}

class _SizeDialogState extends State<SizeDialog> {
  late final _width = TextEditingController(text: '${widget.width}');
  late final _height = TextEditingController(text: '${widget.height}');

  @override
  void dispose() {
    _width.dispose();
    _height.dispose();
    super.dispose();
  }

  int? _read(TextEditingController field) {
    final value = int.tryParse(field.text);
    return value != null && value > 0 && value <= maxSide ? value : null;
  }

  (int, int)? get _size {
    final width = _read(_width);
    final height = _read(_height);
    return width == null || height == null ? null : (width, height);
  }

  void _submit() {
    final size = _size;
    if (size != null) Navigator.of(context).pop(size);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Widget field(TextEditingController controller, String label) => Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 4,
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: label,
          suffixText: 'px',
          border: const OutlineInputBorder(),
          counterText: '',
        ),
      ),
    );
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 300,
        child: Row(
          children: [
            field(_width, l10n.width),
            const SizedBox(width: 12),
            field(_height, l10n.height),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _size == null ? null : _submit,
          child: Text(l10n.create),
        ),
      ],
    );
  }
}
