import 'package:houze_super/middle/model/coupon_model.dart';

class PrivatePromotionList {
  int response;
  int count = 0;
  List<PrivatePromotionModel> data;

  PrivatePromotionList({this.response, this.count = 0, this.data});

  PrivatePromotionList.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    count = json['count'];
    if (json['data'] != null) {
      data = List<PrivatePromotionModel>();
      json['data'].forEach((v) {
        data.add(PrivatePromotionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response'] = this.response;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrivatePromotionPageModel {
  int count;
  String next;
  String previous;
  List<PrivatePromotionModel> results;

  PrivatePromotionPageModel(
      {this.count, this.next, this.previous, this.results});

  PrivatePromotionPageModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = List<PrivatePromotionModel>();
      json['results'].forEach((v) {
        results.add(PrivatePromotionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PrivatePromotionModel {
  String id;
  String code;
  CouponModel coupon;
  bool isUsed;

  PrivatePromotionModel({this.id, this.coupon, this.isUsed});

  PrivatePromotionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    coupon =
        json['coupon'] != null ? CouponModel.fromJson(json['coupon']) : null;
    isUsed = json['is_used'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['code'] = this.code;
    if (this.coupon != null) {
      data['coupon'] = this.coupon.toJson();
    }
    data['is_used'] = this.isUsed;
    return data;
  }
}

class CouponResult {
  String id;
  String code;
  String couponId;

  CouponResult({this.id, this.code, this.couponId});

  CouponResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    couponId = json['coupon_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['code'] = this.code;
    data['coupon_id'] = this.couponId;
    return data;
  }
}
