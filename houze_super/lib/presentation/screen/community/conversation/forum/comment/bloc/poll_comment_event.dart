import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PollCommentEvent extends Equatable {
  PollCommentEvent([List props = const []]) : super();
}

class EventGetPollCommentList extends PollCommentEvent {
  final String id;
  final int page;
  final String ordering;

  EventGetPollCommentList(
      {@required this.id, @required this.page, this.ordering})
      : super();

  @override
  List<Object> get props => [this.id, this.page, this.ordering];
  @override
  String toString() => 'EventGetPollCommentList { id: $id , page: $page}';
}

class EventSendPollComment extends PollCommentEvent {
  final String threadID;
  final int displayType;
  final String description;
  final String imageID;

  EventSendPollComment(
      {@required this.threadID,
      @required this.displayType,
      @required this.description,
      this.imageID})
      : super();

  @override
  List<Object> get props => [this.threadID, this.description];
  @override
  String toString() =>
      'EventSendPollComment { Thread ID: $threadID , description: $description, imageID: $imageID, displayType: $displayType}';
}
