import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/blocs/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/widget/chart_by_week.dart';
import 'package:houze_super/utils/index.dart';

import 'bottom_duration_week.dart';

class TabCurrentWeekChart extends StatelessWidget {
  final DistanceDateModel distanceDate;
  const TabCurrentWeekChart({
    @required this.distanceDate,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationsUtil.of(context).translate('k_average_per_day'),
          style: AppFonts.semibold13.copyWith(
            color: Color(0xff838383),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: AppFonts.bold18,
                children: <TextSpan>[
                  TextSpan(
                    text: distanceDate.averageDistanceKm().toString(),
                  ),
                  const TextSpan(text: ' km')
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xffc4c4c4),
              ),
              child: SizedBox(
                width: 1,
                height: 24,
              ),
            ),
            const SizedBox(
              width: 40,
            ),
            RichText(
              text: TextSpan(
                style: AppFonts.bold18,
                children: <TextSpan>[
                  TextSpan(text: distanceDate.averageHour()),
                  TextSpan(
                      text: ' ' +
                          LocalizationsUtil.of(context).translate('k_hour'))
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        DisplayChartByWeek(
          datasource: distanceDate.chart,
        ),
        BottomTimer(
          type: TypeDistanceDate.days7,
          charts: distanceDate.chart,
        )
      ],
    );
   
  }
}
