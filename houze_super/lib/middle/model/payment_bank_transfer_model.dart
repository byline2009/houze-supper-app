import 'dart:convert';

PaymentBankTransfer paymentBankTransferFromJson(String str) =>
    PaymentBankTransfer.fromJson(json.decode(str));

String paymentBankTransferToJson(PaymentBankTransfer data) =>
    json.encode(data.toJson());

class PaymentBankTransfer {
  PaymentBankTransfer({
    this.bankCode,
    this.bankOwner,
    this.bankOwnerNumber,
    this.enable,
    this.externalBankId,
  });

  String bankCode;
  String bankOwner;
  String bankOwnerNumber;
  bool enable;
  String externalBankId;

  factory PaymentBankTransfer.fromJson(Map<String, dynamic> json) =>
      PaymentBankTransfer(
        bankCode: json["bank_code"],
        bankOwner: json["bank_owner"],
        bankOwnerNumber: json["bank_owner_number"],
        enable: json["enable"],
        externalBankId: json["external_bank_id"],
      );

  Map<String, dynamic> toJson() => {
        "bank_code": bankCode,
        "bank_owner": bankOwner,
        "bank_owner_number": bankOwnerNumber,
        "enable": enable,
        "external_bank_id": externalBankId,
      };
}
