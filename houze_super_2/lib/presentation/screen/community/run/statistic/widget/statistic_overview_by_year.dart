import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/index.dart';

class StatisticOverviewByYear extends StatelessWidget {
  final int year;
  final StatisticOverviewModel model;
  const StatisticOverviewByYear({
    required this.model,
    required this.year,
  });
  @override
  Widget build(BuildContext context) {
    String day = '${model.daysRunInYear.toString()} ' +
        LocalizationsUtil.of(context).translate('k_day');

    String hasDay = model.consecutiveDays.toString() +
        ' ' +
        LocalizationsUtil.of(context).translate('k_day');

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: AppFonts.semibold13.copyWith(
                  color: Color(0xff838383),
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: LocalizationsUtil.of(context).translate('year') +
                          ' ${year.toString()}: ' +
                          LocalizationsUtil.of(context).translate('k_ran') +
                          ' '),
                  TextSpan(
                      text: '${model.daysRunInYear.toString()} ' +
                          LocalizationsUtil.of(context).translate('k_day'),
                      style: AppFonts.semibold13
                          .copyWith(color: Color(0xff00aa7d))),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: AppFonts.semibold13.copyWith(
                  color: Color(0xff838383),
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: LocalizationsUtil.of(context)
                              .translate('k_there_are_series') +
                          ' '),
                  TextSpan(
                      style: TextStyle(color: Color(0xffd68100)),
                      text: model.consecutiveDays.toString() +
                          ' ' +
                          LocalizationsUtil.of(context).translate('k_day')),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        DistanceAndTimeStatistic(
          distance: (model.distance).toDouble(),
          accumulationTime: (model.accumulationTime).toDouble(),
        ),
      ],
    );
  }
}
