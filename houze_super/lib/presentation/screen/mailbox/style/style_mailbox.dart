import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class MailboxStyle {
  static const double heightItem = 151.0;
  static BoxDecoration floatingDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    gradient: AppColors.gradient,
  );

  static BoxDecoration indicatorDecor = BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.transparent, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(4.0)));
  static BoxDecoration issueTabbarDecor = BoxDecoration(
      color: Color(0xfff5f7f8),
      border: Border.all(color: Colors.transparent, style: BorderStyle.solid),
      borderRadius: BorderRadius.all(Radius.circular(4.0)));

  static const double heightAvatar = 54.0;
  static const double widthAvatar = 54.0;
}
