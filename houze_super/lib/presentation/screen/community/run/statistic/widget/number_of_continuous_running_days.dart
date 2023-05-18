import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';

class NumberOfContinuousRunningDays extends StatelessWidget {
  final int day;
  const NumberOfContinuousRunningDays({@required this.day});

  @override
  Widget build(BuildContext context) {
    final fullString = LocalizationsUtil.of(context)
            .translate('k_great_you_have_series') +
        ' ${day.toString()} ' +
        LocalizationsUtil.of(context).translate(
            'k_days_of_continuous_running_keep_up_the_good_work!'); //'Tuyệt vời! Bạn đang có chuỗi ${day.toString()} ngày chạy liên tục. Tiếp tục duy trì nhé!';
    return SizedBox(
      height: 62,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(AppVectors.icFire),
          SizedBox(width: 5),
          Expanded(
            child: WidgetRichText(
              myString: fullString,
              wordToStyle: day.toString() +
                  ' ' +
                  LocalizationsUtil.of(context).translate('k_day'),
              style: AppFonts.bold.copyWith(
                fontSize: 13,
                color: Color(
                  0xffd68100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
