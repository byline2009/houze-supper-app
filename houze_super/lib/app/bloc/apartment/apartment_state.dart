import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:meta/meta.dart';

abstract class ApartmentState extends Equatable {
  ApartmentState([List props = const []]) : super();
}

class ApartmentInitial extends ApartmentState {
  @override
  String toString() => 'ApartmentInitial';

  @override
  List<Object> get props => [];
}

class ApartmentSuccessful extends ApartmentState {
  final List<ApartmentMessageModel> result;
  final ApartmentMessageModel apartment;

  ApartmentSuccessful({@required this.result, this.apartment});
  @override
  List<Object> get props => [this.result, this.apartment];
  @override
  String toString() => 'ApartmentSuccessful { result: $result }';
}

class ApartmentHotReload extends ApartmentState {
  @override
  String toString() => 'ApartmentHotReload';
  @override
  List<Object> get props => [];
}

class ApartmentLoading extends ApartmentState {
  @override
  String toString() => 'ApartmentLoading';
  @override
  List<Object> get props => [];
}

class ApartmentFailure extends ApartmentState {
  final dynamic error;

  ApartmentFailure({@required this.error});
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ApartmentFailure { error: $error }';
}

class ApartmentGetDetailSuccessful extends ApartmentState {
  final ApartmentDetailModel apartmentDetail;

  ApartmentGetDetailSuccessful({@required this.apartmentDetail});
  @override
  List<Object> get props => [apartmentDetail];
  @override
  String toString() =>
      'ApartmentGetDetailSuccessful { apartmentDetail: $apartmentDetail }';
}
