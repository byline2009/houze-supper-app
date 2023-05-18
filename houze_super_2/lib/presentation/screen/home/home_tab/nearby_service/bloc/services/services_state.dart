import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/services_model.dart';

abstract class ServicesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServicesInitial extends ServicesState {
  @override
  String toString() => 'ServicesInitial';
  @override
  List<Object> get props => [];
}

class ServicesListSuccessful extends ServicesState {
  final ServicesModel result;

  ServicesListSuccessful({required this.result});
  @override
  List<Object> get props => [result];

  @override
  String toString() => 'ServicesListSuccessful { result: $result }';
}

class ServicesLoading extends ServicesState {
  @override
  String toString() => 'ServicesLoading';
  @override
  List<Object> get props => [];
}

class ServicesFailure extends ServicesState {
  final String error;

  ServicesFailure({required this.error});
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ServicesFailure { error: $error }';
}
