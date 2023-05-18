import 'package:equatable/equatable.dart';

abstract class MemberEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GroupLoadMembersRequestJoinTeam extends MemberEvent {
  final String groupID;

  GroupLoadMembersRequestJoinTeam({
    required this.groupID,
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
    required this.eventID,
  });

  @override
  String toString() => 'EventLoadMemberDetail eventID: $eventID';
  @override
  List<Object> get props => [
        eventID,
      ];
}
