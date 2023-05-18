import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/fee_model.dart';

abstract class FeeFilterState extends Equatable {
  FeeFilterState([List props = const []]);
  @override
  List<Object?> get props => [];
}

class FeeFilterInitial extends FeeFilterState {
  @override
  String toString() => 'FeeFilterInitial';
}

class FeeFilterLoading extends FeeFilterState {
  @override
  String toString() => 'FeeFilterLoading';
}

class FeeFilterSuccessful extends FeeFilterState {
  final List<FeeMessageModel> results;
  FeeFilterSuccessful({
    required this.results,
  });

  @override
  List<Object> get props => [results];

  @override
  String toString() {
    return 'FeeFilterSuccessful  results= ${results.length} ';
  }
}

class FeeFilterFailure extends FeeFilterState {
  final dynamic error;

  FeeFilterFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FeeFilterFailure { error: $error }';
}

class FeeLoadListLoading extends FeeFilterState {
  @override
  String toString() => 'FeeLoadListLoading';
  @override
  List<Object> get props => [];
}

class FeeLoadDetailSuccessful extends FeeFilterState {
  final List<FeeDetailMessageModel> results;
  FeeLoadDetailSuccessful({
    required this.results,
  });

  @override
  List<Object> get props => [results];

  @override
  String toString() {
    return 'FeeLoadDetailSuccessful { results: ${results.length} }';
  }
}

class FeeFailure extends FeeFilterState {
  final dynamic error;

  FeeFailure({required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'FeeFailure { error: $error }';
}
