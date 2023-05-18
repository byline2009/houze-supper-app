import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';

class CameraScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;
  final VoidCallback onPressed;

  CameraScaffold({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.close),
            color: Colors.white,
            onPressed: () => title.contains('take_a_your_selfie')
                ? Navigator.of(context).pop()
                : Navigator.of(context)
                    .popUntil(ModalRoute.withName(AppRouter.EKYC)),
          ),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                LocalizationsUtil.of(context).translate(title),
                style: AppFont.BOLD_WHITE_18,
              ),
              if (subtitle.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 4.0),
                  child: Text(
                    LocalizationsUtil.of(context).translate(subtitle),
                    style: AppFonts.semibold13.copyWith(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: body),
      floatingActionButton: Container(
        width: 64.0,
        height: 64.0,
        margin: EdgeInsets.only(bottom: 32.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(2.0),
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Colors.white,
          elevation: 8.0,
          foregroundColor: Color(0xFF6001d2),
          shape: CircleBorder(
            side: BorderSide(
              color: Color(0xFF6001d2),
              width: 2.0,
            ),
          ),
          child: Icon(
            Icons.camera_alt,
            size: 28.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CardPainter extends CustomPainter {
  final ValueChanged<double> getWidth;
  final ValueChanged<double> getHeight;

  CardPainter({required this.getWidth, required this.getHeight});

  @override
  void paint(Canvas canvas, Size size) {
    getWidth(size.width);
    getHeight(size.height);

    final Paint paint = Paint()
      ..strokeWidth = 0.0
      ..color = Colors.black.withOpacity(0.65);

    canvas
      ..drawRect(
          Rect.fromLTWH(
            0.0,
            0.0,
            size.width,
            size.height / 6,
          ),
          paint)
      ..drawRect(
          Rect.fromLTWH(
            0.0,
            size.height / 6 + (size.width - 40.0) * 2 / 3,
            size.width,
            size.height,
          ),
          paint)
      ..drawRect(
          Rect.fromLTWH(
            0.0,
            size.height / 6,
            20.0,
            (size.width - 40.0) * 2 / 3,
          ),
          paint)
      ..drawRect(
          Rect.fromLTWH(
            size.width - 20.0,
            size.height / 6,
            20.0,
            (size.width - 40.0) * 2 / 3,
          ),
          paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SelfiePainter extends CustomPainter {
  final ValueChanged<double> getWidth;
  final ValueChanged<double> getHeight;

  SelfiePainter({required this.getWidth, required this.getHeight});

  @override
  void paint(Canvas canvas, Size size) {
    getWidth(size.width);
    getHeight(size.height);

    final Paint paint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..color = Colors.deepPurpleAccent.shade400;

    canvas.drawRect(
      Rect.fromLTWH(32.0, 32.0, size.width - 64.0, (size.width - 64.0) * 4 / 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
