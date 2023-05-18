import 'package:flutter/material.dart';
import 'package:houze_super/presentation/custom_ui/hex_color.dart';

class AppColors {
  static const Gradient gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xff725ef6),
      Color(
        0xff6001d1,
      ),
    ],
  );

  static const Gradient gradientGray = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xfff5f5f5),
      Color(
        0xfff5f5f5,
      ),
    ],
  );

  static const Gradient gradientBlack = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.fromRGBO(255, 255, 255, 0.0),
        Color(0xff000000),
      ]);

  static final HexColor colorInfo = HexColor("#0044c2");
  static final HexColor backgroundColorInfo = HexColor("#edf3ff");
  static final HexColor backgroundOrangeInfo = HexColor("#fff8e7");
}
