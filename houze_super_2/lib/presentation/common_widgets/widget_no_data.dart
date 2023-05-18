import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:houze_super/utils/index.dart';

class WidgetNoData extends StatelessWidget {
  final String? iconName;
  final String? content;
  const WidgetNoData({
    this.iconName,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVectors.icFacility),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            LocalizationsUtil.of(context)
                .translate("${content ?? 'there_is_no_information'}"),
            style: AppFonts.regular15.copyWith(
              color: Color(0xff808080),
            ),
          ),
        ],
      ),
    );
  }
}
