import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/run/blocs/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';
import 'package:houze_super/utils/constants/app_constants.dart';
import 'package:houze_super/utils/constants/app_fonts.dart';
import 'package:houze_super/utils/localizations_util.dart';
import '../../../../../app_router.dart';
import '../index.dart';

class SummaryStatisticSection extends StatelessWidget {
  final StatisticOverviewModel overview;
  final DistanceDateModel distanceDate;
  const SummaryStatisticSection({
    @required this.overview,
    @required this.distanceDate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<RunLoadDataBloc>().statisticChartBloc,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BaseWidget.containerRounder(
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Builder(builder: (
                      context,
                    ) {
                      return viewDetailStatisticLine(
                        overview,
                        context,
                      );
                    }),
                    const SizedBox(height: 21),
                    DistanceAndTimeStatistic(
                      distance: (overview.distance).toDouble(),
                      accumulationTime: (overview.accumulationTime).toDouble(),
                    ),
                  ],
                ),
              ),
            ),
            //Số ngày chạy liên tục
            if (checkNumberOfContinuousRunningDays) ...[
              NumberOfContinuousRunningDays(
                  day: (overview.consecutiveDays).toInt() ?? 0)
            ],

            if (checkDisplayChart) ...[
              DisplayChartByWeek(datasource: distanceDate.chart)
            ],
          ],
        ),
      ),
    );
  }

  bool get checkDisplayChart =>
      distanceDate.chart != null &&
      distanceDate.chart.length > 0 &&
      (overview.distance).toInt() != 0;

  bool get checkNumberOfContinuousRunningDays =>
      overview.consecutiveDays != null &&
      (overview.consecutiveDays).toInt() != 0;

  Widget viewDetailStatisticLine(
    StatisticOverviewModel overview,
    BuildContext innerContext,
  ) {
    final int daysRunInYear = overview != null && overview.daysRunInYear != null
        ? overview.daysRunInYear.toInt()
        : 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
            LocalizationsUtil.of(innerContext).translate('year') +
                ' ' +
                DateTime.now().year.toString() +
                ': ' +
                LocalizationsUtil.of(innerContext).translate('k_ran') +
                ' ',
            style: AppFonts.semibold13.copyWith(
              color: Color(0xff838383),
            )),
        Text(
            '${daysRunInYear.toString()} ' +
                LocalizationsUtil.of(innerContext).translate('k_day'),
            style: AppFonts.semibold13.copyWith(color: Color(0xff00aa7d))),
        Expanded(
            child: GestureDetector(
          onTap: () {
            AppRouter.pushNoParams(
              innerContext,
              AppRouter.COMMUNITY_RUN_DASHBOARD_PAGE,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                LocalizationsUtil.of(innerContext)
                    .translate('k_view_dashboard'),
                style: AppFonts.semibold13.copyWith(
                  color: Color(
                    0xff6001d2,
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
              SvgPicture.asset(
                AppVectors.ic_arrow_right,
              ),
            ],
          ),
        ))
      ],
    );
  }
}
