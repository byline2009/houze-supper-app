import 'package:equatable/equatable.dart';

abstract class FeeV1Event extends Equatable {
  FeeV1Event([List props = const []]) : super();
}

class FeeLoading extends FeeV1Event {
  FeeLoading() : super([]);

  @override
  String toString() => 'FeeLoading';

  @override
  List<Object> get props => [];
}

class GetFeeGroupApartment extends FeeV1Event {
  GetFeeGroupApartment() : super([]);
  @override
  List<Object> get props => [];
  @override
  String toString() => 'GetFeeGroupApartment';
}
