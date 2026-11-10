import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/l10n.dart';
import '../../paint/operations.dart';
import '../../paint/plume_controller.dart';

/// The sheet of paper, with room around it and scroll bars when it does not
/// fit.
class CanvasView extends StatefulWidget {
  const CanvasView({super.key, required this.controller});

  final PlumeController controller;

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  final _vertical = ScrollController();
  final _horizontal = ScrollController();

  @override
  void dispose() {
    _vertical.dispose();
    _horizontal.dispose();
    super.dispose();
  }

  void _onSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent ||
        !HardwareKeyboard.instance.isControlPressed) {
      return;
    }
    // Ctrl and the wheel zoom instead of scrolling.
    GestureBinding.instance.pointerSignalResolver.register(event, (_) {
      final controller = widget.controller;
      event.scrollDelta.dy < 0 ? controller.zoomIn() : controller.zoomOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    return Listener(
      onPointerSignal: _onSignal,
      child: LayoutBuilder(
        builder: (context, box) => ListenableBuilder(
          listenable: controller,
          builder: (context, _) => Scrollbar(
            controller: _vertical,
            child: Scrollbar(
              controller: _horizontal,
              notificationPredicate: (n) => n.depth == 1,
              child: SingleChildScrollView(
                controller: _vertical,
                child: SingleChildScrollView(
                  controller: _horizontal,
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: box.maxWidth,
                      minHeight: box.maxHeight,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: _Sheet(controller: controller),
                      ),
                    ),
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

class _Sheet extends StatelessWidget {
  const _Sheet({required this.controller});

  final PlumeController controller;

  Offset _toImage(Offset local) => local / controller.zoom;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final zoom = controller.zoom;
    final size = Size(controller.width * zoom, controller.height * zoom);
    return Semantics(
      image: true,
      label: l10n.canvasLabel(controller.width, controller.height),
      child: MouseRegion(
        cursor: SystemMouseCursors.precise,
        onHover: (event) => controller.setCursor(_toImage(event.localPosition)),
        onExit: (_) => controller.setCursor(null),
        child: Listener(
          onPointerDown: (event) {
            if (event.buttons != kPrimaryButton) return;
            controller.pointerDown(_toImage(event.localPosition));
          },
          onPointerMove: (event) {
            final point = _toImage(event.localPosition);
            controller.cursor = point;
            controller.pointerMove(
              point,
              constrain: HardwareKeyboard.instance.isShiftPressed,
            );
          },
          onPointerUp: (_) => controller.pointerUp(),
          onPointerCancel: (_) => controller.pointerUp(),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRect(
              child: CustomPaint(
                size: size,
                painter: _SheetPainter(controller),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetPainter extends CustomPainter {
  _SheetPainter(this.controller) : super(repaint: controller);

  final PlumeController controller;

  @override
  void paint(Canvas canvas, Size size) {
    final image = controller.image;
    if (image == null) return;
    canvas.scale(controller.zoom);
    canvas.drawImage(
      image,
      Offset.zero,
      // Zoomed in, each pixel shows as a square, as in any paint program.
      Paint()
        ..filterQuality = controller.zoom >= 2
            ? FilterQuality.none
            : FilterQuality.medium,
    );
    canvas.clipRect(
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
    );
    for (final op in controller.pending) {
      _paint(canvas, op);
    }
    final live = controller.live;
    if (live != null) _paint(canvas, live);
  }

  void _paint(Canvas canvas, Operation op) => paintOperation(
    canvas,
    op,
    stamp: op is StampOp ? controller.stamps[op.level] : null,
  );

  @override
  bool shouldRepaint(_SheetPainter old) => old.controller != controller;
}
