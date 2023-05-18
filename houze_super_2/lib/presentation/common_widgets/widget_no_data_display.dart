import 'package:flutter/material.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

class NoDataBottomLine extends StatelessWidget {
  final BuildContext? parentContext;
  const NoDataBottomLine({this.parentContext});
  @override
  Widget build(BuildContext context) {
    return Text(
      LocalizationsUtil.of(parentContext).translate('no_more_information'),
      style: AppFonts.regular14,
    );
  }
}
