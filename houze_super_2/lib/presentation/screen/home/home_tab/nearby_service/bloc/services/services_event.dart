import 'package:equatable/equatable.dart';

abstract class ServicesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ServicesLoadList extends ServicesEvent {
  ServicesLoadList();

  @override
  List<Object> get props => [];
}

class MerchantLoadShopsByType extends ServicesEvent {
  final int? page;
  final int status;
  final int? type;

  MerchantLoadShopsByType({this.page, this.status = -1, this.type})
      ;
  @override
  List<Object> get props => [page ?? 0, status, type ?? 0];
  @override
  String toString() =>
      'MerchantLoadShopsByType { page: $page, status: $status, type: $type }';
}
