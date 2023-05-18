import 'package:equatable/equatable.dart';

abstract class MerchantEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MerchantLoadShopListByType extends MerchantEvent {
  final int page;
  final int? status;
  final int type;

  MerchantLoadShopListByType(
      {required this.page, this.status, required this.type});
  @override
  List<Object> get props => [page, status ?? '', type];
  @override
  String toString() => 'MerchantLoadShopListByType';
}

class MerchantGetShopDetailByID extends MerchantEvent {
  final String id;

  MerchantGetShopDetailByID({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'MerchantGetShopDetailByID { id: $id }';
}

class MerchantLoadCouponsByShop extends MerchantEvent {
  final String shopID;
  final int page;

  MerchantLoadCouponsByShop({required this.shopID, required this.page})
      ;
  @override
  List<Object> get props => [shopID, page];
  @override
  String toString() =>
      'MerchantLoadCouponsByShop {shopID: $shopID,  page: $page}';
}
