import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/voucher_model.dart';

abstract class MyPromotionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyPromotionInitial extends MyPromotionState {
  @override
  String toString() => 'MyPromotionInitial';

  @override
  List<Object> get props => [];
}

class MyPromotionListSuccessful extends MyPromotionState {
  final PrivatePromotionList result;

  MyPromotionListSuccessful({required this.result});
  @override
  List<Object> get props => [];
  @override
  String toString() => 'MyPromotionListSuccessful { result: $result }';
}

class MyPromotionLoading extends MyPromotionState {
  @override
  String toString() => 'MyPromotionLoading';
  @override
  List<Object> get props => [];
}

class MyPromotionFailure extends MyPromotionState {
  final String error;

  MyPromotionFailure({required this.error});
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'MyPromotionFailure { error: $error }';
}
