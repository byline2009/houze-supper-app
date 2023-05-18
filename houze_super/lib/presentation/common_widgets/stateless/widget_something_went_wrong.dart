import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/app/my_app.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

class SomethingWentWrong extends StatelessWidget {
  final bool isNoData;

  const SomethingWentWrong([this.isNoData = false]);

  @override
  Widget build(BuildContext context) {
    final String errorText = isNoData
        ? 'there_is_no_information'
        : 'there_is_an_issue_please_try_again_later_0';

    return SizedBox(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil.screenHeight - 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(LocalizationsUtil.of(context).translate(errorText),
              textAlign: TextAlign.center,
              style: AppFonts.regular15.copyWith(color: Color(0xff808080))),
          SizedBox(height: 30),
          if (!isNoData) TryAgainButton()
        ],
      ),
    );
  }
}

class TryAgainButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => MyApp.restartApp(context),
      child: SizedBox(
        height: 44,
        child: Text(
          LocalizationsUtil.of(context).translate('try_again'),
        ),
      ),
    );
  }
}
