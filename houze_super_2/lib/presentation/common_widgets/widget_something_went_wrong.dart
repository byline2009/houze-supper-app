import 'package:flutter/material.dart';
import 'package:houze_super/app/my_app.dart';

import 'package:houze_super/utils/index.dart';

class SomethingWentWrong extends StatelessWidget {
  final bool isNoData;

  const SomethingWentWrong([this.isNoData = false]);

  @override
  Widget build(BuildContext context) {
    final String errorText = isNoData
        ? 'there_is_no_information'
        : 'there_is_an_issue_please_try_again_later_0';

    return Align(
      alignment: Alignment(0, -1 / 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(LocalizationsUtil.of(context).translate(errorText),
              style: AppFonts.regular15.copyWith(color: Color(0xff808080))),
          const SizedBox(height: 30),
          if (isNoData == false) TryAgainButton()
        ],
      ),
    );
  }
}

class TryAgainButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: AppFonts.bold16,
      ),
      onPressed: () => MyApp.restartApp(context),
      child: SizedBox(
        height: 44,
        child: Text(
          LocalizationsUtil.of(context).translate('try_again'),
          style: AppFonts.bold16.copyWith(color: Colors.black54),
        ),
      ),
    );
  }
}
