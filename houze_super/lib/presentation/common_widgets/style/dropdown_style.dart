import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';

class DropdownStyle {
  static Widget dropdownLineStyle1(
    TextEditingController controller, {
    bool centerText,
    String defaultHintText,
  }) {
    return Container(
        height: 33,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color:
                      controller.text == "" ? Color(0xffbfbfbf) : Colors.black,
                  width: 1,
                  style: BorderStyle.solid)),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: TextField(
                  keyboardAppearance: Brightness.light,
                  controller: controller,
                  textAlign:
                      centerText == true ? TextAlign.center : TextAlign.left,
                  enabled: false,
                  style: AppFonts.medium14.copyWith(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: defaultHintText,
                      hintStyle:
                          AppFonts.medium14.copyWith(color: Color(0xffbfbfbf)),
                      contentPadding: const EdgeInsets.only(bottom: 6)),
                ),
              ),
              Icon(
                Icons.expand_more,
                color: controller.text != "" ? Colors.black : Colors.black,
                size: 25.0,
              )
            ]));
  }

  static Widget dropdownStyle1(
    TextEditingController controller, {
    bool centerText,
    String defaultHintText,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: Colors.white,
        border: Border.all(
          color: controller.text != "" ? Colors.black : Color(0xffd0d0d0),
          width: 0.7,
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              keyboardAppearance: Brightness.light,
              controller: controller,
              textAlign: centerText == true ? TextAlign.center : TextAlign.left,
              enabled: false,
              style: AppFonts.regular14,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: defaultHintText,
                  hintStyle: AppFonts.regular
                      .copyWith(color: Color(0xff808080)) //Text olor
                  ),
            ),
          ),
          Icon(
            Icons.expand_more,
            color: controller.text != "" ? Colors.black : Colors.black,
            size: 25.0,
          ),
        ],
      ),
    );
  }
}
