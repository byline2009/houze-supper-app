import 'package:equatable/equatable.dart';

abstract class TicketEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventGetTicketByID extends TicketEvent {
  final String id;

  EventGetTicketByID({required this.id}) : super();

  @override
  String toString() => 'EventGetTicketByID { id: $id }';

  @override
  List<Object> get props => [id];
}
