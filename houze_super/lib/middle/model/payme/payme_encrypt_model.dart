import 'package:equatable/equatable.dart';

class PayMEEncryptModel extends Equatable {
  final int amount;
  final String orderID;
  final String storeID;

  PayMEEncryptModel({
    this.amount,
    this.orderID,
    this.storeID,
  });
  factory PayMEEncryptModel.fromJson(Map<String, dynamic> json) {
    return PayMEEncryptModel(
      amount: json['amount'] == null ? null : json['amount'],
      orderID: json['order_id'] == null ? null : json['order_id'],
      storeID: json['store_id'] == null ? null : json['store_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        "amount": amount == null ? null : amount,
        "order_id": orderID == null ? null : orderID,
        "store_id": storeID == null ? null : storeID,
      };

  @override
  List<Object> get props => [
        amount,
        orderID,
        storeID,
      ];
}
