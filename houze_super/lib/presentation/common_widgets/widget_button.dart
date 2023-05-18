import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler();

class WidgetButton {
  static Widget backCircleButton(BuildContext context,
      {CallBackHandler callback}) {
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
    return FlatButton(
      padding: const EdgeInsets.all(0),
      color: Colors.white,
      onPressed: () {
        callback();
      },
      shape: CircleBorder(),
      child: SizedBox(child: icon, width: 30, height: 30),
    );
  }

  static Widget pinkButton(
      {String text, TextStyle style, CallBackHandler callback}) {
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
      {Color color, Widget icon, CallBackHandler callback}) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: color == null ? Color(0xfff2e8ff) : color,
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
                style:
                    AppFonts.bold16.copyWith(color: Color(0xff7A1DFF)).copyWith(
                          fontFamily: AppFonts.font_family_display,
                        ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }

  static Widget roundedRect(
      {@required Widget child,
      Color backgroundColor,
      CallBackHandler callback,
      double radius}) {
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
      {String text, TextStyle style, CallBackHandler callback}) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffc50000),
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
      {String text, TextStyle style, CallBackHandler callback}) {
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

  static Widget outline(String text, {Color color, CallBackHandler callback}) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            border: Border.all(
              color: color == null ? Color(0xffc50000) : color,
              width: 1,
              style: BorderStyle.solid,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: Text(
            text,
            style: AppFonts.bold15
                .copyWith(
                    color: Color(
                        0xffC50000)) // bold15.copyWith(color: Color(0xffC50000))
                .copyWith(fontFamily: AppFonts.font_family_display),
            textAlign: TextAlign.center,
          ),
        ));
  }

  static Widget text({@required String title, CallBackHandler callback}) {
    return GestureDetector(
        onTap: () {
          if (callback != null) {
            callback();
          }
        },
        child: Text(
          title,
          style: AppFonts.bold15
              .copyWith(color: Color(0xff6001d2)), //BOLD_purple6001d2_15,
        ));
  }
}
