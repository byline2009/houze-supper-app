import 'package:equatable/equatable.dart';

abstract class ServicesEvent extends Equatable {
  ServicesEvent([List props = const []]) : super();
}

class ServicesLoadList extends ServicesEvent {
  ServicesLoadList() : super([]);

  @override
  List<Object> get props => [];
}

class MerchantLoadShopsByType extends ServicesEvent {
  final int page;
  final int status;
  final int type;

  MerchantLoadShopsByType({this.page, this.status = -1, this.type})
      : super([page, status]);
  @override
  List<Object> get props => [page, status, type];
  @override
  String toString() =>
      'MerchantLoadShopsByType { page: $page, status: $status, type: $type }';
}
