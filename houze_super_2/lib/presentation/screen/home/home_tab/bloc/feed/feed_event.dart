import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedLoadList extends FeedEvent {
  final int page;
  final String tags;
  final String type;
  final String date;
  final int limit;
  final String buildingID;

  FeedLoadList({
    required this.page,
    required this.buildingID,
    this.tags = "",
    this.type = "",
    this.date = "",
    this.limit = 1,
  });

  @override
  String toString() =>
      'FeedLoadList { page: $page, buildingID: $buildingID, tags: $tags, type: $type, date: $date }';

  @override
  List<Object> get props => [
        page,
        tags,
        type,
        date,
        limit,
      ];
}

class FeedLoadTicketList extends FeedEvent {
  final int page;
  final int status;

  FeedLoadTicketList({
    required this.page,
    required this.status,
  });
  @override
  List<Object> get props => [page, status];
  @override
  String toString() => 'FeedLoadTicketList { page: $page, status: $status';
}

class FeedReloadData extends FeedEvent {
  final int? status;

  FeedReloadData({this.status});
  @override
  List<Object> get props => [status ?? ''];
  @override
  String toString() => '------> FeedReloadData  status: $status}';
}
