import 'package:flutter/material.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/index.dart';

/*
 *Rule đặt tên: Loại font - màu - tên màu 
 */

class AppFont {
  static const String font_family_display = 'SFProDisplay';

  // ignore: non_constant_identifier_names
  static final REGULAR = TextStyle(
      fontWeight: FontWeight.w400,
      color: AppColor.black,
      fontSize: 14.0,
      letterSpacing: 0.3,
      fontFamily: font_family_display);

  // ignore: non_constant_identifier_names
  static final MEDIUM = TextStyle(
    fontWeight: FontWeight.w500,
    color: AppColor.black,
    fontSize: 14.0,
    fontFamily: font_family_display,
  );

  // ignore: non_constant_identifier_names
  static final SEMIBOLD = TextStyle(
    fontWeight: FontWeight.w600,
    // color: AppColor.black,
    letterSpacing: 0.26,
    fontFamily: font_family_display,
  );

  // ignore: non_constant_identifier_names
  static final BOLD = TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColor.black,
      letterSpacing: 0.26,
      fontFamily: font_family_display);

  //REGULAR
  // ignore: non_constant_identifier_names
  static final REGULAR_DEFAULT = REGULAR.copyWith(color: Colors.white);
  // ignore: non_constant_identifier_names
  static final REGULAR_DEFAULT_10 = REGULAR_DEFAULT.copyWith(fontSize: 10);
  // ignore: non_constant_identifier_names
  static final REGULAR_DEFAULT_12 = REGULAR_DEFAULT.copyWith(fontSize: 12);

  // ignore: non_constant_identifier_names
  static final REGULAR_WHITE = REGULAR.copyWith(color: Colors.white);
  // ignore: non_constant_identifier_names
  static final REGULAR_WHITE_8 = REGULAR_WHITE.copyWith(fontSize: 8);
  // ignore: non_constant_identifier_names
  static final REGULAR_WHITE_10 = REGULAR_WHITE.copyWith(fontSize: 10);
  // ignore: non_constant_identifier_names
  static final REGULAR_WHITE_12 = REGULAR_WHITE.copyWith(fontSize: 12);
  // ignore: non_constant_identifier_names
  static final REGULAR_WHITE_14 = REGULAR_WHITE.copyWith(fontSize: 14);
  // ignore: non_constant_identifier_names
  static final REGULAR_WHITE_16 = REGULAR_WHITE.copyWith(fontSize: 16);

  // ignore: non_constant_identifier_names
  static final REGULAR_BLACK = REGULAR.copyWith(color: AppColor.black);
  // ignore: non_constant_identifier_names
  static final REGULAR_BLACK_8 = REGULAR_BLACK.copyWith(fontSize: 8);
  // ignore: non_constant_identifier_names
  static final REGULAR_BLACK_10 = REGULAR_BLACK.copyWith(fontSize: 10);
  // ignore: non_constant_identifier_names
  static final REGULAR_BLACK_12 = REGULAR_BLACK.copyWith(fontSize: 12);
  // ignore: non_constant_identifier_names
  static final REGULAR_BLACK_13 = REGULAR_BLACK.copyWith(fontSize: 13);
  // ignore: non_constant_identifier_names
  static final REGULAR_BLACK_14 = REGULAR_BLACK.copyWith(fontSize: 14);
  // ignore: non_constant_identifier_names
  static final REGULAR_BLACK_15 = REGULAR_BLACK.copyWith(fontSize: 15);
  // ignore: non_constant_identifier_names
  static final REGULAR_BLACK_16 = REGULAR_BLACK.copyWith(fontSize: 16);
