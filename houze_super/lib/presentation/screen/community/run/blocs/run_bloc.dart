import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/screen/community/index.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/bloc/achievement_bloc.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/blocs/dashboard/index.dart';

import 'index.dart';

class RunLoadDataBloc extends Bloc<RunLoadDataEvent, RunLoadDataState> {
  final DashboardBloc dashboardBloc;
  final StatisticChartBloc statisticChartBloc;
  final ChallengeBloc challengeBloc;
  final AchievementBloc achievementBloc;

  RunLoadDataBloc({
    @required this.dashboardBloc,
    @required this.statisticChartBloc,
    @required this.challengeBloc,
    @required this.achievementBloc,
  }) : super(
          RunLoadDataState.initial(),
        );

  @override
  Stream<RunLoadDataState> mapEventToState(RunLoadDataEvent event) async* {
    yield RunLoadDataState.loading();
    final int currentYear = DateTime.now().year;

    try {
      final results = await Future.wait([
        dashboardBloc.getStatisticOverViewByYear(currentYear),
        statisticChartBloc.getDistanceLatest(
          year: currentYear,
          type: TypeDistanceDate.days7,
        ),
        achievementBloc.getAllAchievementUser(),
        challengeBloc.getAllEventByBuildingID(
          event.buildingID,
        )
      ]);

      yield RunLoadDataState.success(
        events: results[3],
        achivements: results[2],
        distanceDate: results[1],
        overview: results[0],
      );
    } catch (e) {
      yield RunLoadDataState.error(e.toString());
    }
  }
}
