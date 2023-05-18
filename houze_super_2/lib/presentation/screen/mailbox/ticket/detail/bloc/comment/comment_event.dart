import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/image_model.dart';

abstract class CommentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventGetCommentByID extends CommentEvent {
  final String id;

  EventGetCommentByID({required this.id}) : super();

  @override
  String toString() => 'EventGetCommentByID { id: $id }';

  @override
  List<Object> get props => [id];
}

class EventGetCommentList extends CommentEvent {
  final String id;
  final int page;

  EventGetCommentList({required this.id, required this.page}) : super();

  @override
  List<Object> get props => [this.id, this.page];
  @override
  String toString() => 'EventGetCommentList { id: $id , page: $page}';
}

class EventSendCommentByID extends CommentEvent {
  final String id;
  final String content;
  final CommentImageModel? image;

  EventSendCommentByID({required this.id, required this.content, this.image})
      : super();

  @override
  List<Object> get props => [this.id, this.content];
  @override
  String toString() => 'EventSendCommentByID { id: $id , content: $content}';
}

class CommentLoadList extends CommentEvent {
  final int? page;
  final String id;

  CommentLoadList({this.page, this.id = ""});

  @override
  List<Object> get props => [this.page ?? '', this.id];
  @override
  String toString() => 'CommentLoadList { page: $page, id: $id }';
}

class CommentRequest extends CommentEvent {
  final String? id;
  final String? description;

  CommentRequest({this.id, this.description}) : super();

  @override
  List<Object> get props => [this.id ?? '', this.description ?? ''];
  @override
  String toString() => 'CommentRequest { id: $id, description: $description }';
}