// ignore: non_constant_identifier_names
  static final REGULAR_BLACK_18 = REGULAR_BLACK.copyWith(fontSize: 18);
  // ignore: non_constant_identifier_names
  static final REGULAR_GRAY = REGULAR.copyWith(color: AppColor.gray_838383);
  // ignore: non_constant_identifier_names
  static final REGULAR_GREY = REGULAR.copyWith(color: AppColor.gray_808080);
  // ignore: non_constant_identifier_names
  static final REGULAR_GREY_B5B5B5 =
      REGULAR.copyWith(color: AppColor.gray_b5b5b5);
  // ignore: non_constant_identifier_names
  static final REGULAR_GRAY_838383_15 = REGULAR_GRAY.copyWith(fontSize: 15);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_9C9C9C_11 = MEDIUM.copyWith(
      color: AppColor.gray_9c9c9c, fontSize: 11, letterSpacing: 0.22);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_808080 =
      MEDIUM.copyWith(color: AppColor.gray_808080);
  // ignore: non_constant_identifier_names
  static final BOLD_BOLD_BLACK_18 = BOLD_BLACK.copyWith(
      fontSize: 18, fontFamily: font_family_display, letterSpacing: 0.29);
  // ignore: non_constant_identifier_names
  static final BOLD_BOLD_BLACK_15 =
      BOLD_BLACK.copyWith(fontSize: 15, fontFamily: font_family_display);
  // ignore: non_constant_identifier_names
  static final BOLD_Bold_Black_24 =
      BOLD_BLACK.copyWith(fontSize: 24, fontFamily: font_family_display);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GRAY_F5F5F5_13 =
      SEMIBOLD_GRAY_838383_13.copyWith(fontFamily: font_family_display);
  // ignore: non_constant_identifier_names
  static final BOLD_9c9c9c = BOLD.copyWith(
    fontFamily: font_family_display,
    color: AppColor.gray_9c9c9c,
  );
  // ignore: non_constant_identifier_names
  static final BOLD_9c9c9c_15 = BOLD_9c9c9c.copyWith(fontSize: 15);
  // ignore: non_constant_identifier_names
  static final BOLD_GRAY_838383_15 = REGULAR_GRAY_838383_15.copyWith(
      fontFamily: font_family_display, fontWeight: FontWeight.bold);
  // ignore: non_constant_identifier_names
  static final BOLD_GRAY_838383_13 = REGULAR_GRAY_838383.copyWith(
      fontFamily: font_family_display,
      fontSize: 13,
      fontWeight: FontWeight.bold);
  // ignore: non_constant_identifier_names
  static final BOLD_GRAY_838383_24 = BOLD_GRAY_838383_13.copyWith(fontSize: 24);

  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GRAY_838383_12 = SEMIBOLD.copyWith(
      color: AppColor.gray_838383,
      fontSize: 12,
      fontFamily: font_family_display,
      letterSpacing: 0.24);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_BLACK_13 = SEMIBOLD_BLACK.copyWith(fontSize: 13);

  // ignore: non_constant_identifier_names
  static final ProDisplay_SEMIBOLD_GRAY_838383_13 = SEMIBOLD_GRAY_838383_13
      .copyWith(fontFamily: font_family_display, letterSpacing: 0.26);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_D0D0D0_14 =
      MEDIUM.copyWith(color: AppColor.gray_d0d0d0, fontSize: 14);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_D0D0D0_16 = MEDIUM.copyWith(fontSize: 16);

  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_808080_10 =
      MEDIUM_GRAY_808080.copyWith(fontSize: 10, letterSpacing: 0.12);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_808080_12 =
      MEDIUM_GRAY_808080.copyWith(fontSize: 12, letterSpacing: 0.14);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_808080_14 =
      MEDIUM_GRAY_808080.copyWith(fontSize: 14);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_808080_16 =
      MEDIUM_GRAY_808080.copyWith(fontSize: 16);
  // ignore: non_constant_identifier_names
  static final REGULAR_GRAY_808080 =
      REGULAR.copyWith(color: AppColor.gray_808080);

  // ignore: non_constant_identifier_names
  static final REGULAR_GRAY_838383_14 =
      REGULAR.copyWith(color: AppColor.gray_838383, fontSize: 14);
  // ignore: non_constant_identifier_names
  static final REGULAR_GRAY_838383_13 =
      REGULAR.copyWith(color: AppColor.gray_838383, fontSize: 13);
  // ignore: non_constant_identifier_names
  static final REGULAR_GRAY_808080_15 =
      REGULAR_GRAY_808080.copyWith(fontSize: 15);
  // ignore: non_constant_identifier_names
  static final REGULAR_GRAY_808080_14 =
      REGULAR_GRAY_808080.copyWith(fontSize: 14);
  // ignore: non_constant_identifier_names
  static final REGULAR_GRAY_838383 =
      REGULAR.copyWith(color: AppColor.gray_838383);

  // ignore: non_constant_identifier_names
  static final REGULAR_GREY_15 = REGULAR_GREY.copyWith(fontSize: 15);

  /*MEDIUM*/

  // ignore: non_constant_identifier_names
  static final MEDIUM_WHITE = MEDIUM.copyWith(color: Colors.white);
  // ignore: non_constant_identifier_names
  static final MEDIUM_WHITE_12 = MEDIUM_WHITE.copyWith(fontSize: 12);
  // ignore: non_constant_identifier_names
  static final MEDIUM_WHITE_14 = MEDIUM_WHITE.copyWith(fontSize: 14);
  // ignore: non_constant_identifier_names
  static final MEDIUM_WHITE_16 = MEDIUM_WHITE.copyWith(fontSize: 16);
  // ignore: non_constant_identifier_names
  static final MEDIUM_WHITE_22 = MEDIUM_WHITE.copyWith(fontSize: 22);

  // ignore: non_constant_identifier_names
  static final MEDIUM_BLACK = MEDIUM.copyWith(color: AppColor.black);
  // ignore: non_constant_identifier_names
  static final MEDIUM_BLACK_14 = MEDIUM_BLACK.copyWith(fontSize: 14);
  // ignore: non_constant_identifier_names
  static final MEDIUM_BLACK_16 =
      MEDIUM_BLACK.copyWith(fontSize: 16, letterSpacing: 0.26);
  // ignore: non_constant_identifier_names
  static final MEDIUM_BLACK_18 =
      MEDIUM_BLACK.copyWith(fontSize: 18, letterSpacing: 0.29);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_BFBFBF =
      MEDIUM.copyWith(color: AppColor.gray_bfbfbf);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_BFBFBF_14 =
      MEDIUM_GRAY_BFBFBF.copyWith(fontSize: 14);

  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_ff6666_14 =
      MEDIUM.copyWith(color: AppColor.ff6666).copyWith(fontSize: 14);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_838383 =
      MEDIUM.copyWith(color: AppColor.gray_838383);
  // ignore: non_constant_identifier_names
  static final MEDIUM_GRAY_838383_14 =
      MEDIUM_GRAY_838383.copyWith(fontSize: 14);

  // ignore: non_constant_identifier_names
  static final MEDIUM_PURPLE_6001d2 =
      MEDIUM.copyWith(color: AppColor.purple_6001d2);
  // ignore: non_constant_identifier_names
  static final MEDIUM_PURPLE_838383 =
      MEDIUM.copyWith(color: AppColor.gray_838383);
  // ignore: non_constant_identifier_names
  static final MEDIUM_PURPLE_6001d2_13 =
      MEDIUM_PURPLE_6001d2.copyWith(fontSize: 13);
  // ignore: non_constant_identifier_names
  static final MEDIUM_PURPLE_838383_13 =
      MEDIUM_PURPLE_838383.copyWith(fontSize: 13);

  // ignore: non_constant_identifier_names
  static final MEDIUM_PURPLE_6001d2_14 =
      MEDIUM_PURPLE_6001d2.copyWith(fontSize: 14);

  // ignore: non_constant_identifier_names
  static final MEDIUM_PURPLE_7a1dff =
      MEDIUM.copyWith(color: AppColor.purple_7a1dff);
  // ignore: non_constant_identifier_names
  static final MEDIUM_PURPLE_7a1dff_14 =
      MEDIUM_PURPLE_7a1dff.copyWith(fontSize: 14);
  // ignore: non_constant_identifier_names
  static final MEDIUM_PURPLE_7a1dff_12 =
      MEDIUM_PURPLE_7a1dff.copyWith(fontSize: 12);
  // ignore: non_constant_identifier_names
  static final MEDIUM_PURPLE_5B00E4 =
      MEDIUM.copyWith(color: AppColor.purple_5b00e4);
