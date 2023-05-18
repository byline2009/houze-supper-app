import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class TicketCard extends StatelessWidget {
  TicketCard({
    this.lineFromPosition = 0,
    this.lineRadius = 10,
    this.lineColor,
    this.child,
    this.decoration,
  });

  final double lineFromPosition;

  final double lineRadius;

  final Widget? child;

  final TicketDecoration? decoration;

  final Color? lineColor;

  @override
  Widget build(BuildContext context) {
    SemiCircleClipper clipper = SemiCircleClipper(
      radius: lineRadius,
      fromTop: lineFromPosition,
    );
    return CustomPaint(
      child: ClipPath(
        clipper: clipper,
        child: child ?? SizedBox(),
      ),
      foregroundPainter: SeparatorPainter(
          clipper: clipper,
          fromTop: lineFromPosition,
          radius: lineRadius,
          color: lineColor!),
      painter: ShadowPainter(clipper: clipper, decoration: decoration!),
    );
  }
}

class SemiCircleClipper extends CustomClipper<Path> {
  SemiCircleClipper({
    required this.fromTop,
    required this.radius,
  });

  final double fromTop;

  final double radius;

  @override
  Path getClip(Size size) {
    print("$fromTop | $radius | ${size.width} , ${size.height}");
    var path = Path();

    //Vertical
//    path
//      ..moveTo(0, 0)
//      ..lineTo(0, max(fromTop - radius, 0))
//      ..arcToPoint(Offset(radius, fromTop),
//          clockwise: true, radius: Radius.circular(radius))
//      ..arcToPoint(Offset(0, fromTop + radius),
//          clockwise: true, radius: Radius.circular(radius))
//      ..lineTo(0, size.height)
//      ..lineTo(size.width, size.height)
//      ..lineTo(size.width, fromTop + radius)
//      ..arcToPoint(Offset(size.width - radius, fromTop),
//          clockwise: true, radius: Radius.circular(radius))
//      ..arcToPoint(Offset(size.width, max(fromTop - radius, 0)),
//          radius: Radius.circular(radius))
//      ..lineTo(size.width, 0)
//      ..close();

    //Horizontal TODO
    path
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..lineTo(fromTop - radius, size.height)
      ..arcToPoint(Offset(fromTop + radius, size.height),
          clockwise: true, radius: Radius.circular(radius))
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(fromTop + radius, 0)
      ..arcToPoint(Offset(fromTop - radius, 0), radius: Radius.circular(radius))
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => oldClipper != this;
}

class ShadowPainter extends CustomPainter {
  ShadowPainter({
    required this.clipper,
    TicketDecoration? decoration,
  }) : _decoration = decoration ?? TicketDecoration();

  final CustomClipper<Path> clipper;

  final TicketDecoration _decoration;

  TicketBorder? get _border => _decoration.border;

  @override
  void paint(Canvas canvas, Size size) {
    if (_border != null) {
      if (_border!.style == TicketBorderStyle.none) return;
      Paint paint = Paint()
        ..color = _border?.color ?? Colors.black
        ..strokeWidth = _border?.width ?? 0.5
        ..style = PaintingStyle.stroke;
      Path path = clipper.getClip(size);
      switch (_border?.style ?? '') {
        case TicketBorderStyle.none:
          return;
        case TicketBorderStyle.solid:
          break;
        case TicketBorderStyle.dotted:
          path = dashPath(path,
              dashArray: CircularIntervalList<double>(<double>[5, 5]));
          break;
      }
      canvas.drawPath(path, paint);
    }

    _decoration.shadow.forEach((BoxShadow shadow) {
      var paint = shadow.toPaint();
      var spreadSize = Size(size.width + shadow.spreadRadius * 2,
          size.height + shadow.spreadRadius * 2);
      var clipPath = clipper.getClip(spreadSize).shift(Offset(
          shadow.offset.dx - shadow.spreadRadius,
          shadow.offset.dy - shadow.spreadRadius));
      canvas.drawPath(clipPath, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SeparatorPainter extends CustomPainter {
  SeparatorPainter({
    this.clipper,
    required this.fromTop,
    required this.radius,
    this.color,
  });
  final CustomClipper<Path>? clipper;

  final double radius;

  final double fromTop;

  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    if (fromTop == 0) return;
    Paint paint = Paint()
      ..color = color ?? Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    //For Vertical
//    Path path = Path()
//      ..moveTo(radius + 5, fromTop)
//      ..lineTo(size.width - radius - 5, fromTop);

    //For Horizontal
    Path path = Path()
      ..moveTo(fromTop, radius + 5)
      ..lineTo(fromTop, size.height - radius - 5);

    canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList<double>(<double>[5, 5])),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

enum TicketBorderStyle { none, solid, dotted }

class TicketBorder {
  TicketBorder({
    this.color,
    this.width,
    this.style,
  });
  final Color? color;
  final double? width;
  final TicketBorderStyle? style;
}

class TicketDecoration {
  TicketDecoration({
    this.shadow = const [],
    this.border,
  });

  final List<BoxShadow> shadow;

  final TicketBorder? border;
}
