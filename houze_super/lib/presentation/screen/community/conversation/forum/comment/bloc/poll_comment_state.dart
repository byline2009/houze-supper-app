import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:meta/meta.dart';

abstract class PollCommentState extends Equatable {
  PollCommentState([List props = const []]) : super();
}

class PollCommentInitial extends PollCommentState {
  @override
  String toString() => 'PollCommentInitial';

  @override
  List<Object> get props => [];
}

class PollCommentLoading extends PollCommentState {
  @override
  String toString() => 'PollCommentLoading';
  @override
  List<Object> get props => [];
}

class GetPollCommentListSuccessful extends PollCommentState {
  final List<PollCommentModel> result;
  final int totalCount;
  GetPollCommentListSuccessful({this.result, this.totalCount});
  @override
  String toString() => 'GetPollCommentListSuccessful: ${result.toList()}';
  @override
  List<Object> get props => [result, totalCount];
}

class SendPollCommentSuccessful extends PollCommentState {
  final PollCommentModel result;
  SendPollCommentSuccessful({this.result});
  @override
  String toString() => 'SendPollCommentSuccessful';
  @override
  List<Object> get props => [result];
}

class PollCommentFailure extends PollCommentLoading {
  final String error;

  PollCommentFailure({@required this.error}) : super();
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'PollCommentFailure { error: $error }';
}
