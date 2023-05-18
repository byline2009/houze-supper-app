import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/index.dart';

class WidgetTextBase {
  static Widget textTopRight(String txt, Function()? onPressed) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.padded,
            primary: Colors.white,
            elevation: 0,
            padding: EdgeInsets.all(0)),
        onPressed: onPressed,
        child: Text(txt,
            textAlign: TextAlign.end,
            style: AppFonts.medium14.copyWith(
              color: Color(
                0xff5B00E4,
              ),
            )));
  }

  static Widget textTopRightHasICon(String txt,
      {required String iconName, TextStyle? style, Function()? onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          alignment: Alignment.topCenter,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          primary: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(iconName),
          const SizedBox(width: 5),
          Text(txt,
              textAlign: TextAlign.start,
              style: style ??
                  AppFonts.medium14.copyWith(
                    color: Color(
                      0xff5B00E4,
                    ),
                  )),
        ],
      ),
    );
  }
}
