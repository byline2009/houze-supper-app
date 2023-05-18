import 'package:equatable/equatable.dart';

abstract class ParkingVehicleEvent extends Equatable {
  ParkingVehicleEvent([List props = const []]) : super();
}

class ParkingVehicleGetList extends ParkingVehicleEvent {
  final dynamic params;

  ParkingVehicleGetList({this.params}) : super([]);
  @override
  List<Object> get props => [params];
  @override
  String toString() => 'ParkingVehicleGetList {params: $params}';
}

abstract class ParkingHistoryBookingEvent extends Equatable {
  ParkingHistoryBookingEvent([List props = const []]) : super();
}

class ParkingHistoryBookingGetList extends ParkingHistoryBookingEvent {
  final dynamic params;

  ParkingHistoryBookingGetList({this.params}) : super([]);
  @override
  List<Object> get props => [params];
  @override
  String toString() => 'ParkingHistoryBookingGetList {}';
}

abstract class ParkingEvent extends Equatable {
  ParkingEvent([List props = const []]) : super();
}

class ParkingGetList extends ParkingEvent {
  ParkingGetList() : super();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'ParkingGetList {}';
}
