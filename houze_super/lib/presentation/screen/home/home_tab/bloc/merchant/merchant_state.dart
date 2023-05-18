import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/merchant_list_model.dart';
import 'package:houze_super/middle/model/shop_detail_model.dart';
import 'package:meta/meta.dart';

abstract class MerchantState extends Equatable {
  MerchantState([List props = const []]) : super();
}

class MerchantInitial extends MerchantState {
  @override
  String toString() => 'MerchantInitial';

  @override
  List<Object> get props => [];
}

class MerchantLoadShopSuccessful extends MerchantState {
  final PageModel result;

  MerchantLoadShopSuccessful({@required this.result});
  @override
  List<Object> get props => [result];
  @override
  String toString() => 'MerchantLoadShopSuccessful { result: $result }';
}

class MerchantLoadShopByTypeSuccessful extends MerchantState {
  final MerchantList list;

  MerchantLoadShopByTypeSuccessful({@required this.list});
  @override
  List<Object> get props => [list];
  @override
  String toString() => 'MerchantLoadShopByTypeSuccessful { list: $list }';
}

class MerchantShopLoading extends MerchantState {
  @override
  String toString() => 'MerchantLoading';
  @override
  List<Object> get props => [];
}

class MerchantShopFailure extends MerchantState {
  final dynamic error;

  MerchantShopFailure({@required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'MerchantShopFailure { error: $error }';
}

class MerchantDetailSuccessful extends MerchantState {
  final ShopDetailModel result;

  MerchantDetailSuccessful({@required this.result});
  @override
  List<Object> get props => [result];
  @override
  String toString() => 'MerchantDetailSuccessful { result: $result }';
}
