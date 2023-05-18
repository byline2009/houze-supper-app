import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';

import '../blocs/bloc/statistics_by_year_bloc.dart';

class Tab12WeeksChart extends StatelessWidget {
  final DistanceDateModel distanceDate;
  const Tab12WeeksChart({
    required this.distanceDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationsUtil.of(context)
              .translate('k_average_per_week'), //'Trung bình mỗi tuần',
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
                    text: distanceDate.averageDistanceKm(),
                  ),
                  TextSpan(text: ' km'),
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
                    text:
                        ' ' + LocalizationsUtil.of(context).translate('k_hour'),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        DisplayChartBy12Weeks(datasource: distanceDate.chart!),
        if (distanceDate.chart!.length > 0) ...[
          BottomTimer(
            type: TypeDistanceDate.weeks12,
            charts: distanceDate.chart!,
          )
        ]
      ],
    );
  }
}
