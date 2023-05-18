part of 'statistics_by_year_bloc.dart';

enum StatisticsByYearStatus { initial, success, failure }

class StatisticsByYearState extends Equatable {
  const StatisticsByYearState({
    this.status = StatisticsByYearStatus.initial,
    this.overview,
    this.distanceDateModel,
  });

  final StatisticsByYearStatus status;
  final StatisticOverviewModel? overview;
  final DistanceDateModel? distanceDateModel;

  @override
  List<Object> get props => [
        status,
        overview ?? '',
        distanceDateModel ?? '',
      ];

  StatisticsByYearState copyWith({
    StatisticsByYearStatus? status,
    StatisticOverviewModel? overview,
    DistanceDateModel? distanceDateModel,
  }) {
    return StatisticsByYearState(
      status: status ?? this.status,
      overview: overview ?? this.overview,
      distanceDateModel: distanceDateModel ?? this.distanceDateModel,
    );
  }
}
