class PaymentModel {
  String id;
  String buildingId;
  String apartmentId;
  List<int> feeTypes;
  String gateway;
  String bankCode;
  String urlPayment;
  String info;
  bool isTestMode;

  PaymentModel(
      {this.id,
      this.buildingId,
      this.apartmentId,
      this.feeTypes,
      this.gateway,
      this.bankCode,
      this.urlPayment,
      this.info,
      this.isTestMode});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buildingId = json['building_id'];
    apartmentId = json['apartment_id'];
    feeTypes = json['fee_types'].cast<int>();
    gateway = json['gateway'];
    bankCode = json['bank_code'];
    urlPayment = json['url_payment'];
    info = json['info'];
    isTestMode = json['is_test_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['building_id'] = this.buildingId;
    data['apartment_id'] = this.apartmentId;
    data['fee_types'] = this.feeTypes;
    data['gateway'] = this.gateway;
    if (this.bankCode != null) {
      data['bank_code'] = this.bankCode;
    }
    data['url_payment'] = this.urlPayment;
    data['info'] = this.info;

    if (this.isTestMode != null) {
      data['is_test_mode'] = this.isTestMode;
    }
    return data;
  }
}

class PaymentInfoModel {
  final int amount;
  final String orderCodeV2;

  PaymentInfoModel({this.amount, this.orderCodeV2});
}

class PaymentPayooEncryptModel {
  int clientId;
  String secretKey;
  String checksum;

  PaymentPayooEncryptModel({this.clientId, this.secretKey, this.checksum});

  PaymentPayooEncryptModel.fromJson(Map<String, dynamic> json) {
    clientId = json['client_id'];
    secretKey = json['secret_key'];
    checksum = json['checksum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['client_id'] = this.clientId;
    data['secret_key'] = this.secretKey;
    data['checksum'] = this.checksum;
    return data;
  }
}
