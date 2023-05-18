import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BaseInitial extends BaseState {
  @override
  String toString() => 'BaseInitial';

  @override
  List<Object> get props => [];
}

class BaseLoading extends BaseState {
  @override
  String toString() => 'BaseLoading';
  @override
  List<Object> get props => [];
}

class BaseListSuccessful extends BaseState {
  final dynamic result;

  BaseListSuccessful({required this.result});
  @override
  List<Object> get props => [result];

  @override
  String toString() => 'BaseListSuccessful { result: $result }';
}

class BaseRequestSuccessful extends BaseState {
  final dynamic result;

  BaseRequestSuccessful({required this.result});
  @override
  List<Object> get props => [result];
  @override
  String toString() => 'BaseRequestSuccessful { result: $result }';
}

class BaseFailure extends BaseState {
  final dynamic error;

  BaseFailure({required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'BaseFailure { error: $error }';
}
