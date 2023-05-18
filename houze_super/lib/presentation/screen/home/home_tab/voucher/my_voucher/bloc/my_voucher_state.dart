import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/voucher_model.dart';

import 'package:meta/meta.dart';

abstract class MyPromotionState extends Equatable {
  MyPromotionState([List props = const []]) : super();
}

class MyPromotionInitial extends MyPromotionState {
  @override
  String toString() => 'MyPromotionInitial';

  @override
  List<Object> get props => [];
}

class MyPromotionListSuccessful extends MyPromotionState {
  final PrivatePromotionList result;

  MyPromotionListSuccessful({@required this.result});
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

  MyPromotionFailure({@required this.error}) : super([error]);
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'MyPromotionFailure { error: $error }';
}
