import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/l10n.dart';
import '../../paint/operations.dart';
import '../../platform/close_guard.dart';
import '../../paint/plume_controller.dart';
import '../atoms/colors.dart';
import '../labels.dart';
import '../molecules/image_menu_button.dart';
import '../organisms/canvas_view.dart';
import '../organisms/dialogs.dart';
import '../organisms/drop_zone.dart';
import '../organisms/palette_bar.dart';
import '../organisms/peek.dart';
import '../organisms/toolbox.dart';
import '../organisms/top_bar.dart';
import '../templates/workspace_template.dart';

class PlumePage extends StatefulWidget {
  const PlumePage({
    super.key,
    this.controller,
    this.closeGuard,
    this.initialPath,
  });

  /// A picture to open as the page starts.
  final String? initialPath;

  /// Given by the tests. Without one, the page makes its own.
  final PlumeController? controller;

  /// Given by the tests. Without one, the real window is held.
  final CloseGuard? closeGuard;

  @override
  State<PlumePage> createState() => PlumePageState();
}

class PlumePageState extends State<PlumePage> {
  // Longer than in the games: someone drawing stops to think more often.
  static const _idle = Duration(seconds: 90);
  static const _peekTime = Duration(milliseconds: 3200);

  late final PlumeController _controller =
      widget.controller ?? PlumeController();
  Timer? _timer;
  final _random = Random();
  PeekSpot? _spot;
  bool _peeking = false;

  late final CloseGuard _closeGuard = widget.closeGuard ?? WindowCloseGuard();

