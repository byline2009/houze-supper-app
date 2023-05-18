class PaymentGatewayModel {
  String? id;
  String? appId;
  int? order;
  bool? isCheck;
  String? gatewayName;
  String? gatewayTitle;
  String? gatewayDesc;
  String? gatewayIcon;
  String? gatewayUserAgent;

  PaymentGatewayModel(
      {this.id,
      this.appId,
      this.order,
      this.isCheck,
      this.gatewayName,
      this.gatewayTitle,
      this.gatewayDesc,
      this.gatewayIcon,
      this.gatewayUserAgent});

  PaymentGatewayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appId = json['app_id'];
    order = json['order'];
    isCheck = json['is_check'];
    gatewayName = json['gateway'];
    gatewayTitle = json['title'];
    gatewayDesc = json['desc'];
    gatewayIcon = json['gateway_icon'];
    gatewayUserAgent = json['gateway_user_agent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_check'] = this.isCheck;
    data['app_id'] = this.appId;
    data['order'] = this.order;
    data['gateway_name'] = this.gatewayName;
    data['gateway_title'] = this.gatewayTitle;
    data['gateway_desc'] = this.gatewayDesc;
    data['gateway_icon'] = this.gatewayIcon;
    data['gateway_user_agent'] = this.gatewayUserAgent;
    return data;
  }
}
