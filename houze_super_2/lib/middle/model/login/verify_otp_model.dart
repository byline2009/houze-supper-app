class VerifyOTPModel {
  String? accessToken;
  int? intlCode;
  int? phoneNumber;

  VerifyOTPModel({this.accessToken, this.intlCode, this.phoneNumber});

  VerifyOTPModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    intlCode = json['intl_code'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['intl_code'] = this.intlCode;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}
