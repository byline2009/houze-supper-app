import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:meta/meta.dart';

abstract class FeeState extends Equatable {
  FeeState([List props = const []]) : super();
}

class FeeInitial extends FeeState {
  @override
  String toString() => 'FeeInitial';

  @override
  List<Object> get props => [];
}

class FeeLoadListLoading extends FeeState {
  @override
  String toString() => 'FeeLoadListLoading';
  @override
  List<Object> get props => [];
}

class FeeLoadListSuccessful extends FeeState {
  final List<FeeMessageModel> result;

  FeeLoadListSuccessful({@required this.result});
  @override
  List<Object> get props => [result];
  @override
  String toString() => 'FeeLoadListSuccessful { result: $result }';
}

class FeeLoadDetailSuccessful extends FeeState {
  final PageModel result;

  FeeLoadDetailSuccessful({
    @required this.result,
  });
  @override
  List<Object> get props => [result];
  @override
  String toString() => 'FeeLoadDetailSuccessful { result: ${result.count} }';
}

class FeeByMonthGetSuccessful extends FeeState {
  final PageModel feeList;
  final List<FeeByMonth> feeByMonths;

  FeeByMonthGetSuccessful({
    @required this.feeByMonths,
    @required this.feeList,
  });
  @override
  List<Object> get props => [feeByMonths, feeList];
  @override
  String toString() => 'FeeByMonthGetSuccessful';
}

class FeeFailure extends FeeState {
  final dynamic error;

  FeeFailure({@required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'FeeFailure { error: $error }';
}
