import 'package:flutter/material.dart';
import 'package:houze_super/utils/constant/index.dart';

/*
 * Chưa toàn bộ style của màn hình login
 */
class StyleLogin {
  static final String strVietNamese = 'vietnamese';
  static final String strEnglish = 'english';

  static final String strWellcome = 'welcome';
  static final String strTitleEnterPsw = 'enter_your_password';
  static final String strPleaseEnterPassword = 'enter_your_password_to_sign_in';
  static final String strPleaseEnterPhone =
      'enter_your_phone_number_to_sign_in';

  static EdgeInsets margin_20 = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 40,
  );

  static BoxDecoration borderBlackOutline = BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: AppColor.black,
        width: 1,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.all(Radius.circular(5.0)));
}