// ignore: non_constant_identifier_names
  static final REGULAR_RED_C50000_16 = REGULAR.copyWith(
    color: AppColor.red_c50000,
    fontSize: 15,
    letterSpacing: 0.26,
  );
  // ignore: non_constant_identifier_names
  static final MEDIUM_RED_C50000_16 = MEDIUM.copyWith(
      color: AppColor.red_c50000, fontSize: 16, letterSpacing: 0.26);
  // ignore: non_constant_identifier_names
  static final MEDIUM_PURPLE_5B00E4_14 =
      MEDIUM_PURPLE_5B00E4.copyWith(fontSize: 14);

  //SEMI_BOLD

  // ignore: non_constant_identifier_names
  static final SEMIBOLD_WHITE = SEMIBOLD.copyWith(color: Colors.white);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_WHITE_12 = SEMIBOLD_WHITE.copyWith(fontSize: 12);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_WHITE_13 = SEMIBOLD_WHITE.copyWith(fontSize: 13);

  // ignore: non_constant_identifier_names
  static final SEMIBOLD_WHITE_16 = SEMIBOLD_WHITE.copyWith(fontSize: 16);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_WHITE_18 = SEMIBOLD_WHITE.copyWith(fontSize: 18);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_BLACK = SEMIBOLD.copyWith(color: AppColor.black);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_BLACK_12 = SEMIBOLD_BLACK.copyWith(fontSize: 12);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_BLACK_14 = SEMIBOLD_BLACK.copyWith(fontSize: 14);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_BLACK_16 = SEMIBOLD_BLACK.copyWith(fontSize: 16);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_BLACK_18 = SEMIBOLD_BLACK.copyWith(fontSize: 18);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_BLACK_24 = SEMIBOLD_BLACK.copyWith(fontSize: 24);

  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GRAY_9c9c9c =
      SEMIBOLD.copyWith(color: AppColor.gray_9c9c9c);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GRAY_9c9c9c_13 =
      SEMIBOLD_GRAY_9c9c9c.copyWith(fontSize: 13, letterSpacing: 0.26);

  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GRAY_9c9c9c_16 =
      SEMIBOLD_GRAY_9c9c9c.copyWith(fontSize: 16);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_PURPLE_5b00e4 =
      SEMIBOLD.copyWith(color: AppColor.purple_5b00e4);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_PURPLE_5b00e4_13 =
      SEMIBOLD_PURPLE_5b00e4.copyWith(fontSize: 13);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_PURPLE_6001d2_13 =
      SEMIBOLD_PURPLE_5b00e4_13.copyWith(color: AppColor.purple_6001d2);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_d68100_13 =
      SEMIBOLD_PURPLE_5b00e4_13.copyWith(color: AppColor.orange_d68100);

  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GRAY_808080 =
      SEMIBOLD.copyWith(color: AppColor.gray_808080);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GRAY_838383_13 =
      SEMIBOLD.copyWith(color: AppColor.gray_838383, fontSize: 13);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GREEN_00AA7D_13 =
      SEMIBOLD.copyWith(color: AppColor.green_00aa7d, fontSize: 13);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_PURPLE_DAC0FF =
      SEMIBOLD.copyWith(color: AppColor.purple_dac0ff);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_PURPLE_DAC0FF_13 =
      SEMIBOLD_PURPLE_DAC0FF.copyWith(fontSize: 13);

  // ignore: non_constant_identifier_names
  static final SEMIBOLD_PURPLE_7a1dff =
      SEMIBOLD.copyWith(color: AppColor.purple_7a1dff);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_PURPLE_7a1dff_13 =
      SEMIBOLD_PURPLE_7a1dff.copyWith(fontSize: 13);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_PURPLE_7a1dff_16 =
      SEMIBOLD_PURPLE_7a1dff.copyWith(fontSize: 16);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GRAY_808080_13 =
      SEMIBOLD_GRAY_808080.copyWith(fontSize: 13);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GRAY_B5B5B5 =
      SEMIBOLD.copyWith(color: AppColor.gray_b5b5b5);
  // ignore: non_constant_identifier_names
  static final SEMIBOLD_GRAY_B5B5B5_13 = SEMIBOLD_GRAY_B5B5B5.copyWith(
      fontSize: 13, letterSpacing: 0.26, height: 1.23);
  //BOLD
  // ignore: non_constant_identifier_names
  static final BOLD_BLACK =
      BOLD.copyWith(color: AppColor.black, letterSpacing: 0.24);
  // ignore: non_constant_identifier_names
  static final BOLD_BLACK_12 = BOLD_BLACK.copyWith(fontSize: 12);
  // ignore: non_constant_identifier_names
  static final BOLD_BLACK_15 = BOLD_BLACK.copyWith(fontSize: 15);
  // ignore: non_constant_identifier_names
  static final BOLD_BLACK_16 = BOLD_BLACK.copyWith(fontSize: 16);
  // ignore: non_constant_identifier_names
  static final BOLD_BLACK_18 = BOLD_BLACK.copyWith(fontSize: 18);
  // ignore: non_constant_identifier_names
  static final BOLD_BLACK_20 = BOLD_BLACK.copyWith(fontSize: 20);
  // ignore: non_constant_identifier_names
  static final BOLD_BLACK_22 = BOLD_BLACK.copyWith(fontSize: 22);
  // ignore: non_constant_identifier_names
  static final BOLD_BLACK_24 = BOLD_BLACK.copyWith(fontSize: 24);
  // ignore: non_constant_identifier_names
  static final BOLD_BLACK_27 = BOLD_BLACK.copyWith(fontSize: 27);
  // ignore: non_constant_identifier_names
  static final BOLD_BLACK_54 = BOLD_BLACK.copyWith(fontSize: 54);

  // ignore: non_constant_identifier_names
  static final BOLD_GREY = BOLD.copyWith(color: AppColor.gray_838383);

  // ignore: non_constant_identifier_names
  static final BOLD_GRAY = BOLD.copyWith(color: AppColor.gray_808080);

  // ignore: non_constant_identifier_names
  static final BOLD_WHITE = BOLD.copyWith(color: Colors.white);
  // ignore: non_constant_identifier_names
  static final BOLD_WHITE_16 = BOLD_WHITE.copyWith(fontSize: 16);
  // ignore: non_constant_identifier_names
  static final BOLD_WHITE_18 = BOLD_WHITE.copyWith(fontSize: 18);
  // ignore: non_constant_identifier_names
  static final BOLD_WHITE_20 = BOLD_WHITE.copyWith(fontSize: 20);
  // ignore: non_constant_identifier_names
  static final BOLD_WHITE_24 =
      BOLD_WHITE.copyWith(fontSize: 24, letterSpacing: 0.34);
  // ignore: non_constant_identifier_names
  static final BOLD_WHITE_15 = BOLD_WHITE.copyWith(fontSize: 15);

  // ignore: non_constant_identifier_names
  static final BOLD_YELLOW = BOLD.copyWith(color: AppColor.yellow_ffcc44);
  // ignore: non_constant_identifier_names
  static final BOLD_YELLOW_15 = BOLD_YELLOW.copyWith(fontSize: 15);

  // ignore: non_constant_identifier_names
  static final BOLD_GREEN_00aa7d_18 =
      BOLD_BLACK_18.copyWith(color: AppColor.green_00aa7d);

  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_6001d2 =
      BOLD.copyWith(color: AppColor.purple_6001d2);
  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_6001d2_15 =
      BOLD_PURPLE_6001d2.copyWith(fontSize: 15);
  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_6001d1_16 =
      BOLD_PURPLE_6001d1.copyWith(fontSize: 16);
  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_6001d2_18 =
      BOLD_PURPLE_6001d2.copyWith(fontSize: 18);
  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_7a1dff_14 =
      BOLD_PURPLE_7a1dff.copyWith(fontSize: 14);
  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_7a1dff_15 =
      BOLD_PURPLE_7a1dff.copyWith(fontSize: 15);
  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_6001d1 =
      BOLD.copyWith(color: AppColor.purple_6001d1);

  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_7a1dff =
      BOLD.copyWith(color: AppColor.purple_7a1dff);
  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_7a1dff_16 =
      BOLD_PURPLE_7a1dff.copyWith(fontSize: 16);

  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_DAC0FF =
      BOLD.copyWith(color: AppColor.purple_dac0ff);
  // ignore: non_constant_identifier_names
  static final BOLD_PURPLE_DAC0FF_15 =
      BOLD_PURPLE_DAC0FF.copyWith(fontSize: 15);
  // ignore: non_constant_identifier_names
  static final BOLD_RED_C50000_15 = BOLD_RED_C50000.copyWith(fontSize: 15);
  // ignore: non_constant_identifier_names
  static final BOLD_RED_C50000_16 = BOLD_RED_C50000.copyWith(fontSize: 16);
  // ignore: non_constant_identifier_names
  static final BOLD_RED_C50000 = BOLD.copyWith(color: AppColor.red_c50000);

  // ignore: non_constant_identifier_names
  static final BOLD_RED_C50000_18 =
      BOLD.copyWith(color: AppColor.red_c50000, fontSize: 18);

  // ignore: non_constant_identifier_names
  static final BOLD_d68100 = BOLD_BLACK.copyWith(color: AppColor.orange_d68100);
  // ignore: non_constant_identifier_names
  static final BOLD_d68100_18 = BOLD_d68100.copyWith(fontSize: 18);
}
