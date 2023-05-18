import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/facility/facility_booking_detail_model.dart';
import 'package:houze_super/middle/model/facility/facility_detail_model.dart';
import 'package:houze_super/middle/model/facility/facility_history_model.dart';
import 'package:houze_super/middle/model/facility/facility_model.dart';
import 'package:houze_super/middle/model/facility/facility_slot_model.dart';
import 'package:houze_super/middle/model/falicity_working_model.dart';

abstract class FacilityState extends Equatable {
  FacilityState();

  @override
  List<Object> get props => [];
}

class FacilityInitial extends FacilityState {}

class FacilityLoadingInProgress extends FacilityState {}

class FacilityLoadHistoriesInProgress extends FacilityState {}

class FacilityFailureState extends FacilityState {
  final dynamic error;

  FacilityFailureState([this.error]);

  @override
  String toString() => 'FacilityFailureState { error: $error }';
}

class FacilityLoadListSuccess extends FacilityState {
  final List<FacilityModel> result;

  FacilityLoadListSuccess([this.result = const []]);
  List<Object> get props => [result];

  @override
  String toString() => 'FacilityLoadListSuccess { result: $result }';
}

class FacilityLoadHistoriesSuccess extends FacilityState {
  final List<FacilityHistoryModel> result;

  FacilityLoadHistoriesSuccess([this.result = const []]);
  List<Object> get props => [result];

  @override
  String toString() => 'FacilityLoadHistoriesSuccess { result: $result }';
}

class GetFacilityType extends FacilityState {
  final List<int> result;

  GetFacilityType({required this.result});

  @override
  String toString() => 'GetFacilityType { result: $result }';
}

class GetFacilityDetailSuccess extends FacilityState {
  final FacilityDetailModel result;
  GetFacilityDetailSuccess({required this.result});
  List<Object> get props => [result];

  @override
  String toString() => 'GetFacilityDetail { result: $result }';
}

class GetFacilityBookingDetail extends FacilityState {
  final FacilityBookingDetailModel result;

  GetFacilityBookingDetail({required this.result});

  @override
  String toString() => 'GetFacilityBookingDetail { result: $result }';
}

class GetFacilityBookingDetailSuccess extends FacilityState {
  final FacilityBookingDetailModel result;
  GetFacilityBookingDetailSuccess({required this.result});
  List<Object> get props => [result];

  @override
  String toString() => 'GetFacilityBookingDetailSuccess { result: $result }';
}

class GetFacilityWorkingSuccess extends FacilityState {
  final List<FacilityWorkingModel> result;

  GetFacilityWorkingSuccess({required this.result});

  @override
  String toString() => 'GetFacilityWorkingSuccess { result: $result }';
}

class GetFacilityDayoff extends FacilityState {
  final description;

  GetFacilityDayoff({required this.description});

  @override
  String toString() => 'GetFacilityDayoff {result: $description}';
}

class GetFacilitySlot extends FacilityState {
  final List<FacilitySlotModel> result;
  final dynamic params;

  GetFacilitySlot({required this.result, this.params});

  @override
  String toString() => 'GetFacilitySlot { result: $result, params: $params }';
}

class GetFacilityHistory extends FacilityState {
  final List<FacilityHistoryModel> result;

  GetFacilityHistory({required this.result});

  @override
  String toString() => 'GetFacilityHistory { result: $result }';
}
