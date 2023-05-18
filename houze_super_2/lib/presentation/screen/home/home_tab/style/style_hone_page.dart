import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyleHomePage {
  static final double serviceWidth =
      (140.0 * ScreenUtil.defaultSize.width) / 375;
  static final double serviceImageHeight = 179.0;
  static final double containerServiceHeight = 231.0;

  static final double padding_20 = 20.0;
  static final int maxServiceShow = 5;
  static final double borderRadius = 25.0;
  static double bottomSheetHeight(BuildContext context) =>
      (300 / 667) * MediaQuery.of(context).size.height;
}
