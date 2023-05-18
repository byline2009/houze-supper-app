import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';

abstract class ParkingVehicleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParkingVehicleInitial extends ParkingVehicleState {
  @override
  String toString() => 'ParkingVehicleInitial';

  @override
  List<Object> get props => [];
}

class ParkingVehicleGetListSuccessful extends ParkingVehicleState {
  final List<ParkingVehicle> parkingVehicles;

  ParkingVehicleGetListSuccessful({required this.parkingVehicles});
  @override
  List<Object> get props => [parkingVehicles];
  @override
  String toString() =>
      'ParkingVehicleGetListSuccessful { parkingVehicles: $parkingVehicles }';
}

class ParkingVehicleGetListFailure extends ParkingVehicleState {
  final dynamic error;

  ParkingVehicleGetListFailure({required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'ParkingVehicleGetListFailure { error: $error }';
}

class ParkingVehicleLoading extends ParkingVehicleState {
  @override
  String toString() => 'ParkingVehicleLoading';
  @override
  List<Object> get props => [];
}

abstract class ParkingHistoryBookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParkingHistoryBookingInitial extends ParkingHistoryBookingState {
  @override
  String toString() => 'ParkingHistoryBookingInitial';
  @override
  List<Object> get props => [];
}

class ParkingHistoryBookingGetListSuccessful
    extends ParkingHistoryBookingState {
  final List<ParkingVehicle> parkingBookingHistories;

  ParkingHistoryBookingGetListSuccessful(
      {required this.parkingBookingHistories});
  @override
  List<Object> get props => [parkingBookingHistories];
  @override
  String toString() =>
      'ParkingHistoryBookingGetListSuccessful { parkingBookingHistories: $parkingBookingHistories }';
}

class ParkingHistoryBookingGetListFailure extends ParkingHistoryBookingState {
  final dynamic error;

  ParkingHistoryBookingGetListFailure({required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'ParkingHistoryBookingGetListFailure { error: $error }';
}

class ParkingHistoryBookingLoading extends ParkingHistoryBookingState {
  @override
  String toString() => 'ParkingHistoryBookingLoading';
  @override
  List<Object> get props => [];
}

abstract class ParkingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ParkingListInitial extends ParkingState {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'ParkingListInitial';
}

class ParkingGetListSuccessful extends ParkingState {
  final List<Parking> result;

  ParkingGetListSuccessful({required this.result});
  @override
  List<Object> get props => [result];

  @override
  String toString() => 'ParkingGetListSuccessful { result: $result }';
}

class ParkingGetListFailure extends ParkingState {
  final dynamic error;

  ParkingGetListFailure({required this.error});
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ParkingGetListFailure { error: $error }';
}

class ParkingListLoading extends ParkingState {
  @override
  List<Object> get props => [];
  @override
  String toString() => 'ParkingListLoading';
}
