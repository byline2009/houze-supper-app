import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget(
    this.title,
  );
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      LocalizationsUtil.of(context).translate(
        title,
      ),
      textAlign: TextAlign.start,
      style: AppFonts.bold27,
    );
  }
}
