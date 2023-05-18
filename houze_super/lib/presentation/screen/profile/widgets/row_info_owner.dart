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
            Text(LocalizationsUtil.of(context).translate(title),
                style: AppFonts.medium14.copyWith(color: Color(0xff838383))),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: AppFonts.regular15.copyWith(letterSpacing: 0.24),
              maxLines: 5,
            ),
            const SizedBox(height: 13),
            title == 'Hotline:'
                ? const SizedBox.shrink()
                : Container(
                    height: 2,
                    width: double.infinity,
                    color: Color(0xfff5f5f5),
                  ),
            const SizedBox(height: 14),
          ],
        ),
      );
}
