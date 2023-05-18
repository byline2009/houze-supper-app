import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:meta/meta.dart';

abstract class TicketState extends Equatable {
  TicketState([List props = const []]) : super();
}

class TicketInitial extends TicketState {
  @override
  String toString() => 'TicketInitial';
  @override
  List<Object> get props => [];
}

class TicketLoading extends TicketState {
  @override
  String toString() => 'TicketLoading';
  @override
  List<Object> get props => [];
}

class GetTicketByIDSuccessfull extends TicketState {
  final TicketDetailModel result;
  GetTicketByIDSuccessfull({this.result});
  @override
  String toString() => 'GetTicketByIDSuccessfull';
  @override
  List<Object> get props => [result];
}

class TicketFailure extends TicketState {
  final dynamic error;

  TicketFailure({@required this.error});
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'TicketFailure { error: $error }';
}
