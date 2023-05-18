import 'package:flutter/material.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

import 'index.dart';

class HeadingItem implements ListItem {
  final String heading;
  const HeadingItem(this.heading);

  @override
  Widget buildItem(BuildContext context) {
    return Text(
      // heading,
      LocalizationsUtil.of(context).translate(heading),
      style: AppFont.BOLD_BLACK_15,
    );
  }
}
