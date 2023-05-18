import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

class WidgetTextBase {
  static Widget textTopRight(String txt, Function onPressed) {
    return InkWell(
        splashColor: Color(0xfff2e8ff),
        highlightColor: Color(0xfff2e8ff),
        onTap: onPressed,
        child: Text(txt,
            textAlign: TextAlign.end,
            style: AppFonts.medium14.copyWith(color: Color(0xff5b00e4))));
  }

  static Widget textTopRightHasICon(String txt,
      {String iconName, TextStyle style, Function onPressed}) {
    return InkWell(
        highlightColor: Color(0xfff2e8ff),
        hoverColor: Color(0xfff2e8ff),
        focusColor: Color(0xfff2e8ff),
        splashColor: Color(0xfff2e8ff),
        onTap: onPressed,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(iconName),
              SizedBox(width: 5),
              Text(txt,
                  textAlign: TextAlign.end,
                  style: style ??
                      AppFonts.medium14.copyWith(color: Color(0xff5b00e4)))
            ]));
  }
}
