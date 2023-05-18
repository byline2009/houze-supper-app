import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RunLoadDataEvent extends Equatable {
  final String buildingID;

  const RunLoadDataEvent({
    @required this.buildingID,
  });

  @override
  List<Object> get props => [
        buildingID,
      ];

  @override
  String toString() => 'RunLoadDataEvent { buildingID: $buildingID  }';
}
