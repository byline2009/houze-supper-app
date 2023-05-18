import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DashboadLoadByYearEvent extends Equatable {
  const DashboadLoadByYearEvent({
    @required this.year,
  });
  final int year;
  @override
  List<Object> get props => [
        year,
      ];

  @override
  String toString() => 'DashboadLoadByYearEvent { year: $year }';
}
