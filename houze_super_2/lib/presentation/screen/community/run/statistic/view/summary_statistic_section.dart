import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/run/blocs/run_bloc.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/widget/summary_statistic_section_in_progress.dart';

import '../../blocs/run_state.dart';
import '../index.dart';

class SummaryStatisticSection extends StatelessWidget {
  const SummaryStatisticSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocBuilder<RunBloc, RunState>(
        buildWhen: ((previous, current) {
          return previous.distanceDate != current.distanceDate ||
              previous.overview != current.overview;
        }),
        builder: (context, state) {
          if (state.hasError) {
            return SomethingWentWrong();
          }
          if (state.hasData &&
              state.overview != null &&
              state.distanceDate != null) {
            return Column(
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
                            state.overview!,
                            context,
                          );
                        }),
                        const SizedBox(height: 21),
                        DistanceAndTimeStatistic(
                          distance: (state.overview!.distance).toDouble(),
                          accumulationTime:
                              (state.overview!.accumulationTime).toDouble(),
                        ),
                      ],
                    ),
                  ),
                ),
                //Số ngày chạy liên tục
                if (checkNumberOfContinuousRunningDays(state.overview!)) ...[
                  NumberOfContinuousRunningDays(
                    day: (state.overview!.consecutiveDays).toInt(),
                  )
                ],

                if (checkDisplayChart(
                    state.distanceDate!, state.overview!)) ...[
                  DisplayChartByWeek(datasource: state.distanceDate!.chart!)
                ],
              ],
            );
          }
          return StatisticInProgress();
        },
      ),
    );
  }

  bool checkDisplayChart(DistanceDateModel distanceDate,
          StatisticOverviewModel overviewModel) =>
      distanceDate.chart!.length > 0 && (overviewModel.distance).toInt() != 0;

  bool checkNumberOfContinuousRunningDays(
          StatisticOverviewModel overviewModel) =>
      overviewModel.consecutiveDays > 0;

  Widget viewDetailStatisticLine(
    StatisticOverviewModel overview,
    BuildContext innerContext,
  ) {
    final int daysRunInYear = overview.daysRunInYear.toInt();

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
