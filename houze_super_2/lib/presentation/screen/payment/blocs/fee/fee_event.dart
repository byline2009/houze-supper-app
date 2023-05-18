import 'package:equatable/equatable.dart';

abstract class FeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeeLoadList extends FeeEvent {
  final String buildingID;
  final String apartmentID;

  FeeLoadList({
    required this.buildingID,
    required this.apartmentID,
  });
  @override
  String toString() {
    return 'FeeLoadList: buildingID=$buildingID \t apartmentID=$apartmentID';
  }

  @override
  List<Object> get props => [
        buildingID,
        apartmentID,
      ];
}

// class FeeDetailLoad extends FeeEvent {
//   final String building;
//   final String apartment;
//   final String type;

//   FeeDetailLoad({
//     required this.building,
//     required this.apartment,
//     required this.type,
//   });

//   @override
//   String toString() {
//     return 'FeeDetailLoad { type=$type building=$building apartment=$apartment}';
//   }

//   @override
//   List<Object> get props => [
//         type,
//         apartment,
//         building,
//       ];
// }

// class FeeFilter extends FeeEvent {
//   final List<int>? types;
//   final String? building;
//   final String? apartment;

//   FeeFilter({this.building, this.apartment, this.types});
//   @override
//   List<Object> get props => [building ?? '', apartment ?? '', types ?? ''];
// }

class FeeChart extends FeeEvent {
  final String? building;
  final String? apartment;
  final int feeType;
  final int? year;
  final int page;

  FeeChart({
    this.building,
    this.apartment,
    required this.feeType,
    required this.page,
    this.year,
  });
  @override
  List<Object> get props =>
      [feeType, apartment ?? '', building ?? '', year ?? '', page];
}

class FeeLoadLimitList extends FeeEvent {
  final String building;
  final String apartment;
  final int feeType;
  final int? year;
  final int limit;

  FeeLoadLimitList({
    required this.limit,
    required this.building,
    required this.apartment,
    required this.feeType,
    this.year,
  });
  @override
  List<Object> get props => [limit, building, feeType, apartment];
}
