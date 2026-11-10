import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

enum Tool {
  select,
  pencil,
  brush,
  eraser,
  fill,
  picker,
  text,
  line,
  rectangle,
  ellipse,
  stamp,
}

extension ToolInfo on Tool {
  /// Whether the tool works by dragging over the sheet.
  bool get drags => switch (this) {
    Tool.fill || Tool.picker || Tool.stamp => false,
    _ => true,
  };

  bool get isShape =>
      this == Tool.line || this == Tool.rectangle || this == Tool.ellipse;

  /// The four sizes the tool offers, in pixels.
  List<double> get sizes => switch (this) {
    Tool.pencil => const [1, 2, 3, 5],
    Tool.brush => const [3, 6, 12, 24],
    Tool.eraser => const [8, 16, 32, 56],
    Tool.stamp => const [48, 96, 160, 240],
    Tool.text => const [16, 24, 36, 56],
    _ => const [1, 3, 6, 12],
  };

  bool get hasSizes =>
      this != Tool.fill && this != Tool.picker && this != Tool.select;
}

/// The colour of a blank sheet, and of what the eraser leaves.
const paperColor = Color(0xFFFFFFFF);

/// Something drawn on the sheet. The same description draws the preview while
/// the pointer moves and the final pixels, so both always match.
sealed class Operation {
  const Operation();
}

class StrokeOp extends Operation {
  StrokeOp({
    required this.color,
    required this.width,
    required this.smooth,
    required List<Offset> points,
  }) : points = List.of(points);

  final Color color;
  final double width;

  /// A round, soft brush. Without it, a hard pencil with square ends.
  final bool smooth;
  final List<Offset> points;
}

class ShapeOp extends Operation {
  const ShapeOp({
    required this.tool,
    required this.color,
    required this.width,
    required this.start,
    required this.end,
    required this.filled,
  });

  final Tool tool;
  final Color color;
  final double width;
  final Offset start;
  final Offset end;
  final bool filled;

  ShapeOp copyWith({Offset? end}) => ShapeOp(
    tool: tool,
    color: color,
    width: width,
    start: start,
    end: end ?? this.end,
    filled: filled,
  );
}

class TextOp extends Operation {
  const TextOp({
    required this.text,
    required this.position,
    required this.size,
    required this.color,
    required this.serif,
  });

  final String text;

  /// The top left corner of the first line.
  final Offset position;
  final double size;
  final Color color;
  final bool serif;
}

/// The look of the text tool, the same in the editor and in the pixels.
TextStyle plumeTextStyle({
  required double size,
  required Color color,
  required bool serif,
}) => TextStyle(
  fontFamily: serif ? 'CardSerif' : 'PlumeSans',
  fontSize: size,
  height: 1.25,
  color: color,
);

class StampOp extends Operation {
  const StampOp({required this.level, required this.center, required this.size});

  final int level;
  final Offset center;

  /// The longest side of the stamp, in pixels.
  final double size;
}

/// The end of a shape held with Shift: lines snap to every 45 degrees, and
/// rectangles and ellipses become squares and circles.
Offset constrainEnd(Tool tool, Offset start, Offset end) {
  final delta = end - start;
  if (tool == Tool.line) {
    final step = pi / 4;
    final angle = (atan2(delta.dy, delta.dx) / step).round() * step;
    final length = delta.distance;
    return start + Offset(cos(angle) * length, sin(angle) * length);
  }
  final side = max(delta.dx.abs(), delta.dy.abs());
  return start + Offset(side * _sign(delta.dx), side * _sign(delta.dy));
}

double _sign(double value) => value < 0 ? -1 : 1;

/// The rectangle a stamp of [size] takes around its centre.
Rect stampRect(StampOp op, Size image) {
  final scale = op.size / max(image.width, image.height);
  return Rect.fromCenter(
    center: op.center,
    width: image.width * scale,
    height: image.height * scale,
  );
}

void paintOperation(Canvas canvas, Operation op, {ui.Image? stamp}) {
  switch (op) {
    case StrokeOp():
      final paint = Paint()
        ..color = op.color
        ..isAntiAlias = op.smooth;
      final first = op.points.first;
      if (op.points.length == 1) {
        if (op.smooth) {
          canvas.drawCircle(first, op.width / 2, paint);
        } else {
          canvas.drawRect(
            Rect.fromCenter(center: first, width: op.width, height: op.width),
            paint,
          );
        }
        return;
      }
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = op.width
        ..strokeCap = op.smooth ? StrokeCap.round : StrokeCap.square
        ..strokeJoin = op.smooth ? StrokeJoin.round : StrokeJoin.miter;
      final path = Path()..moveTo(first.dx, first.dy);
      for (final point in op.points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, paint);
    case ShapeOp():
      final paint = Paint()
        ..color = op.color
        ..strokeWidth = op.width
        ..strokeCap = StrokeCap.round
        ..style = op.filled && op.tool != Tool.line
            ? PaintingStyle.fill
            : PaintingStyle.stroke;
      final rect = Rect.fromPoints(op.start, op.end);
      switch (op.tool) {
        case Tool.line:
          canvas.drawLine(op.start, op.end, paint);
        case Tool.ellipse:
          canvas.drawOval(rect, paint);
        default:
          canvas.drawRect(rect, paint);
      }
    case TextOp():
      final painter = TextPainter(
        text: TextSpan(
          text: op.text,
          style: plumeTextStyle(size: op.size, color: op.color, serif: op.serif),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, op.position);
      painter.dispose();
    case StampOp():
      if (stamp == null) return;
      final source = Size(stamp.width.toDouble(), stamp.height.toDouble());
      canvas.drawImageRect(
        stamp,
        Offset.zero & source,
        stampRect(op, source),
        Paint()..filterQuality = FilterQuality.high,
      );
  }
}
