import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/statistic_repo.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/statistic_overview_model.dart';

import 'index.dart';

class StatisticChartBloc
    extends Bloc<StatisticChartEvent, StatisticChartState> {
  final StatisticRepository repo;

  StatisticChartBloc({
    @required this.repo,
  }) : super(StatisticChartState.initial());

  @override
  Stream<StatisticChartState> mapEventToState(
      StatisticChartEvent event) async* {
    yield StatisticChartState.loading();
    try {
      final results = await Future.wait([
        getStatisticOverView(
          year: event.year,
        ),
        getDistanceLatest(
          year: event.year,
          type: event.type,
        )
      ]);
      yield StatisticChartState.success(
        statisticOverview: results[0],
        distanceDate: results[1],
      );
    } catch (error) {
      errorLog(
        'StatisticsGetOverviewByTypeFailure',
        error.toString(),
      );
      yield StatisticChartState.error(
        error.toString(),
      );
    }
  }

  Future<StatisticOverviewModel> getStatisticOverView({
    @required int year,
  }) async {
    return await this.repo.getStatisticOverViewByYear(
          year: year,
        );
  }

  Future<DistanceDateModel> getDistanceLatest({
    @required int year,
    @required TypeDistanceDate type,
  }) async {
    return await this.repo.getDistanceLatest(
          year: year.toString(),
          type: type,
        );
  }

  // Future<StatisticOverview> getStatisticOverviewCurrentYear() async {
  //   final int currentYear = DateTime.now().year;
  //   final StatisticOverviewModel overviewModel = await getStatisticOverView(
  //     year: currentYear,
  //   );
  //   final DistanceDateModel distanceDateModel = await getDistanceLatest(
  //     type: TypeDistanceDate.days7,
  //     year: currentYear,
  //   );

  //   return StatisticOverview(
  //     overview: overviewModel,
  //     distanceDate: distanceDateModel,
  //   );
  // }

  void errorLog(String functionName, String content) {
    print('[*** StatisticChartBloc] $functionName \t $content');
  }
}
