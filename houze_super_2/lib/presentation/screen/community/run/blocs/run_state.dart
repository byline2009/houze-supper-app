import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/model/achievement_user_model.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/statistic_overview_model.dart';

class RunState extends Equatable {
  final bool isLoading;
  final StatisticOverviewModel? overview;
  final DistanceDateModel? distanceDate;
  final List<AchievementUserModel>? achivements;
  final List<EventModel>? events;

  final String? error;

  const RunState({
    this.isLoading = false,
    this.overview,
    this.distanceDate,
    this.achivements,
    this.events,
    this.error,
  });
  @override
  List<Object> get props => [
        isLoading,
        overview ?? '',
        distanceDate ?? '',
        achivements ?? '',
        events ?? '',
        error ?? '',
      ];

  factory RunState.initial() {
    return RunState(
      distanceDate: null,
      overview: null,
      achivements: null,
      events: null,
      isLoading: false,
      error: null,
    );
  }

  factory RunState.loading() {
    return RunState(
      distanceDate: null,
      overview: null,
      achivements: null,
      events: null,
      isLoading: true,
      error: null,
    );
  }

  factory RunState.success({
    List<AchievementUserModel>? achivements,
    List<EventModel>? events,
    StatisticOverviewModel? overview,
    DistanceDateModel? distanceDate,
  }) {
    return RunState(
      overview: overview,
      distanceDate: distanceDate,
      achivements: achivements,
      events: events,
      isLoading: false,
      error: null,
    );
  }

  factory RunState.error(String code) {
    return RunState(
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
      return 'RunState initial';
    }
    if (hasData) {
      return 'RunState  events: ${events?.length} achivements: ${achivements?.length} ';
    }
    if (hasLoading) {
      return 'RunState is loading';
    }

    if (hasError) {
      return 'RunState has error $error';
    }

    return '';
  }
}
