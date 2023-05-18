import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PollEvent extends Equatable {
  PollEvent() : super();
}

class GetPollsEvent extends PollEvent {
  final int page;
  GetPollsEvent({this.page});

  @override
  String toString() => 'PollEvent: GetPollsEvent';

  @override
  List<Object> get props => [this.page];
}

class UpdateTotalComment extends PollEvent {
  final String id;
  final int total;

  UpdateTotalComment({@required this.id, @required this.total}) : super();

  @override
  List<Object> get props => [this.id, this.total];
  @override
  String toString() => 'UpdateTotalComment { total: $total}';
}

class UpdatePollChoices extends PollEvent {
  final String id;
  final dynamic model;

  UpdatePollChoices({@required this.id, @required this.model}) : super();

  @override
  List<Object> get props => [this.id, this.model];
  @override
  String toString() =>
      'UpdatePollChoices { id: $id, model: ${json.encode(model)}}';
}
