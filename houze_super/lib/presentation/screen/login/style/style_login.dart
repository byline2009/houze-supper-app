import 'package:flutter/material.dart';

/*
 * Chưa toàn bộ style của màn hình login
 */
class StyleLogin {
  static const String strVietNamese = 'vietnamese';
  static const String strEnglish = 'english';

  static const String strWellcome = 'welcome';
  static const String strTitleEnterPsw = 'enter_your_password';
  static const String strPleaseEnterPassword = 'enter_your_password_to_sign_in';
  static const String strPleaseEnterPhone =
      'enter_your_phone_number_to_sign_in';

  static EdgeInsets margin_20 = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 40,
  );

  static BoxDecoration borderBlackOutline = BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: Colors.black,
        width: 1,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(5.0)));
}
