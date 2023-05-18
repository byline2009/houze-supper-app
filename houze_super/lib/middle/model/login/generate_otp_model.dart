class GenerateOTPModel {
  String expiredAt;
  int intlCode;
  int phoneNumber;

  GenerateOTPModel({this.expiredAt, this.intlCode, this.phoneNumber});

  GenerateOTPModel.fromJson(Map<String, dynamic> json) {
    expiredAt = json['expired_at'];
    intlCode = json['intl_code'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expired_at'] = this.expiredAt;
    data['intl_code'] = this.intlCode;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}
