import 'package:houze_super/middle/api/statistic_api.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';

import '../../presentation/screen/community/run/statistic/blocs/bloc/statistics_by_year_bloc.dart';

class StatisticRepository {
  final api = StatisticApi();
  StatisticRepository();

  Future<StatisticOverviewModel> getStatisticOverViewByYear({
    required int year,
  }) async {
    return await api.getStatisticOverViewByYear(
      year: year,
    );
  }

  Future<DistanceDateModel> getDistanceLatest(
      {required TypeDistanceDate type, required String year}) async {
    final result = await api.getDistaceLastest(
      type: type,
      year: year,
    );
    return result;
  }
}
