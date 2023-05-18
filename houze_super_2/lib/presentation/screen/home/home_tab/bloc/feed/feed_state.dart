import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/feed_model.dart';

abstract class FeedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {
  @override
  String toString() => 'FeedInitial';
}

class MailboxLoadAnnoucementsSuccessful extends FeedState {
  final List<FeedMessageModel> result;

  MailboxLoadAnnoucementsSuccessful({required this.result});
  @override
  List<Object> get props => [result];
  @override
  String toString() => 'MailboxLoadAnnoucementsSuccessful { result: $result }';
}

class MailboxLoadTicketsSuccessful extends FeedState {
  final List<FeedMessageModel> result;

  MailboxLoadTicketsSuccessful({required this.result});
  @override
  List<Object> get props => [result];
  @override
  String toString() => 'MailboxLoadTicketsSuccessful { result: $result }';
}

class FeedLoading extends FeedState {
  @override
  String toString() => 'FeedLoading';
  @override
  List<Object> get props => [];
}

class FeedFailure extends FeedState {
  final dynamic error;

  FeedFailure({required this.error});
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FeedFailure { error: $error }';
}
