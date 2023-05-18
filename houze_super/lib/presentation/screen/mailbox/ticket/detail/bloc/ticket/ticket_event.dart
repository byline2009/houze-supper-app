import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TicketEvent extends Equatable {
  TicketEvent([List props = const []]) : super();
}

class EventGetTicketByID extends TicketEvent {
  final String id;

  EventGetTicketByID({@required this.id}) : super();

  @override
  String toString() => 'EventGetTicketByID { id: $id }';

  @override
  List<Object> get props => [id];
}
