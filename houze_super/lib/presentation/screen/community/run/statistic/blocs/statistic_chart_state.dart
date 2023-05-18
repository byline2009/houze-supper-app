// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';
// import 'package:houze_super/presentation/screen/community/run/statistic/model/statistic_overview_model.dart';

// abstract class StatisticChartState extends Equatable {
//   @override
//   List<Object> get props => [];

//   StatisticChartState([List props = const []]) : super();
// }

// class StatisticInitial extends StatisticChartState {}

// class StatisticsGetOverviewByTypeSuccess extends StatisticChartState {
//   final StatisticOverviewModel overviewModel;
//   final DistanceDateModel distanceDateModel;
//   StatisticsGetOverviewByTypeSuccess({
//     @required this.distanceDateModel,
//     @required this.overviewModel,
//   });

//   @override
//   List<Object> get props => [
//         overviewModel,
//         distanceDateModel,
//       ];

//   @override
//   String toString() =>
//       'StatisticsGetOverviewByTypeSuccess { Statistic: $overviewModel }';
// }

// class StatisticsGetOverviewByTypeFailure extends StatisticChartState {
//   final dynamic error;
//   StatisticsGetOverviewByTypeFailure({
//     @required this.error,
//   });

//   @override
//   List<Object> get props => [
//         error,
//       ];
// }

// class StatisticsGetOverviewFailure extends StatisticChartState {
//   final dynamic error;
//   StatisticsGetOverviewFailure({
//     @required this.error,
//   });

//   @override
//   List<Object> get props => [
//         error,
//       ];
// }

import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/statistic_overview_model.dart';

// class StatisticOverview extends Equatable {
//   final StatisticOverviewModel overview;
//   final DistanceDateModel distanceDate;
//   const StatisticOverview({
//     this.overview,
//     this.distanceDate,
//   });
//   @override
//   List<Object> get props => [
//         overview,
//         distanceDate,
//       ];
// }

class StatisticChartState extends Equatable {
  final bool isLoading;
  final StatisticOverviewModel statisticOverview;
  final DistanceDateModel distanceDate;

  final String error;

  const StatisticChartState({
    this.isLoading,
    this.statisticOverview,
    this.distanceDate,
    this.error,
  });
  @override
  List<Object> get props => [
        isLoading,
        statisticOverview,
        distanceDate,
        error,
      ];

  factory StatisticChartState.initial() {
    return StatisticChartState(
      statisticOverview: null,
      distanceDate: null,
      isLoading: false,
      error: null,
    );
  }

  factory StatisticChartState.loading() {
    return StatisticChartState(
      statisticOverview: null,
      distanceDate: null,
      isLoading: true,
      error: null,
    );
  }

  factory StatisticChartState.success({
    StatisticOverviewModel statisticOverview,
    DistanceDateModel distanceDate,
  }) {
    return StatisticChartState(
      statisticOverview: statisticOverview,
      distanceDate: distanceDate,
      isLoading: false,
      error: null,
    );
  }

  factory StatisticChartState.error(String code) {
    return StatisticChartState(
      statisticOverview: null,
      distanceDate: null,
      isLoading: false,
      error: code,
    );
  }

  bool get hasLoading =>
      isLoading &&
      error == null &&
      statisticOverview == null &&
      distanceDate == null;

  bool get hasData =>
      !isLoading &&
      error == null &&
      statisticOverview != null &&
      distanceDate != null;

  bool get isInitial =>
      !isLoading &&
      error == null &&
      statisticOverview == null &&
      distanceDate == null;

  bool get hasError => !isLoading && error != null;
  @override
  String toString() {
    if (isInitial) {
      return 'StatisticChartState initial';
    }
    if (hasData) {
      return 'StatisticChartState has data }';
    }
    if (hasLoading) {
      return 'StatisticChartState is loading';
    }

    if (hasError) {
      return 'StatisticChartState has error $error';
    }

    return '';
  }
}
