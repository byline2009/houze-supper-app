import 'package:flutter/material.dart';

/*
 * Chưa toàn bộ style của màn hình login
 */
class StyleForm {
  static BoxDecoration borderRegularShadow(String value) => BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: Color(0xffd2d4d6),
            offset: Offset(0, 2.0),
            blurRadius: 0.5,
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
//      border: Border.all(
//          color: value != ""
//              ? Colors.black
//              : Color(0xffebeef2),
//          width: 0.7,
//          style: BorderStyle.solid)
      );
}
