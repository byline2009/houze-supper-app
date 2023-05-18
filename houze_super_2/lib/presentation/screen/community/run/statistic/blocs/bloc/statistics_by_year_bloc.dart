import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:houze_super/middle/repo/statistic_repo.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/statistic_overview_model.dart';

part 'statistics_by_year_event.dart';
part 'statistics_by_year_state.dart';

enum TypeDistanceDate { days7, weeks12, months12 }

class StatisticsByYearBloc
    extends Bloc<StatisticsByYearEvent, StatisticsByYearState> {
  StatisticsByYearBloc({
    required StatisticRepository statisticRepository,
  })  : _statisticRepository = statisticRepository,
        super(
          StatisticsByYearState(status: StatisticsByYearStatus.initial),
        ) {
    on<StatisticsByYearPicked>((event, emit) async {
      try {
        final List<dynamic> rs = await Future.wait([
          getStatisticOverViewByYear(event.year),
          getDistanceLatest(
            year: event.year,
            type: event.typeDistanceDate,
          )
        ]);
        await Future.delayed(Duration(milliseconds: 100))
            .then((value) => emit(state.copyWith(
                  status: StatisticsByYearStatus.success,
                  overview: rs[0],
                  distanceDateModel: rs[1],
                )));
      } catch (e) {
        emit(state.copyWith(
          status: StatisticsByYearStatus.failure,
        ));
      }
    });
  }
  Future<StatisticOverviewModel> getStatisticOverViewByYear(int year) async {
    return await this._statisticRepository.getStatisticOverViewByYear(
          year: year,
        );
  }

  Future<DistanceDateModel> getDistanceLatest({
    required int year,
    required TypeDistanceDate type,
  }) async {
    return await this._statisticRepository.getDistanceLatest(
          year: year.toString(),
          type: type,
        );
  }

  final StatisticRepository _statisticRepository;
}
