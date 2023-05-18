import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:houze_super/middle/model/agent_model.dart';

@immutable
abstract class AgentState extends Equatable {
  AgentState([List props = const []]) : super();
}

class AgentInitial extends AgentState {
  @override
  String toString() => 'AgentInitial';

  @override
  List<Object> get props => [];
}

class AgentResellListSuccessful extends AgentState {
  final dynamic results;

  AgentResellListSuccessful({@required this.results});
  @override
  List<Object> get props => [results];
  @override
  String toString() => 'AgentResellListSuccessful { results: $results }';
}

class AgentResellListFailure extends AgentState {
  final dynamic error;

  AgentResellListFailure({@required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'AgentResellListFailure { error: $error }';
}

class AgentResellDetailSuccessful extends AgentState {
  final SellModel sell;

  AgentResellDetailSuccessful({@required this.sell});
  @override
  List<Object> get props => [sell];
  @override
  String toString() => 'AgentResellDetailSuccessful { sell: $sell }';
}

class AgentResellDetailFailure extends AgentState {
  final dynamic error;

  AgentResellDetailFailure({@required this.error}) : super([error]);
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'AgentResellDetailFailure { error: $error }';
}

class AgentResellLoading extends AgentState {
  @override
  String toString() => 'AgentResellLoading';
  @override
  List<Object> get props => [];
}

class AgentResellUpdateSuccessful extends AgentState {
  final SellModel sell;
  AgentResellUpdateSuccessful({@required this.sell});
  @override
  List<Object> get props => [sell];

  @override
  String toString() => 'AgentResellUpdateSuccessful { sell: $sell }';
}

class AgentResellUpdateFailure extends AgentState {
  final String error;

  AgentResellUpdateFailure({@required this.error}) : super([error]);
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'AgentResellUpdateFailure { error: $error }';
}
