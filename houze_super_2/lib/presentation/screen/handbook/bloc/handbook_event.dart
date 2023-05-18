import 'package:equatable/equatable.dart';

abstract class HandbookEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HandbookGetList extends HandbookEvent {
  final int page;

  HandbookGetList({required this.page});

  @override
  String toString() => 'HandbookGetList {page: $page}';

  @override
  List<Object> get props => [page];
}

class HandbookGetDetail extends HandbookEvent {
  final String id;

  HandbookGetDetail({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'HandbookGetDetail {id: $id}';
}
