import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';
import 'package:houze_super/presentation/screen/community/run/group/model/request_model.dart';

abstract class MemberState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MemberInitial extends MemberState {
  @override
  String toString() => 'MemberInitial';

  @override
  List<Object> get props => [];
}

class MemberLoading extends MemberState {
  @override
  String toString() => 'MemberLoading';
  @override
  List<Object> get props => [];
}

class GroupLoadMembersRequestJoinTeamSuccessful extends MemberState {
  final List<RequestModel>? result;

  GroupLoadMembersRequestJoinTeamSuccessful({
    required this.result,
  });

  @override
  List<Object> get props => [
        result ?? '',
      ];
  @override
  String toString() =>
      'LoadEventRequestMemberSuccessful \n{ result: ${result?.map((e) => e.toJson()).toList()} }';
}

class GroupLoadMembersRequestJoinTeamFailure extends MemberState {
  final String error;

  GroupLoadMembersRequestJoinTeamFailure({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
  @override
  String toString() => 'LoadEventRequestMemberFailure { error: $error }';
}
