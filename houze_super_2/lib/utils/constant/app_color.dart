import 'package:flutter/material.dart';
import 'package:houze_super/presentation/custom_ui/hex_color.dart';

class AppColor {
  //status color
  static final HexColor ff9b00 = HexColor('#ff9b00');
  static final HexColor green_38d6ac = HexColor('#38d6ac');
  static final HexColor green_00aa7d = HexColor('#00aa7d');
  // ignore: non_constant_identifier_names
  static final HexColor orange_d68100 = HexColor('#d68100');
  // ignore: non_constant_identifier_names
  static final HexColor red_c50000 = HexColor('#c50000');

  static final HexColor ff6666 = HexColor('#ff6666');
  //Purple
  static final HexColor purple_725ef6 = HexColor('#725ef6');
  static final HexColor purple_6001d1 = HexColor('#6001d1');
  static final HexColor purple_7a1dff = HexColor('#7A1DFF');
  static final HexColor purple_6001d2 = HexColor('#6001d2');
  // ignore: non_constant_identifier_names
  static final HexColor purple_f2e8ff = HexColor('#f2e8ff');
  static final HexColor purple_5b00e4 = HexColor('#5b00e4');
  // ignore: non_constant_identifier_names
  static final HexColor purple_dac0ff = HexColor('#dac0ff');
  //Gray
  // ignore: non_constant_identifier_names
  static final HexColor gray_eff2fc = HexColor('#eff2fc');
  // ignore: non_constant_identifier_names
  static final HexColor gray_f5f5f5 = HexColor('#f5f5f5');
  static final HexColor gray_838383 = HexColor('#838383');
  static final HexColor gray_808080 = HexColor('#808080');
  static final HexColor gray_9c9c9c = HexColor("#9c9c9c");
  // ignore: non_constant_identifier_names
  static final HexColor gray_dcdcdc = HexColor("#dcdcdc");
  // ignore: non_constant_identifier_names
  static final HexColor gray_f5f7f8 = HexColor("#f5f7f8");
// ignore: non_constant_identifier_names
  static final HexColor gray_b5b5b5 = HexColor("#b5b5b5");
  // ignore: non_constant_identifier_names
  static final HexColor gray_bfbfbf = HexColor("#bfbfbf");
  // ignore: non_constant_identifier_names
  static final HexColor gray_737373 = HexColor('#737373');
  // ignore: non_constant_identifier_names
  static final HexColor gray_d0d0d0 = HexColor("#d0d0d0");
  // ignore: non_constant_identifier_names
  static final HexColor gray_d1d6de = HexColor("#d1d6de");

  static final HexColor black = HexColor("#000000");
  static final HexColor grey = HexColor("#808080");
  static final HexColor white = HexColor("#ffffff");
  //Yellow
  // ignore: non_constant_identifier_names
  static final HexColor yellow_ffcc44 = HexColor("#ffcc44");

  static final Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xff725ef6), Color(0xff6001d1)]);

  static final Gradient gradientGray = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xfff5f5f5), Color(0xfff5f5f5)]);
  static final Gradient gradientBlack = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color.fromRGBO(255, 255, 255, 0.0), Color(0xff000000)]);

  static final HexColor colorInfo = HexColor("#0044c2");
  static final HexColor backgroundColorInfo = HexColor("#edf3ff");
  static final HexColor backgroundOrangeInfo = HexColor("#fff8e7");
}
