import 'package:equatable/equatable.dart';

abstract class ParkingVehicleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParkingVehicleGetList extends ParkingVehicleEvent {
  final dynamic params;

  ParkingVehicleGetList({this.params});
  @override
  List<Object> get props => [params];
  @override
  String toString() => 'ParkingVehicleGetList {params: $params}';
}

abstract class ParkingHistoryBookingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParkingHistoryBookingGetList extends ParkingHistoryBookingEvent {
  final dynamic params;

  ParkingHistoryBookingGetList({this.params});
  @override
  List<Object> get props => [params];
  @override
  String toString() => 'ParkingHistoryBookingGetList {}';
}

abstract class ParkingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParkingGetList extends ParkingEvent {
  ParkingGetList() : super();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'ParkingGetList {}';
}
