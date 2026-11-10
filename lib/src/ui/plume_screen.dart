import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../paint/operations.dart';
import '../paint/plume_controller.dart';
import 'canvas_view.dart';
import 'colors.dart';
import 'palette_bar.dart';
import 'peek.dart';
import 'toolbox.dart';
import 'top_bar.dart';

class PlumeScreen extends StatefulWidget {
  const PlumeScreen({super.key, this.controller});

  /// Given by the tests. Without one, the screen makes its own.
  final PlumeController? controller;

  @override
  State<PlumeScreen> createState() => _PlumeScreenState();
}

class _PlumeScreenState extends State<PlumeScreen> {
  // Longer than in the games: someone drawing stops to think more often.
  static const _idle = Duration(seconds: 90);
  static const _peekTime = Duration(milliseconds: 3200);

  late final PlumeController _controller =
      widget.controller ?? PlumeController();
  Timer? _timer;
  final _random = Random();
  PeekSpot? _spot;
  bool _peeking = false;

  @override
  void initState() {
    super.initState();
    if (_controller.image == null) _controller.newImage();
    _waitIdle();
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _waitIdle() {
    _timer?.cancel();
    _timer = Timer(_idle, _peek);
  }

  void _peek() {
    setState(() {
      _spot = nextPeekSpot(_random, _spot);
      _peeking = true;
    });
    _timer = Timer(_peekTime, () {
      setState(() => _peeking = false);
      _waitIdle();
    });
  }

  void _activity() {
    if (_peeking) setState(() => _peeking = false);
    _waitIdle();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  /// Asks before losing unsaved changes. True when it is fine to go on.
  Future<bool> _canDiscard() async {
    if (!_controller.dirty) return true;
    final l10n = AppLocalizations.of(context);
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

  Future<void> _newImage() async {
    if (!await _canDiscard() || !mounted) return;
    final size = await showDialog<(int, int)>(
      context: context,
      builder: (_) => _NewImageDialog(
        width: _controller.width,
        height: _controller.height,
      ),
    );
    if (size != null) await _controller.newImage(size.$1, size.$2);
  }

  Future<void> _open() async {
    if (!await _canDiscard() || !mounted) return;
    final l10n = AppLocalizations.of(context);
    final file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(
          label: l10n.images,
          extensions: const ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'],
        ),
      ],
    );
    if (file == null) return;
    try {
      final codec = await ui.instantiateImageCodec(await file.readAsBytes());
      final picture = (await codec.getNextFrame()).image;
      if (picture.width > maxSide || picture.height > maxSide) {
        picture.dispose();
        throw const FormatException('too big');
      }
      await _controller.openImage(picture, file.path);
    } on Object {
      _message(l10n.openFailed(file.name));
    }
  }

  Future<void> _save({bool askWhere = false}) async {
    final l10n = AppLocalizations.of(context);
    var path = _controller.path;
    if (askWhere || path == null || !path.toLowerCase().endsWith('.png')) {
      final suggested = fileName(l10n, path).replaceFirst(RegExp(r'\.\w+$'), '');
      final location = await getSaveLocation(
        suggestedName: '$suggested.png',
        acceptedTypeGroups: [
          XTypeGroup(label: l10n.pngImage, extensions: const ['png']),
        ],
      );
      if (location == null) return;
      path = location.path;
      if (!path.toLowerCase().endsWith('.png')) path = '$path.png';
    }
    try {
      await File(path).writeAsBytes(await _controller.pngBytes());
      _controller.markSaved(path);
      _message(l10n.saved(fileName(l10n, path)));
    } on Object {
      _message(l10n.saveFailed(fileName(l10n, path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final files = FileActions(
      newImage: _newImage,
      open: _open,
      save: _save,
      saveAs: () => _save(askWhere: true),
    );
    final c = _controller;
    return Scaffold(
      backgroundColor: PsitoColors.felt,
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyN, control: true):
              _newImage,
          const SingleActivator(LogicalKeyboardKey.keyO, control: true): _open,
          const SingleActivator(LogicalKeyboardKey.keyS, control: true): _save,
          const SingleActivator(
            LogicalKeyboardKey.keyS,
            control: true,
            shift: true,
          ): () => _save(askWhere: true),
          const SingleActivator(LogicalKeyboardKey.keyZ, control: true):
              c.undo,
          const SingleActivator(LogicalKeyboardKey.keyY, control: true):
              c.redo,
          const SingleActivator(
            LogicalKeyboardKey.keyZ,
            control: true,
            shift: true,
          ): c.redo,
          const SingleActivator(LogicalKeyboardKey.equal, control: true):
              c.zoomIn,
          const SingleActivator(LogicalKeyboardKey.add, control: true):
              c.zoomIn,
          const SingleActivator(LogicalKeyboardKey.numpadAdd, control: true):
              c.zoomIn,
          const SingleActivator(LogicalKeyboardKey.minus, control: true):
              c.zoomOut,
          const SingleActivator(
            LogicalKeyboardKey.numpadSubtract,
            control: true,
          ): c.zoomOut,
          const SingleActivator(LogicalKeyboardKey.digit0, control: true): () =>
              c.setZoom(1),
          for (final tool in Tool.values)
            SingleActivator(
              LogicalKeyboardKey(
                LogicalKeyboardKey.keyA.keyId +
                    toolKey(tool).toLowerCase().codeUnitAt(0) -
                    'a'.codeUnitAt(0),
              ),
            ): () =>
                c.setTool(tool),
        },
        child: Focus(
          autofocus: true,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _activity(),
            child: ListenableBuilder(
              listenable: c,
              builder: (context, _) => Column(
                children: [
                  TopBar(controller: c, files: files),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Toolbox(controller: c),
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
                              CanvasView(controller: c),
                              if (_spot case final spot?)
                                Peek(
                                  key: ObjectKey(spot),
                                  spot: spot,
                                  visible: _peeking,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  PaletteBar(controller: c),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NewImageDialog extends StatefulWidget {
  const _NewImageDialog({required this.width, required this.height});

  final int width;
  final int height;

  @override
  State<_NewImageDialog> createState() => _NewImageDialogState();
}

class _NewImageDialogState extends State<_NewImageDialog> {
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
    final l10n = AppLocalizations.of(context);
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
      title: Text(l10n.newImage),
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
