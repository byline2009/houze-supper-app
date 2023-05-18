import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class WidgetCreateDay extends StatelessWidget {
  final String? title;
  final String? createdDay;
  const WidgetCreateDay({this.title, this.createdDay});

  @override
  Widget build(BuildContext context) {
    String _title = title ?? 'send_date';
    return Container(
        color: Color(0xfff5f7f8),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              LocalizationsUtil.of(context).translate(_title),
              style: TextStyle(
                  color: Color(0xff333333),
                  fontSize: 14,
                  fontFamily: AppFont.font_family_display,
                  fontWeight: FontWeight.w500),
            ),
            Text(DateUtil.format("dd/MM/yyyy - HH:mm", createdDay!),
                style: TextStyle(
                  color: AppColor.gray_808080,
                  fontSize: 14,
                  fontFamily: AppFont.font_family_display,
                  fontWeight: FontWeight.w500,
                )),
          ],
        ));
  }
}
