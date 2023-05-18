import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/model/achievement_user_model.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/statistic_overview_model.dart';

class RunLoadDataState extends Equatable {
  final bool isLoading;
  final StatisticOverviewModel overview;
  final DistanceDateModel distanceDate;
  final List<AchievementUserModel> achivements;
  final List<EventModel> events;

  final String error;

  const RunLoadDataState({
    this.isLoading,
    this.overview,
    this.distanceDate,
    this.achivements,
    this.events,
    this.error,
  });
  @override
  List<Object> get props => [
        isLoading,
        overview,
        distanceDate,
        achivements,
        events,
        error,
      ];

  factory RunLoadDataState.initial() {
    return RunLoadDataState(
      distanceDate: null,
      overview: null,
      achivements: null,
      events: null,
      isLoading: false,
      error: null,
    );
  }

  factory RunLoadDataState.loading() {
    return RunLoadDataState(
      distanceDate: null,
      overview: null,
      achivements: null,
      events: null,
      isLoading: true,
      error: null,
    );
  }

  factory RunLoadDataState.success({
    List<AchievementUserModel> achivements,
    List<EventModel> events,
    StatisticOverviewModel overview,
    DistanceDateModel distanceDate,
  }) {
    return RunLoadDataState(
      overview: overview,
      distanceDate: distanceDate,
      achivements: achivements,
      events: events,
      isLoading: false,
      error: null,
    );
  }

  factory RunLoadDataState.error(String code) {
    return RunLoadDataState(
      distanceDate: null,
      achivements: null,
      overview: null,
      events: null,
      isLoading: false,
      error: code,
    );
  }

  bool get hasLoading => isLoading;

  bool get hasData =>
      !isLoading &&
      error == null &&
      distanceDate != null &&
      overview != null &&
      achivements != null &&
      events != null;

  bool get isInitial =>
      !isLoading &&
      error == null &&
      distanceDate == null &&
      overview == null &&
      achivements == null &&
      events == null;

  bool get hasError => !isLoading && error != null;
  @override
  String toString() {
    if (isInitial) {
      return 'RunLoadDataState initial';
    }
    if (hasData) {
      return 'RunLoadDataState  events: ${events.length} achivements: ${achivements.length} ';
    }
    if (hasLoading) {
      return 'RunLoadDataState is loading';
    }

    if (hasError) {
      return 'RunLoadDataState has error $error';
    }

    return '';
  }
}
