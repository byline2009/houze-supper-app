import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FeeEvent extends Equatable {
  FeeEvent([List props = const []]) : super();
}

class FeeLoadList extends FeeEvent {
  final String building;
  final String apartment;

  FeeLoadList({this.building, this.apartment}) : super([]);

  @override
  List<Object> get props => [building, apartment];
}

class FeeDetailLoad extends FeeEvent {
  final String building;
  final String apartment;
  final String type;

  FeeDetailLoad({
    this.building,
    this.apartment,
    this.type,
  }) : super([]);
  @override
  List<Object> get props => [
        type,
        apartment,
        building,
      ];
}

class FeeFilter extends FeeEvent {
  final List<int> types;
  final String building;
  final String apartment;

  FeeFilter({this.building, this.apartment, this.types}) : super([]);
  @override
  List<Object> get props => [building, apartment, types];
}

class FeeChart extends FeeEvent {
  final String building;
  final String apartment;
  final int feeType;
  final int year;
  final int page;

  FeeChart({
    this.building,
    this.apartment,
    @required this.feeType,
    @required this.page,
    this.year,
  });
  @override
  List<Object> get props => [
        feeType,
        apartment,
        building,
        year,
        page,
      ];
}

class FeeLoadLimitList extends FeeEvent {
  final String building;
  final String apartment;
  final int feeType;
  final int year;
  final int limit;

  FeeLoadLimitList({
    @required this.limit,
    @required this.building,
    @required this.apartment,
    @required this.feeType,
    this.year,
  });
  @override
  List<Object> get props => [limit, building, feeType, apartment];
}
