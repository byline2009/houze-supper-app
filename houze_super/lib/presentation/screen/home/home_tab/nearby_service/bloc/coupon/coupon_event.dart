import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CouponEvent extends Equatable {
  CouponEvent([List props = const []]) : super();
}

class MerchantLoadCouponsByShop extends CouponEvent {
  final String shopId;
  final int page;

  MerchantLoadCouponsByShop({@required this.shopId, @required this.page})
      : super([shopId, page]);

  @override
  String toString() => 'MerchantLoadCouponsByShop { page: $page}';

  @override
  List<Object> get props => [shopId, page];
}

class CouponLoadList extends CouponEvent {
  final int page;
  final int type;

  CouponLoadList({this.page, this.type}) : super([page, type]);
  @override
  List<Object> get props => [page, type];

  @override
  String toString() => 'MerchantLoadShopsByType { page: $page, type: $type }';
}
