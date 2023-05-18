import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HandbookEvent extends Equatable {
  HandbookEvent([List props = const []]) : super();
}

class HandbookGetList extends HandbookEvent {
  final int page;

  HandbookGetList({@required this.page}) : super([page]);

  @override
  String toString() => 'HandbookGetList {page: $page}';

  @override
  List<Object> get props => [page];
}

class HandbookGetDetail extends HandbookEvent {
  final String id;

  HandbookGetDetail({@required this.id}) : super([id]);
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'HandbookGetDetail {id: $id}';
}
