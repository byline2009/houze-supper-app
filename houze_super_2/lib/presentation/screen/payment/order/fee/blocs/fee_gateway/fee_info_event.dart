import 'package:equatable/equatable.dart';

abstract class FeeInfoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeeLoadList extends FeeInfoEvent {
  final String buildingID;
  final String apartmentID;

  FeeLoadList({
    required this.buildingID,
    required this.apartmentID,
  });

  @override
  List<Object> get props => [
        buildingID,
        apartmentID,
      ];
}

class FeeDetailLoad extends FeeInfoEvent {
  final String building;
  final String apartment;
  final String type;

  FeeDetailLoad({
    required this.building,
    required this.apartment,
    required this.type,
  });
  @override
  List<Object> get props => [
        type,
        apartment,
        building,
      ];
}

class FeeFilter extends FeeInfoEvent {
  final List<int> types;
  final String building;
  final String apartment;

  FeeFilter({
    required this.building,
    required this.apartment,
    required this.types,
  });
  @override
  List<Object> get props => [building, apartment, types];
}

class FeeChart extends FeeInfoEvent {
  final String building;
  final String apartment;
  final int feeType;
  final int year;
  final int page;

  FeeChart({
    required this.building,
    required this.apartment,
    required this.feeType,
    required this.page,
    required this.year,
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

class FeeLoadLimitList extends FeeInfoEvent {
  final String building;
  final String apartment;
  final int feeType;
  final int year;
  final int limit;

  FeeLoadLimitList({
    required this.limit,
    required this.building,
    required this.apartment,
    required this.feeType,
    required this.year,
  });
  @override
  List<Object> get props => [
        limit,
        building,
        feeType,
        apartment,
        year,
      ];
}
