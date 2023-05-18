import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/statistic_repo.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/statistic_overview_model.dart';

import 'index.dart';

class DashboardBloc extends Bloc<DashboadLoadByYearEvent, DashboardState> {
  final StatisticRepository repo;
  DashboardBloc({
    @required this.repo,
  }) : super(DashboardState.initial());

  @override
  Stream<DashboardState> mapEventToState(DashboadLoadByYearEvent event) async* {
    yield DashboardState.loading();
    try {
      final StatisticOverviewModel result = await getStatisticOverViewByYear(
        event.year,
      );

      if (result != null) {
        yield DashboardState.success(
          result,
        );
      }
    } catch (error) {
      yield DashboardState.error(error.toString());
    }
  }

  Future<StatisticOverviewModel> getStatisticOverViewByYear(int year) async {
    return await this.repo.getStatisticOverViewByYear(
          year: year,
        );
  }
}
