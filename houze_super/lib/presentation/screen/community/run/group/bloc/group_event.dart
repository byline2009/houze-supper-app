import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class GroupEvent extends Equatable {
  GroupEvent([List props = const []]) : super();
}

class EventLoadGroupDetail extends GroupEvent {
  final String eventID;

  EventLoadGroupDetail({
    @required this.eventID,
  }) : super([]);

  @override
  String toString() => 'EventLoadGroupDetail eventID: $eventID';
  @override
  List<Object> get props => [
        eventID,
      ];
}
