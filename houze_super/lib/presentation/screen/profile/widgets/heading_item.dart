import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

import 'index.dart';

class HeadingItem implements ListItem {
  final String heading;
  const HeadingItem(this.heading);

  @override
  Widget buildItem(BuildContext context) {
    return Text(
      LocalizationsUtil.of(context).translate(heading),
      style: AppFonts.bold15,
    );
  }
}
