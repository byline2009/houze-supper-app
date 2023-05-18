import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class TabTerms extends StatelessWidget {
  final String regulation;
  TabTerms({this.regulation});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: regulation.length > 0
          ? Text(
              regulation,
              style: AppFonts.regular14,
            )
          : Text(
              LocalizationsUtil.of(context)
                  .translate("there_is_no_information"),
              style: AppFonts.regular14),
    );
  }
}
