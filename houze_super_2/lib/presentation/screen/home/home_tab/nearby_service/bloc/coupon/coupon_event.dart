import 'package:equatable/equatable.dart';

abstract class CouponEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MerchantLoadCouponsByShop extends CouponEvent {
  final String shopId;
  final int page;

  MerchantLoadCouponsByShop({required this.shopId, required this.page});

  @override
  String toString() => 'MerchantLoadCouponsByShop { page: $page}';

  @override
  List<Object> get props => [shopId, page];
}

class CouponLoadList extends CouponEvent {
  final int? page;
  final int? type;

  CouponLoadList({this.page, this.type});
  @override
  List<Object> get props => [page ?? '', type ?? ''];

  @override
  String toString() => 'MerchantLoadShopsByType { page: $page, type: $type }';
}
