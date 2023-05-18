part of 'statistics_by_year_bloc.dart';

abstract class StatisticsByYearEvent extends Equatable {
  const StatisticsByYearEvent();

  @override
  List<Object> get props => [];
}

class StatisticsByYearPicked extends StatisticsByYearEvent {
  final int year;
  final TypeDistanceDate typeDistanceDate;
  const StatisticsByYearPicked(
    this.year,
    this.typeDistanceDate,
  );
  @override
  List<Object> get props => [
        year,
        typeDistanceDate,
      ];
}

