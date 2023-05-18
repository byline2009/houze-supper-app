import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';

abstract class ChallengeState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChallengeInitial extends ChallengeState {
  @override
  String toString() => 'ChallengeInitial';
}

class StateLoadChallengeListLoading extends ChallengeState {
  @override
  String toString() => 'StateLoadChallengeListLoading';
}

class StateLoadChallengeListSuccessful extends ChallengeState {
  final List<EventModel>? result;

  StateLoadChallengeListSuccessful({
    required this.result,
  });

  @override
  String toString() => 'StateLoadChallengeListSuccessful ${result?.toList()}';
  @override
  List<Object> get props => [
        result ?? '',
      ];
}

class StateLoadChallengeListFailure extends ChallengeState {
  final String error;

  StateLoadChallengeListFailure({
    required this.error,
  });

  @override
  String toString() => 'StateLoadChallengeListFailure { error: $error }';

  @override
  List<Object> get props => [
        error,
      ];
}
