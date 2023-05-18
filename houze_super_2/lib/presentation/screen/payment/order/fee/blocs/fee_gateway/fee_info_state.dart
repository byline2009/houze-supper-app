import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/model/page_model.dart';

abstract class FeeInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeeInfoInitial extends FeeInfoState {
  @override
  String toString() => 'FeeInfoInitial';

  @override
  List<Object> get props => [];
}

class FeeInfoLoadListLoading extends FeeInfoState {
  @override
  String toString() => 'FeeInfoLoadListLoading';
  @override
  List<Object> get props => [];
}

class FeeInfoLoadListSuccessful extends FeeInfoState {
  final List<FeeMessageModel> result;

  FeeInfoLoadListSuccessful({required this.result});
  @override
  List<Object> get props => [result];
  @override
  String toString() => 'FeeLoadListSuccessful { result: $result }';
}

class FeeInfoLoadDetailSuccessful extends FeeInfoState {
  final List<FeeDetailMessageModel> result;

  FeeInfoLoadDetailSuccessful({
    required this.result,
  });
  @override
  List<Object> get props => [result];

  @override
  String toString() =>
      'FeeInfoLoadDetailSuccessful { result: ${result.length} }';
}

class FeeInfoByMonthGetSuccessful extends FeeInfoState {
  final PageModel feeList;
  final List<FeeByMonth> feeByMonths;

  FeeInfoByMonthGetSuccessful({
    required this.feeList,
    required this.feeByMonths,
  });
  @override
  List<Object> get props => [feeByMonths, feeList];
  @override
  String toString() => 'FeeInfoByMonthGetSuccessful';
}

class FeeInfoFailure extends FeeInfoState {
  final dynamic error;

  FeeInfoFailure({required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'FeeInfoFailure { error: $error }';
}
