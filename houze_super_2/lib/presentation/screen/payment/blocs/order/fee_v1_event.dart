import 'package:equatable/equatable.dart';

abstract class FeeV1Event extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeeLoading extends FeeV1Event {
  FeeLoading();

  @override
  String toString() => 'FeeLoading';

  @override
  List<Object> get props => [];
}

class GetFeeGroupApartment extends FeeV1Event {
  GetFeeGroupApartment();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'GetFeeGroupApartment';
}
