import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class AgentEvent extends Equatable {
  AgentEvent([List props = const []]) : super();
}

class AgentResellLoadList extends AgentEvent {
  final int page;
  AgentResellLoadList({this.page}) : super([]);

  @override
  String toString() => 'AgentResellLoadList {}';

  @override
  List<Object> get props => [page];
}

class AgentResellLoadDetail extends AgentEvent {
  final String id;

  AgentResellLoadDetail({@required this.id}) : super([id]);
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'AgentResellLoadDetail {}';
}

class AgentResellUpdate extends AgentEvent {
  final dynamic params;
  AgentResellUpdate({this.params}) : super([]);
  @override
  List<Object> get props => [params];
  @override
  String toString() => 'AgentResellUpdate {}';
}
