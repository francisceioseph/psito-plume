import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

import '../platform/image_clipboard.dart';
import 'operations.dart';
import 'pixels.dart';

part 'selection.dart';
part 'text_draft.dart';
part 'transform.dart';

const defaultWidth = 800;
const defaultHeight = 600;
const maxSide = 8000;
const zoomLevels = [.25, .5, 1.0, 2.0, 4.0, 8.0];

typedef StampLoader = Future<ui.Image> Function(int level);

Future<ui.Image> _stampFromAssets(int level) async {
  final data = await rootBundle.load('assets/stamps/$level.png');
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  return (await codec.getNextFrame()).image;
}

Future<ui.Image> imageFromPixels(Uint8List rgba, int width, int height) {
  final done = Completer<ui.Image>();
  ui.decodeImageFromPixels(
    rgba,
    width,
    height,
    ui.PixelFormat.rgba8888,
    done.complete,
  );
  return done.future;
}

Future<ui.Image> _draw(int width, int height, void Function(Canvas) paint) {
  final recorder = ui.PictureRecorder();
  paint(Canvas(recorder));
  final picture = recorder.endRecording();
  return picture.toImage(width, height).whenComplete(picture.dispose);
}

/// The drawing, the tools and the history.
///
/// Every change of the pixels goes through one queue, so that a fill, a
/// stroke and an undo never overlap, whatever the speed of the hand.
class PlumeController extends ChangeNotifier {
  PlumeController({
    StampLoader? loadStamp,
    ImageClipboard? clipboard,
    this.maxHistory = 40,
  }) : _loadStamp = loadStamp ?? _stampFromAssets,
       clipboard = clipboard ?? SystemImageClipboard();

  /// Where copies go, besides [_copied], so that other programs see them.
  final ImageClipboard clipboard;

  final StampLoader _loadStamp;
  final int maxHistory;

  ui.Image? image;
  int get width => image?.width ?? 0;
  int get height => image?.height ?? 0;

  /// Where the drawing was opened from or saved to.
  String? path;

  /// Whether there are changes since the last save.
  bool dirty = false;

  Tool tool = Tool.brush;
  Tool _beforePicker = Tool.brush;
  Color color = const Color(0xFF2B2B33);

  /// The colour of the right button.
  Color secondary = paperColor;
  int sizeIndex = 1;
  bool filled = false;
  int stampLevel = 6;
  double zoom = 1;

  /// The pointer over the sheet, in pixels of the drawing.
  Offset? cursor;

  /// The operation the pointer is drawing now.
  Operation? live;

  /// Finished operations still turning into pixels, drawn meanwhile on top.
  final List<Operation> pending = [];

  /// Text being typed, not yet in the pixels.
  TextDraft? textDraft;
  bool textSerif = false;

  /// The area chosen with the selection tool, in pixels of the drawing.
  Rect? selection;

  /// Pixels lifted from the drawing, or pasted, still free to move.
  Floating? floating;
  Offset? _anchor;
  Offset? _grab;
  Offset? _pendingLift;
  ClipboardImage? _copied;

  final Map<int, ui.Image> stamps = {};
  final List<ui.Image> _undo = [];
  final List<ui.Image> _redo = [];
  Future<void> _queue = Future.value();

  bool get canUndo => _undo.isNotEmpty;
  bool get canRedo => _redo.isNotEmpty;
  double get size => tool.sizes[sizeIndex];

  /// Done when every change asked so far is in the pixels.
  Future<void> get idle => _queue;

  /// For the parts of the controller kept in other files.
  void _changed() => notifyListeners();

