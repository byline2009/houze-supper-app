import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FeedEvent extends Equatable {
  FeedEvent([List props = const []]) : super();
}

class FeedLoadList extends FeedEvent {
  final int page;
  final String tags;
  final String type;
  final String date;
  final int limit;

  FeedLoadList(
      {@required this.page,
      this.tags = "",
      this.type = "",
      this.date = "",
      this.limit = 1})
      : super([page]);

  @override
  String toString() =>
      'FeedLoadList { page: $page, tags: $tags, type: $type, date: $date }';

  @override
  List<Object> get props => [page, tags, type, date];
}

class FeedLoadTicketList extends FeedEvent {
  final int page;
  final int status;

  FeedLoadTicketList({
    @required this.page,
    @required this.status,
  }) : super([page]);
  @override
  List<Object> get props => [page, status];
  @override
  String toString() => 'FeedLoadTicketList { page: $page, status: $status';
}

class FeedReloadData extends FeedEvent {
  final int status;

  FeedReloadData({this.status}) : super([status]);
  @override
  List<Object> get props => [status];
  @override
  String toString() => '------> FeedReloadData  status: $status}';
}
