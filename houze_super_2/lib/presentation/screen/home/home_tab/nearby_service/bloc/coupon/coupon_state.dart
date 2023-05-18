import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/merchant_list_model.dart';

abstract class CouponState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CouponInitial extends CouponState {
  @override
  String toString() => 'CouponInitial';

  @override
  List<Object> get props => [];
}

class CouponsLoading extends CouponState {
  @override
  String toString() => 'CouponsLoading';
  @override
  List<Object> get props => [];
}

class MerchantLoadCouponsByShopSuccessful extends CouponState {
  final PagingCouponModel result;

  MerchantLoadCouponsByShopSuccessful({required this.result});
  @override
  List<Object> get props => [result];

  @override
  String toString() =>
      'MerchantLoadCouponsByShopSuccessful { result: $result }';
}

class CouponAllSuccessful extends CouponState {
  final PageModel result;

  CouponAllSuccessful({required this.result});
  @override
  List<Object> get props => [result];

  @override
  String toString() => 'CouponAllSuccessful { result: $result }';
}

class CouponShopLoading extends CouponState {
  @override
  String toString() => 'CouponShopLoading';
  @override
  List<Object> get props => [];
}

class CouponAllLoading extends CouponState {
  @override
  String toString() => 'CouponAllLoading';
  @override
  List<Object> get props => [];
}

class MerchantLoadCouponsShopFailure extends CouponState {
  final String error;

  MerchantLoadCouponsShopFailure({required this.error});
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'MerchantLoadCouponsShopFailure { error: $error }';
}

class CouponAllFailure extends CouponState {
  final String error;

  CouponAllFailure({required this.error});

  @override
  String toString() => 'CouponAllFailure { error: $error }';
  @override
  List<Object> get props => [error];
}