  Future<void> _run(Future<void> Function() job) {
    final next = _queue.then((_) => job());
    _queue = next.catchError((Object error, StackTrace stack) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stack),
      );
    });
    return _queue;
  }

  void _clearHistory() {
    for (final old in [..._undo, ..._redo]) {
      old.dispose();
    }
    _undo.clear();
    _redo.clear();
  }

  void _push(ui.Image next) {
    _undo.add(image!);
    if (_undo.length > maxHistory) _undo.removeAt(0).dispose();
    for (final old in _redo) {
      old.dispose();
    }
    _redo.clear();
    image = next;
    dirty = true;
  }

  Future<void> newImage([int width = defaultWidth, int height = defaultHeight]) =>
      _run(() async {
        final blank = await _draw(width, height, (canvas) {
          canvas.drawRect(
            Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
            Paint()..color = paperColor,
          );
        });
        _forgetSelection();
        _clearHistory();
        image = blank;
        path = null;
        dirty = false;
        zoom = 1;
        notifyListeners();
      });

  /// Starts over from a picture opened from [path]. Transparent parts become
  /// paper, like everything else on the sheet.
  Future<void> openImage(ui.Image picture, String path) => _run(() async {
    final flat = await _draw(picture.width, picture.height, (canvas) {
      final area = Rect.fromLTWH(
        0,
        0,
        picture.width.toDouble(),
        picture.height.toDouble(),
      );
      canvas.drawRect(area, Paint()..color = paperColor);
      canvas.drawImage(picture, Offset.zero, Paint());
    });
    picture.dispose();
    _forgetSelection();
    _clearHistory();
    image = flat;
    this.path = path;
    dirty = false;
    zoom = 1;
    notifyListeners();
  });

  Future<Uint8List> pngBytes() async {
    commitText();
    await placeSelection();
    await idle;
    final data = await image!.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  void markSaved(String path) {
    this.path = path;
    dirty = false;
    notifyListeners();
  }

  void setTool(Tool next) {
    if (next != Tool.select) {
      placeSelection(keep: false);
      selection = null;
    }
    if (next != Tool.text) commitText();
    if (next == Tool.picker && tool != Tool.picker) _beforePicker = tool;
    tool = next;
    notifyListeners();
  }

  void setColor(Color next) {
    color = next;
    textDraft?.color = next;
    notifyListeners();
  }

  void setSize(int index) {
    sizeIndex = index.clamp(0, 3);
    if (tool == Tool.text) textDraft?.size = size;
    notifyListeners();
  }

  void setFilled(bool value) {
    filled = value;
    notifyListeners();
  }

  void setStamp(int level) {
    stampLevel = level;
    tool = Tool.stamp;
    notifyListeners();
  }

  void setZoom(double value) {
    zoom = value.clamp(zoomLevels.first, zoomLevels.last);
    notifyListeners();
  }

  void zoomIn() =>
      setZoom(zoomLevels.firstWhere((z) => z > zoom, orElse: () => zoom));

  void zoomOut() => setZoom(
    zoomLevels.lastWhere((z) => z < zoom, orElse: () => zoom),
  );

  void setCursor(Offset? point) {
    cursor = point;
    notifyListeners();
  }

  Offset _pixel(Offset point) => Offset(
    point.dx.floorToDouble() + .5,
    point.dy.floorToDouble() + .5,
  );

  void setSecondary(Color next) {
    secondary = next;
    notifyListeners();
  }

  void swapColors() {
    final first = color;
    color = secondary;
    secondary = first;
    textDraft?.color = color;
    notifyListeners();
  }

  /// The pointer goes down on the sheet, at [point] in pixels of the drawing.
  /// With [secondary], it is the right button.
  void pointerDown(Offset point, {bool secondary = false}) {
    if (image == null) return;
    final paint = secondary ? this.secondary : color;
    switch (tool) {
      case Tool.select:
        _selectDown(point);
      case Tool.text:
        startText(point);
      case Tool.fill:
        fill(point, color: paint);
      case Tool.picker:
        pick(point, secondary: secondary);
      case Tool.stamp:
        stamp(point);
      case Tool.pencil || Tool.brush || Tool.eraser:
        final smooth = tool != Tool.pencil;
        final eraser = tool == Tool.eraser;
        live = StrokeOp(
          color: eraser ? paperColor : paint,
          width: size,
          smooth: smooth,
          points: [smooth ? point : _pixel(point)],
          onlyColor: eraser && secondary ? color : null,
        );
        notifyListeners();
      case Tool.line || Tool.rectangle || Tool.ellipse:
        live = ShapeOp(
          tool: tool,
          color: paint,
          width: tool.sizes[sizeIndex],
          start: point,
          end: point,
          filled: filled,
        );
        notifyListeners();
    }
  }

  void pointerMove(Offset point, {bool constrain = false}) {
    if (tool == Tool.select) {
      _selectMove(point);
      return;
    }
    switch (live) {
      case final StrokeOp stroke:
        stroke.points.add(stroke.smooth ? point : _pixel(point));
      case final ShapeOp shape:
        live = shape.copyWith(
          end: constrain ? constrainEnd(shape.tool, shape.start, point) : point,
        );
      default:
        return;
    }
    notifyListeners();
  }

  void pointerUp() {
    if (tool == Tool.select) {
      _selectUp();
      return;
    }
    final op = live;
    if (op == null) return;
    live = null;
    _commit(op);
  }

  /// For the parts of the controller kept in other files.
  void _commitOperation(Operation op) => _commit(op);

  void _commit(Operation op) {
    pending.add(op);
    notifyListeners();
    _run(() async {
      final stampImage = op is StampOp ? stamps[op.level] : null;
      final base = image!;
      if (op is StrokeOp && op.onlyColor != null) {
        await _eraseOneColor(base, op);
        pending.remove(op);
        notifyListeners();
        return;
      }
      final next = await _draw(base.width, base.height, (canvas) {
        canvas.drawImage(base, Offset.zero, Paint());
        paintOperation(canvas, op, stamp: stampImage);
      });
      _push(next);
      pending.remove(op);
      notifyListeners();
    });
  }

  /// The right button eraser: paper over the main colour, only where the
  /// stroke went.
  Future<void> _eraseOneColor(ui.Image base, StrokeOp op) async {
    final shape = await _draw(base.width, base.height, (canvas) {
      paintOperation(
        canvas,
        StrokeOp(
          color: paperColor,
          width: op.width,
          smooth: op.smooth,
          points: op.points,
        ),
      );
    });
    final mask = await shape.toByteData(format: ui.ImageByteFormat.rawRgba);
    shape.dispose();
    final out = replaceUnderMask(
      rgba: await _pixels(),
      mask: mask!.buffer.asUint8List(),
      from: op.onlyColor!.toARGB32(),
      to: paperColor.toARGB32(),
    );
    if (out == null) return;
    _push(await imageFromPixels(out, base.width, base.height));
  }

  Future<ui.Image> stampImage(int level) async =>
      stamps[level] ??= await _loadStamp(level);

  Future<void> stamp(Offset point) async {
    final level = stampLevel;
    await stampImage(level);
    _commit(StampOp(level: level, center: point, size: Tool.stamp.sizes[sizeIndex]));
  }

  Future<Uint8List> _pixels() async {
    final data = await image!.toByteData(format: ui.ImageByteFormat.rawRgba);
    return data!.buffer.asUint8List();
  }

  Future<void> fill(Offset point, {Color? color}) => _run(() async {
    final base = image!;
    final rgba = await _pixels();
    final request = FillRequest(
      rgba: rgba,
      width: base.width,
      height: base.height,
      x: point.dx.floor(),
      y: point.dy.floor(),
      color: (color ?? this.color).toARGB32(),
    );
    // Big sheets go to another isolate, so that the window does not freeze.
    final out = base.width * base.height > 500000
        ? await compute(floodFill, request)
        : floodFill(request);
    if (out == null) return;
    _push(await imageFromPixels(out, base.width, base.height));
    notifyListeners();
  });

  /// Takes the colour under [point] and goes back to the tool from before.
  Future<void> pick(Offset point, {bool secondary = false}) => _run(() async {
    final x = point.dx.floor();
    final y = point.dy.floor();
    if (x < 0 || y < 0 || x >= width || y >= height) return;
    final picked = Color(pixelAt(await _pixels(), width, x, y));
    if (secondary) {
      this.secondary = picked;
    } else {
      color = picked;
    }
    tool = _beforePicker;
    notifyListeners();
  });

  Future<void> undo() => _run(() async {
    // A selection still moving goes back to where it was taken from.
    if (floating != null) {
      floating!.image.dispose();
      floating = null;
      selection = null;
    }
    if (_undo.isEmpty) return;
    _redo.add(image!);
    image = _undo.removeLast();
    dirty = true;
    notifyListeners();
  });

  Future<void> redo() => _run(() async {
    if (_redo.isEmpty || floating != null) return;
    _undo.add(image!);
    image = _redo.removeLast();
    dirty = true;
    notifyListeners();
  });

  /// The zoom that makes the whole sheet fit in [area].
  double fittingZoom(Size area) {
    if (width == 0) return 1;
    final fit = min(area.width / width, area.height / height);
    return zoomLevels.lastWhere((z) => z <= fit, orElse: () => zoomLevels.first);
  }

  @override
  void dispose() {
    _forgetSelection();
    _clearHistory();
    image?.dispose();
    for (final stamp in stamps.values) {
      stamp.dispose();
    }
    super.dispose();
  }
}
