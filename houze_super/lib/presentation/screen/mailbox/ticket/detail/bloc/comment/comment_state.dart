import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/comment_model.dart';
import 'package:meta/meta.dart';

abstract class CommentState extends Equatable {
  CommentState([List props = const []]) : super();
}

class CommentInitial extends CommentState {
  @override
  String toString() => 'CommentInitial';

  @override
  List<Object> get props => [];
}

class CommentLoading extends CommentState {
  @override
  String toString() => 'CommentLoading';
  @override
  List<Object> get props => [];
}

class GetCommentByIDSuccessful extends CommentState {
  final List<CommentModel> result;
  final int totalCount;
  GetCommentByIDSuccessful({this.result, this.totalCount});
  @override
  String toString() => 'GetCommentByIDSuccessful: ${result.toList()}';
  @override
  List<Object> get props => [result, totalCount];
}

class SendCommentSuccessful extends CommentState {
  final CommentModel result;
  SendCommentSuccessful({this.result});
  @override
  String toString() => 'SendCommentSuccessful';
  @override
  List<Object> get props => [result];
}

class CommentFailure extends CommentLoading {
  final String error;

  CommentFailure({@required this.error}) : super();
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'CommentFailure { error: $error }';
}
