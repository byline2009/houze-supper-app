import 'package:equatable/equatable.dart';

abstract class GroupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventLoadGroupDetail extends GroupEvent {
  final String eventID;

  EventLoadGroupDetail({
    required this.eventID,
  });

  @override
  String toString() => 'EventLoadGroupDetail eventID: $eventID';
  @override
  List<Object> get props => [
        eventID,
      ];
}
