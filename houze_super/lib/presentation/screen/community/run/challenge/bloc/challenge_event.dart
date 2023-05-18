import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChallengeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EventLoadChallengeList extends ChallengeEvent {
  final int page;
  final String buildingID;

  EventLoadChallengeList({
    @required this.page,
    @required this.buildingID,
  });

  @override
  String toString() => 'EventLoadChallengeList  buildingID: $buildingID';

  @override
  List<Object> get props => [
        page,
        buildingID,
      ];
}
