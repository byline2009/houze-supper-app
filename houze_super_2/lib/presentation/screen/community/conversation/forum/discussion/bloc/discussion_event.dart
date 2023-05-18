part of 'discussion_bloc.dart';

abstract class DiscussionEvent extends Equatable {
  const DiscussionEvent();

  @override
  List<Object> get props => [];
}

class GetDiscusionList extends DiscussionEvent {
  final int limit;
  final int? page;

  GetDiscusionList({this.limit = 5, this.page = 1}) : super();

  @override
  List<Object> get props => [this.limit, this.page ?? ""];
  @override
  String toString() => 'GetDiscusionList { limit: $limit , page: $page}';
}

class DeleteDiscussion extends DiscussionEvent {
  final String id;

  DeleteDiscussion({required this.id}) : super();

  @override
  List<Object> get props => [this.id];
  @override
  String toString() => 'DeleteDiscussion { id: $id}';
}

class UpdateCommentQuantity extends DiscussionEvent {
  final String id;
  final int quantity;

  UpdateCommentQuantity({required this.id, required this.quantity}) : super();

  @override
  List<Object> get props => [this.id, this.quantity];
  @override
  String toString() => 'DeleteDiscussion { id: $id}';
}
