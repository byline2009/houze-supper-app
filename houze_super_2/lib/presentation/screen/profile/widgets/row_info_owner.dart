import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

import '../index.dart';

class InfomationOwnerItem implements ListItem {
  InfomationOwnerItem(this.title, this.subtitle);
  final String title;
  final String subtitle;

  @override
  Widget buildItem(BuildContext context) => Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                // title,
                LocalizationsUtil.of(context).translate(title),
                style: AppFont.MEDIUM_GRAY_838383_14),
            SizedBox(height: 5),

            Text(
              LocalizationsUtil.of(context).translate(subtitle),
              style: AppFonts.regular15.copyWith(letterSpacing: 0.24),
              maxLines: 5,
            ),
            SizedBox(height: 13),
            // title == 'Hotline:'
         LocalizationsUtil.of(context).translate(title) == 'Hotline: '
                ? SizedBox.shrink()
                : Container(
                    height: 2,
                    width: double.infinity,
                    color: Color(0xfff5f5f5),
                  ),
            SizedBox(height: 14),
          ],
        ),
      );
}
