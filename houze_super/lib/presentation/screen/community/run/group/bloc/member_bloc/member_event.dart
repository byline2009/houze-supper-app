import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MemberEvent extends Equatable {
  MemberEvent([List props = const []]) : super();
}

class GroupLoadMembersRequestJoinTeam extends MemberEvent {
  final String groupID;

  GroupLoadMembersRequestJoinTeam({
    @required this.groupID,
  });
  @override
  List<Object> get props => [
        groupID,
      ];
  @override
  String toString() =>
      'GroupLoadMembersRequestJoinTeam: danh sách yêu cầu tham gia nhóm từ người lạ';
}

class EventLoadMemberDetail extends MemberEvent {
  final String eventID;

  EventLoadMemberDetail({
    @required this.eventID,
  }) : super([]);

  @override
  String toString() => 'EventLoadMemberDetail eventID: $eventID';
  @override
  List<Object> get props => [
        eventID,
      ];
}
