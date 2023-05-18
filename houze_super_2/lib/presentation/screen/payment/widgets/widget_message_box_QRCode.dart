import 'package:flutter/material.dart';
import 'package:houze_super/utils/localizations_util.dart';

class MessageBoxQRCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _widthImage = MediaQuery.of(context).size.width * 50 / 100 - 30;

    return Container(
      width: _widthImage,
      padding: EdgeInsets.only(left: 4.0),
      margin: EdgeInsets.only(left: 10.0, bottom: 20.0),
      child: Container(
        padding: EdgeInsets.only(top: 12.0, left: 12, right: 12, bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF725ef6),
              Color(0xFF8e01d1),
            ],
          ),
        ),
        child: Text(
          LocalizationsUtil.of(context)
              .translate('quick_transfer_by_scanning_qrcode'),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF725ef6),
            Color(0xFF8e01d1),
          ],
        ),
        shape: ArrowMessageBorder(),
      ),
    );
  }
}

class ArrowMessageBorder extends ShapeBorder {
  final bool usePadding;

  ArrowMessageBorder({this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 10 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(rect.centerLeft, rect.centerLeft);
    //   Path()
    // ..moveTo(12.0, 12.0)
    // ..lineTo(0, 24.0)
    // ..lineTo(12.0, 36.0)
    // ..close();
    return Path()
      ..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
      ..moveTo(rect.bottomCenter.dx - 5, rect.bottomCenter.dy - 8)
      ..relativeLineTo(10, 12)
      ..relativeLineTo(0, -24)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
