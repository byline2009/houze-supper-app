
/*
 * Define TextStyles
 */

import 'package:flutter/material.dart';

class AppFonts {
  static const String font_family_display = 'SFProDisplay';

  /*
   * Regular
   */

  static const regular = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.black,
    fontSize: 14.0,
    letterSpacing: 0.3,
    fontFamily: font_family_display,
  );

  static final regular13 = regular.copyWith(
    fontSize: 13,
  );

  static final regular12 = regular.copyWith(
    fontSize: 12,
  );

  static final regular14 = regular.copyWith(
    fontSize: 14,
  );

  static final regular15 = regular.copyWith(
    fontSize: 15,
  );
  static final regular16 = regular.copyWith(
    fontSize: 16,
  );

  /*
   * Medium
   */
  static const medium = TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontFamily: font_family_display,
    fontSize: 14.0,
  );

  static final medium10 = medium.copyWith(
    fontSize: 10.0,
  );

  static final medium11 = medium.copyWith(
    fontSize: 11.0,
  );

  static final medium12 = medium.copyWith(
    fontSize: 12.0,
  );

  static final medium13 = medium.copyWith(
    fontSize: 13.0,
  );

  static final medium14 = medium.copyWith(
    fontSize: 14.0,
  );

  static final medium16 = medium.copyWith(
    fontSize: 16.0,
  );

  static final medium18 = medium.copyWith(
    fontSize: 18.0,
  );

  static final medium22 = medium.copyWith(
    fontSize: 22.0,
  );

  /*
   * Semibold
   */

  static const semibold = TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.black,
    letterSpacing: 0.26,
    fontFamily: font_family_display,
  );
  static final semibold12 = semibold.copyWith(fontSize: 12);
  static final semibold13 = semibold.copyWith(fontSize: 13);
  static final semibold14 = semibold.copyWith(fontSize: 14);
  static final semibold16 = semibold.copyWith(fontSize: 16);
  static final semibold18 = semibold.copyWith(fontSize: 18);
  static final semibold15 = semibold.copyWith(fontSize: 15);
  static final semibold24 = semibold.copyWith(fontSize: 24);

  /*
   * Bold
   */
  static const bold = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
    letterSpacing: 0.29,
    fontSize: 14,
    fontFamily: font_family_display,
  );

  static final bold12 = bold.copyWith(fontSize: 12);
  static final bold13 = bold.copyWith(fontSize: 13);
  static final bold14 = bold.copyWith(fontSize: 14);

  static final bold15 = bold.copyWith(fontSize: 15);
  static final bold16 = bold.copyWith(fontSize: 16);
  static final bold18 = bold.copyWith(fontSize: 18);
  static final bold20 = bold.copyWith(fontSize: 20);
  static final bold22 = bold.copyWith(fontSize: 22);
  static final bold24 = bold.copyWith(fontSize: 24);
  static final bold27 = bold.copyWith(fontSize: 27);
}
