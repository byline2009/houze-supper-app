import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum TypeDistanceDate { days7, weeks12, months12 }

class StatisticChartEvent extends Equatable {
  final TypeDistanceDate type;
  final int year;

  StatisticChartEvent({
    @required this.type,
    @required this.year,
  });

  @override
  String toString() =>
      'StatisticEvent: type: $type \t year: $year';

  @override
  List<Object> get props => [
        year,
        type,
      ];
}
