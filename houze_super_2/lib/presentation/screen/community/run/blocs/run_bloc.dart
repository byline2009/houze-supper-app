import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/achievement_repo.dart';
import 'package:houze_super/middle/repo/statistic_repo.dart';
import 'package:houze_super/middle/repo/challenge_repository.dart';

import '../statistic/blocs/bloc/statistics_by_year_bloc.dart';
import 'index.dart';

class RunBloc extends Bloc<RunEvent, RunState> {
  final StatisticRepository statisticRepository;
  final ChallengeRepository challengeRepository;
  final AchievementRepository achievementRepository;

  RunBloc({
    required this.statisticRepository,
    required this.challengeRepository,
    required this.achievementRepository,
  }) : super(
          RunState.initial(),
        ) {
    on<RunEvent>((event, emit) async {
      emit(RunState.loading());
      final int currentYear = DateTime.now().year;

      try {
        final List<dynamic> results = await Future.wait([
          statisticRepository.getStatisticOverViewByYear(year: currentYear),
          statisticRepository.getDistanceLatest(
            type: TypeDistanceDate.days7,
            year: currentYear.toString(),
          ),
          achievementRepository.getAllAchievementUser(page: 0),
          challengeRepository.getAllEvent(
              page: 0, buildingID: event.buildingID),
        ]);

        await Future.delayed(Duration(milliseconds: 100), () {
          emit(RunState.success(
            overview: results[0],
            distanceDate: results[1],
            achivements: results[2],
            events: results[3],
          ));
        });
      } catch (e) {
        emit(RunState.error(e.toString()));
      }
    });
  }
}
