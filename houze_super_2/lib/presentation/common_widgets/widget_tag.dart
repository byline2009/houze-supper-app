import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/utils/index.dart';

class WidgetTag extends StatefulWidget {
  final String text;
  final bool? isDisable;

  WidgetTag({required this.text, this.isDisable});

  WidgetTagState createState() => WidgetTagState();
}

class WidgetTagState extends State<WidgetTag> {
  @override
  Widget build(BuildContext context) {
    return widget.isDisable == true
        ? Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: AppColor.gray_f5f5f5,
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child: Center(
                child: Text(
                    LocalizationsUtil.of(context).translate(widget.text),
                    style: AppFont.MEDIUM_GRAY_D0D0D0_16)),
          )
        : Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(top: 10),
            decoration:
                BaseWidget.decorationBorderFull, //ThemeConstant.borderFull,
            child: Center(
              child: Text(
                  LocalizationsUtil.of(context).translate(
                    widget.text,
                  ),
                  style: AppFonts.medium16),
            ),
          );
  }
}
