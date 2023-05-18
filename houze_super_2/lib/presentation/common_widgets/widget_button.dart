import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler();

class WidgetButton {
  static Widget backCircleButton(BuildContext context,
      {CallBackHandler? callback}) {
    return IconButton(
        icon:
            SvgPicture.asset(AppVectors.ic_back_overlay, height: 30, width: 30),
        onPressed: callback != null
            ? callback
            : () {
                Navigator.pop(context);
              },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent);
  }

  static Widget arrowCircle(Widget icon, dynamic callback) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
        primary: Colors.white,
        shape: CircleBorder(),
      ),
      onPressed: () {
        callback();
      },
      child: SizedBox(child: icon, width: 30, height: 30),
    );
  }

  static Widget pinkButton(
      {required String text, TextStyle? style, CallBackHandler? callback}) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Color(0xfff2e8ff),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.center,
          ),
        ));
  }

  static Widget pink(String text,
      {Color? color, Widget? icon, CallBackHandler? callback}) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: color == null ? AppColor.purple_f2e8ff : color,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: icon,
                ),
              Text(
                text,
                style: AppFont.BOLD_PURPLE_7a1dff_16.copyWith(
                  fontFamily: AppFont.font_family_display,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }

  static Widget roundedRect(
      {required Widget child,
      Color? backgroundColor,
      CallBackHandler? callback,
      double? radius}) {
    return GestureDetector(
        onTap: callback,
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 13),
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: backgroundColor == null ? Colors.white : backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 5.0)),
            ),
            child: child));
  }

  static Widget outlineButton(
      {required String text, TextStyle? style, CallBackHandler? callback}) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.red_c50000,
              width: 1,
              style: BorderStyle.solid,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.center,
          ),
        ));
  }

  static Widget outlinePurpleButton(
      {required String text, TextStyle? style, CallBackHandler? callback}) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xff6001d2),
              width: 1,
              style: BorderStyle.solid,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.center,
          ),
        ));
  }

  static Widget outline(String text,
      {Color? color, CallBackHandler? callback}) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              color: color == null ? AppColor.red_c50000 : color,
              width: 1,
              style: BorderStyle.solid,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Text(
            text,
            style: AppFont.BOLD_RED_C50000_15
                .copyWith(fontFamily: AppFont.font_family_display),
            textAlign: TextAlign.center,
          ),
        ));
  }

  static Widget text({required String title, CallBackHandler? callback}) {
    return GestureDetector(
        onTap: () {
          if (callback != null) {
            callback();
          }
        },
        child: Text(
          title,
          style: AppFont.BOLD_PURPLE_6001d2_15,
        ));
  }
}
