import 'package:flutter/material.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget(this.title);
  @override
  Widget build(BuildContext context) {
    return Text(LocalizationsUtil.of(context).translate(title),
        textAlign: TextAlign.start, style: AppFont.BOLD_BLACK_27);
  }
}