  @override
  void initState() {
    super.initState();
    if (_controller.image == null) _controller.newImage();
    _closeGuard.start(_canClose);
    _waitIdle();
    final path = widget.initialPath;
    if (path != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openFile(path));
    }
  }

  Future<void> _openFile(String path) async {
    final Uint8List bytes;
    try {
      bytes = await File(path).readAsBytes();
    } on Object {
      if (mounted) {
        final l10n = context.l10n;
        _message(l10n.openFailed(fileName(l10n, path)));
      }
      return;
    }
    if (mounted) await _openPath(path, bytes);
  }

  /// Pictures dragged from another program: the first one opens.
  Future<void> openDropped(List<String> paths) async {
    if (paths.isEmpty || !await _canDiscard() || !mounted) return;
    await _openFile(paths.first);
  }

  /// Asked when the window is about to close.
  Future<bool> _canClose() async {
    if (!_controller.dirty || !mounted) return true;
    final name = fileName(context.l10n, _controller.path);
    return switch (await askBeforeClosing(context, name)) {
      CloseAnswer.save => await _save(),
      CloseAnswer.dontSave => true,
      CloseAnswer.cancel => false,
    };
  }

  @override
  void dispose() {
    _closeGuard.dispose();
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

  /// True when there is nothing to lose, or the person said it can go.
  Future<bool> _canDiscard() async =>
      !_controller.dirty || await askDiscard(context);

  Future<void> _newImage() async {
    if (!await _canDiscard() || !mounted) return;
    final size = await askImageSize(
      context,
      title: context.l10n.newImage,
      width: _controller.width,
      height: _controller.height,
    );
    if (size != null) await _controller.newImage(size.$1, size.$2);
  }

  Future<void> _open() async {
    if (!await _canDiscard() || !mounted) return;
    final file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(
          label: context.l10n.images,
          extensions: const ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'],
        ),
      ],
    );
    if (file == null) return;
    await _openPath(file.path, await file.readAsBytes());
  }

  Future<void> _openPath(String path, Uint8List bytes) async {
    final l10n = context.l10n;
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final picture = (await codec.getNextFrame()).image;
      if (picture.width > maxSide || picture.height > maxSide) {
        picture.dispose();
        throw const FormatException('too big');
      }
      await _controller.openImage(picture, path);
      if (!mounted) return;
      // Big pictures open small enough to be seen whole.
      final screen = MediaQuery.sizeOf(context);
      final room = Size(
        screen.width - Toolbox.width - 48,
        screen.height - 170,
      );
      _controller.setZoom(min(1, _controller.fittingZoom(room)));
    } on Object {
      _message(l10n.openFailed(fileName(l10n, path)));
    }
  }

  /// Saves, asking where when the drawing has no PNG file yet. True when it
  /// was saved.
  Future<bool> _save({bool askWhere = false}) async {
    final l10n = context.l10n;
    var path = _controller.path;
    if (askWhere || path == null || !path.toLowerCase().endsWith('.png')) {
      final suggested = fileName(
        l10n,
        path,
      ).replaceFirst(RegExp(r'\.\w+$'), '');
      final location = await getSaveLocation(
        suggestedName: '$suggested.png',
        acceptedTypeGroups: [
          XTypeGroup(label: l10n.pngImage, extensions: const ['png']),
        ],
      );
      if (location == null) return false;
      path = location.path;
      if (!path.toLowerCase().endsWith('.png')) path = '$path.png';
    }
    try {
      await File(path).writeAsBytes(await _controller.pngBytes());
      _controller.markSaved(path);
      _message(l10n.saved(fileName(l10n, path)));
      return true;
    } on Object {
      _message(l10n.saveFailed(fileName(l10n, path)));
      return false;
    }
  }

  Map<ShortcutActivator, VoidCallback> get _shortcuts {
    final c = _controller;
    return {
      const SingleActivator(LogicalKeyboardKey.keyN, control: true): _newImage,
      const SingleActivator(LogicalKeyboardKey.keyO, control: true): _open,
      const SingleActivator(LogicalKeyboardKey.keyS, control: true): _save,
      const SingleActivator(
        LogicalKeyboardKey.keyS,
        control: true,
        shift: true,
      ): () =>
          _save(askWhere: true),
      const SingleActivator(LogicalKeyboardKey.keyZ, control: true): c.undo,
      const SingleActivator(LogicalKeyboardKey.keyY, control: true): c.redo,
      const SingleActivator(
        LogicalKeyboardKey.keyZ,
        control: true,
        shift: true,
      ): c.redo,
      const SingleActivator(LogicalKeyboardKey.equal, control: true): c.zoomIn,
      const SingleActivator(LogicalKeyboardKey.add, control: true): c.zoomIn,
      const SingleActivator(LogicalKeyboardKey.numpadAdd, control: true):
          c.zoomIn,
      const SingleActivator(LogicalKeyboardKey.minus, control: true): c.zoomOut,
      const SingleActivator(LogicalKeyboardKey.numpadSubtract, control: true):
          c.zoomOut,
      const SingleActivator(LogicalKeyboardKey.digit0, control: true): () =>
          c.setZoom(1),
      const SingleActivator(LogicalKeyboardKey.keyC, control: true):
          c.copySelection,
      const SingleActivator(LogicalKeyboardKey.keyX, control: true):
          c.cutSelection,
      const SingleActivator(LogicalKeyboardKey.keyV, control: true): _paste,
      const SingleActivator(LogicalKeyboardKey.keyA, control: true):
          c.selectAll,
      const SingleActivator(LogicalKeyboardKey.delete): c.deleteSelection,
      const SingleActivator(LogicalKeyboardKey.keyX): () {
        if (c.textDraft == null) c.swapColors();
      },
      const SingleActivator(LogicalKeyboardKey.keyW, control: true): () =>
          _imageAction(ImageAction.resize),
      const SingleActivator(LogicalKeyboardKey.keyE, control: true): () =>
          _imageAction(ImageAction.sheetSize),
      const SingleActivator(LogicalKeyboardKey.keyR, control: true): () =>
          _imageAction(ImageAction.rotateRight),
      const SingleActivator(
        LogicalKeyboardKey.keyR,
        control: true,
        shift: true,
      ): () =>
          _imageAction(ImageAction.rotateLeft),
      const SingleActivator(
        LogicalKeyboardKey.keyX,
        control: true,
        shift: true,
      ): () =>
          _imageAction(ImageAction.crop),
      const SingleActivator(LogicalKeyboardKey.escape): () {
        c
          ..cancelShape()
          ..dropSelection();
      },
      const SingleActivator(LogicalKeyboardKey.enter): c.finishShape,
      // The letters pick tools, except while a text is being typed.
      for (final tool in Tool.values)
        SingleActivator(letterKey(toolKey(tool))): () {
          if (c.textDraft == null) c.setTool(tool);
        },
    };
  }

  Future<void> _imageAction(ImageAction action) async {
    final c = _controller;
    final l10n = context.l10n;
    switch (action) {
      case ImageAction.resize:
        final from = c.resizableSize;
        final size = await askImageSize(
          context,
          title: l10n.resize,
          width: from.width.round(),
          height: from.height.round(),
          action: l10n.apply,
          keepRatio: true,
        );
        if (size != null) await c.resize(size.$1, size.$2);
      case ImageAction.sheetSize:
        final size = await askImageSize(
          context,
          title: l10n.sheetSize,
          width: c.width,
          height: c.height,
          action: l10n.apply,
        );
        if (size != null) await c.resizeSheet(size.$1, size.$2);
      case ImageAction.rotateRight:
        await c.turn(Turn.right);
      case ImageAction.rotateLeft:
        await c.turn(Turn.left);
      case ImageAction.rotateHalf:
        await c.turn(Turn.half);
      case ImageAction.flipHorizontal:
        await c.turn(Turn.flipHorizontal);
      case ImageAction.flipVertical:
        await c.turn(Turn.flipVertical);
      case ImageAction.crop:
        await c.cropToSelection();
    }
  }

  Future<void> _paste() async {
    if (!await _controller.paste() && mounted) {
      _message(context.l10n.nothingToPaste);
    }
  }

  List<MenuAction> _editMenu() {
    final l10n = context.l10n;
    final c = _controller;
    return [
      MenuAction('${l10n.cut}  (Ctrl+X)', c.cutSelection),
      MenuAction('${l10n.copy}  (Ctrl+C)', c.copySelection),
      MenuAction('${l10n.paste}  (Ctrl+V)', _paste),
      MenuAction('${l10n.selectAll}  (Ctrl+A)', c.selectAll),
    ];
  }

  /// Whether the keyboard is in a text field, which then gets every key.
  bool get _typing {
    final focused = FocusManager.instance.primaryFocus?.context;
    return focused != null &&
        (focused.widget is EditableText ||
            focused.findAncestorStateOfType<EditableTextState>() != null);
  }

  /// The shortcuts of the page. While a text is being typed none of them
  /// runs, so that letters, Delete and the rest reach the text.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || _typing) return KeyEventResult.ignored;
    for (final MapEntry(key: activator, value: run) in _shortcuts.entries) {
      if (activator.accepts(event, HardwareKeyboard.instance)) {
        run();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final files = FileActions(
      newImage: _newImage,
      open: _open,
      save: _save,
      saveAs: () => _save(askWhere: true),
    );
    return Scaffold(
      backgroundColor: PsitoColors.felt,
      body: Focus(
        canRequestFocus: false,
        skipTraversal: true,
        onKeyEvent: _onKey,
        child: Focus(
          autofocus: true,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _activity(),
            child: DropZone(
              onFiles: openDropped,
              child: ListenableBuilder(
                listenable: c,
                builder: (context, _) => WorkspaceTemplate(
                  topBar: TopBar(
                    controller: c,
                    files: files,
                    menu: _editMenu(),
                    onImageAction: _imageAction,
                  ),
                  toolbox: Toolbox(controller: c),
                  canvas: CanvasView(controller: c),
                  bottomBar: PaletteBar(controller: c),
                  overlay: _spot == null
                      ? const SizedBox.shrink()
                      : Peek(
                          key: ObjectKey(_spot),
                          spot: _spot!,
                          visible: _peeking,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The key of a letter from A to Z.
LogicalKeyboardKey letterKey(String letter) => LogicalKeyboardKey(
  LogicalKeyboardKey.keyA.keyId +
      letter.toLowerCase().codeUnitAt(0) -
      'a'.codeUnitAt(0),
);
