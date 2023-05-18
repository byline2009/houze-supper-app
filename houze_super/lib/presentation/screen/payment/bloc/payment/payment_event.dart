import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  PaymentEvent([List props = const []]) : super();
}

class PaymentLoadGateway extends PaymentEvent {
  final String buildingId;
  @override
  List<Object> get props => [buildingId];
  PaymentLoadGateway({this.buildingId}) : super([]);
}

class PaymentLoadHistory extends PaymentEvent {
  final String apartmentId;
  final limit;
  final int status;

  PaymentLoadHistory({this.apartmentId, this.limit, this.status}) : super([]);
  @override
  List<Object> get props => [];
  @override
  String toString() =>
      'PaymentLoadHistory { apartmentId: $apartmentId, limit: $limit }';
}

class TransactionLoadList extends PaymentEvent {
  final String apartmentId;
  final int page;
  final int status;

  TransactionLoadList({this.apartmentId, this.page, this.status})
      : super([page]);
  @override
  List<Object> get props => [this.apartmentId, this.page, this.status];
  @override
  String toString() =>
      'TransactionLoadList { apartmentId: $apartmentId, page: $page, status: $status }';
}

class GetTransactionByStatus extends PaymentEvent {
  final String apartmentId;
  final int page;
  final int status;

  GetTransactionByStatus({this.apartmentId, this.page, this.status})
      : super([page]);
  @override
  List<Object> get props => [this.apartmentId, this.page, this.status];
  @override
  String toString() =>
      'TransactionLoadList { apartmentId: $apartmentId, page: $page, status: $status }';
}

class PaymentGetDetail extends PaymentEvent {
  final String id;

  PaymentGetDetail({this.id}) : super([]);

  @override
  String toString() => 'PaymentGetDetail { id: $id}';
  @override
  List<Object> get props => [id];
}

class PaymentBankTransferEvent extends PaymentEvent {
  final String id;
  final String buildingId;

  PaymentBankTransferEvent(this.id, this.buildingId);
  @override
  List<Object> get props => [id, buildingId];

  @override
  String toString() => 'PaymentBankTransferEvent {}';
}
