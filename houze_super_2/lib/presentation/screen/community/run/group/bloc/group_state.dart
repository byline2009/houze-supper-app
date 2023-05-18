import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/model/achievement_user_model.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import '../model/index.dart';

abstract class GroupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GroupInitial extends GroupState {
  @override
  String toString() => 'GroupInitial';

  @override
  List<Object> get props => [];
}

class GroupLoading extends GroupState {
  @override
  String toString() => 'GroupLoading';
  @override
  List<Object> get props => [];
}

// CreateNewGroupEvent
class CreateNewGroupSuccessful extends GroupState {
  final GroupModel result;

  CreateNewGroupSuccessful({required this.result});

  @override
  List<Object> get props => [result];
  @override
  String toString() =>
      'CreateNewGroupSuccessful \n{ result: ${result.toJson()} }';
}

class CreateNewGroupFailure extends GroupState {
  final String error;

  CreateNewGroupFailure({required this.error});

  @override
  List<Object> get props => [error];
  @override
  String toString() => 'CreateNewGroupFailure { error: $error }';
}

class LoadEventRequestGroupSuccessful extends GroupState {
  final List<RequestModel> result;

  LoadEventRequestGroupSuccessful({required this.result});

  @override
  List<Object> get props => [result];
  @override
  String toString() =>
      'LoadEventRequestGroupSuccessful \n{ result: ${result.map((e) => e.toJson()).toList()} }';
}

class LoadEventRequestGroupFailure extends GroupState {
  final String error;

  LoadEventRequestGroupFailure({required this.error});

  @override
  List<Object> get props => [error];
  @override
  String toString() => 'LoadEventRequestGroupFailure { error: $error }';
}

// LoadEventGetAllAchievement
class LoadEventGetAllAchievementSuccessful extends GroupState {
  final List<AchievementUserModel> result;

  LoadEventGetAllAchievementSuccessful({
    required this.result,
  });

  @override
  List<Object> get props => [result];
  @override
  String toString() =>
      'LoadEventGetAllAchievementSuccessful \n{ result: ${result.toList()} }';
}

class LoadEventGetAllAchievementFailure extends GroupState {
  final String error;

  LoadEventGetAllAchievementFailure({required this.error});

  @override
  List<Object> get props => [error];
  @override
  String toString() => 'LoadEventGetAllAchievementFailure { error: $error }';
}

class EventLoadGroupDetailUpdateSuccessful extends GroupState {
  EventLoadGroupDetailUpdateSuccessful();
  @override
  List<Object> get props => [];
}

class StateLoadEventDetailSuccessful extends GroupState {
  final EventModel? eventModel;
  final List<GroupModel>? groups;
  StateLoadEventDetailSuccessful(
      {required this.eventModel, required this.groups});

  @override
  List<Object> get props => [eventModel ?? '', groups ?? ''];
  @override
  String toString() => super.toString();
}

class StateLoadEventDetailFailure extends GroupState {
  final String error;

  StateLoadEventDetailFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'StateLoadEventDetailFailure { error: $error }';
}
