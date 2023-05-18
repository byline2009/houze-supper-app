import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/feed_model.dart';

class EventReadFeed extends Equatable {
  final FeedMessageModel feed;
  EventReadFeed({
    @required this.feed,
  });
  @override
  List<Object> get props => [
        feed,
      ];
}
