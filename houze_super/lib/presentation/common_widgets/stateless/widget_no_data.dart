import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/utils/index.dart';

class WidgetNoData extends StatelessWidget {
  final String iconName;
  final String content;
  const WidgetNoData({
    this.iconName,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil.screenHeight,
      padding: const EdgeInsets.only(top: 150),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              LocalizationsUtil.of(context)
                  .translate("${content ?? 'there_is_no_information'}"),
              textAlign: TextAlign.center,
              style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
            ),
          )
        ],
      ),
    );
  }
}
