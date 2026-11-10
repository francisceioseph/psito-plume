part of 'plume_controller.dart';

/// Pixels that float above the drawing until they are put down.
class Floating {
  Floating(this.image, this.position);

  final ui.Image image;
  Offset position;

  Rect get rect => position &
      Size(image.width.toDouble(), image.height.toDouble());
}

/// The selection tool and the clipboard.
///
/// Pressing inside the selection lifts its pixels, leaving paper behind, and
/// the drag moves them. They stay floating until the next click outside,
/// another tool, Escape or a save puts them down. Undo while they float puts
/// everything back where it was.
extension Selection on PlumeController {
  /// The area chosen now, floating or not.
  Rect? get selectedRect => floating?.rect ?? selection;

  Rect _imageRect() => Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());

  Rect _snap(Rect rect) => Rect.fromLTRB(
    rect.left.roundToDouble(),
    rect.top.roundToDouble(),
    rect.right.roundToDouble(),
    rect.bottom.roundToDouble(),
  ).intersect(_imageRect());

  void _forgetSelection() {
    floating?.image.dispose();
    floating = null;
    selection = null;
    _anchor = null;
    _grab = null;
  }

  void _selectDown(Offset point) {
    final rect = selectedRect;
    if (rect != null && rect.contains(point)) {
      _grab = point - rect.topLeft;
      if (floating == null) _lift(rect);
      return;
    }
    placeSelection();
    selection = null;
    _anchor = point;
    _changed();
  }

  void _selectMove(Offset point) {
    final grab = _grab;
    if (grab != null) {
      final target = point - grab;
      final moved = Offset(target.dx.roundToDouble(), target.dy.roundToDouble());
      final lifting = floating;
      if (lifting != null) lifting.position = moved;
      _liftTarget = moved;
      _changed();
      return;
    }
    final anchor = _anchor;
    if (anchor == null) return;
    selection = _snap(Rect.fromPoints(anchor, point));
    _changed();
  }

  void _selectUp() {
    _grab = null;
    _anchor = null;
    final rect = selection;
    if (floating == null && rect != null && (rect.width < 1 || rect.height < 1)) {
      selection = null;
    }
    _changed();
  }

  /// Where a lift that is still on its way should land.
  set _liftTarget(Offset? value) => _pendingLift = value;

  Future<ui.Image> _crop(ui.Image source, Rect rect) =>
      _draw(rect.width.round(), rect.height.round(), (canvas) {
        canvas.drawImageRect(
          source,
          rect,
          Offset.zero & rect.size,
          Paint()..filterQuality = FilterQuality.none,
        );
      });

  void _lift(Rect rect) {
    _pendingLift = rect.topLeft;
    _run(() async {
      final base = image!;
      final content = await _crop(base, rect);
      final hole = await _draw(base.width, base.height, (canvas) {
        canvas.drawImage(base, Offset.zero, Paint());
        canvas.drawRect(rect, Paint()..color = paperColor);
      });
      _push(hole);
      floating = Floating(content, _pendingLift ?? rect.topLeft);
      selection = null;
      _changed();
    });
  }

  /// Puts the floating pixels down where they are. The area stays chosen
  /// when [keep] is true. It waits in the queue, so that a lift on its way is
  /// put down too.
  Future<void> placeSelection({bool keep = true}) {
    return _run(() async {
      final lifted = floating;
      if (lifted == null) return;
      final base = image!;
      final next = await _draw(base.width, base.height, (canvas) {
        canvas.drawImage(base, Offset.zero, Paint());
        canvas.drawImage(lifted.image, lifted.position, Paint());
      });
      floating = null;
      selection = keep ? _snap(lifted.rect) : null;
      lifted.image.dispose();
      _push(next);
      _changed();
    });
  }

  /// Puts the floating pixels down and lets go of the area.
  Future<void> dropSelection() async {
    await placeSelection(keep: false);
    selection = null;
    _changed();
  }

  void selectAll() {
    placeSelection();
    tool = Tool.select;
    selection = _imageRect();
    _changed();
  }

  Future<ClipboardImage?> _selectedPixels() async {
    await idle;
    final lifted = floating;
    final rect = selection;
    ui.Image? picture;
    var own = false;
    if (lifted != null) {
      picture = lifted.image;
    } else if (rect != null && image != null) {
      picture = await _crop(image!, rect);
      own = true;
    }
    if (picture == null) return null;
    final data = await picture.toByteData(
      format: ui.ImageByteFormat.rawStraightRgba,
    );
    final copy = ClipboardImage(
      width: picture.width,
      height: picture.height,
      rgba: data!.buffer.asUint8List(),
    );
    if (own) picture.dispose();
    return copy;
  }

  /// Copies the selection. True when there was something to copy.
  Future<bool> copySelection() async {
    final pixels = await _selectedPixels();
    if (pixels == null) return false;
    _copied = pixels;
    await clipboard.write(pixels);
    return true;
  }

  Future<bool> cutSelection() async {
    if (!await copySelection()) return false;
    await deleteSelection();
    return true;
  }

  /// Paper where the selection was. Floating pixels are just let go.
  Future<void> deleteSelection() => _run(() async {
    final lifted = floating;
    if (lifted != null) {
      lifted.image.dispose();
      floating = null;
      selection = null;
      _changed();
      return;
    }
    final rect = selection;
    if (rect == null) return;
    final base = image!;
    final next = await _draw(base.width, base.height, (canvas) {
      canvas.drawImage(base, Offset.zero, Paint());
      canvas.drawRect(rect, Paint()..color = paperColor);
    });
    selection = null;
    _push(next);
    _changed();
  });

  /// Pastes the picture of the system clipboard, or the last copy made here,
  /// floating on the top left of the selection or of the sheet. False when
  /// there was nothing to paste.
  Future<bool> paste() async {
    final pixels = await clipboard.read() ?? _copied;
    if (pixels == null) return false;
    await placeSelection();
    final at = selection?.topLeft ?? Offset.zero;
    final picture = await imageFromPixels(
      pixels.rgba,
      pixels.width,
      pixels.height,
    );
    await _run(() async {
      // A step of its own, so that undo takes the pasted picture away.
      _push(image!.clone());
      floating = Floating(picture, at);
      selection = null;
      tool = Tool.select;
      _changed();
    });
    return true;
  }
}
