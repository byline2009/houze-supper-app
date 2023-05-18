import 'package:houze_super/middle/model/coupon_model.dart';
import 'package:houze_super/middle/model/shop_detail_model.dart';
import 'package:houze_super/middle/model/paging_model.dart';
import 'package:houze_super/middle/model/shop_model.dart';

class MerchantList {
  int response;
  int count = 0;
  List<ShopModel> data;

  MerchantList({this.response, this.count = 0, this.data});

  MerchantList.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    count = json['count'];
    if (json['data'] != null) {
      data = <ShopModel>[];
      json['data'].forEach((v) {
        data.add(ShopModel.fromJson(v));
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

class Hours {
  String id;
  String startTime;
  String endTime;
  int weekday;

  Hours({this.id, this.startTime, this.endTime, this.weekday});

  Hours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    weekday = json['weekday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['weekday'] = this.weekday;
    return data;
  }
}

class PagingShopModel extends PagingModel<ShopDetailModel> {
  PagingShopModel({count, next, previous, results})
      : super(
          count: count,
          next: next,
          previous: previous,
          results: results,
        );

  factory PagingShopModel.fromJson(Map<String, dynamic> json) =>
      PagingShopModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<ShopDetailModel>.from(
            json["results"].map((x) => ShopDetailModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<ShopDetailModel>.from(results.map((x) => x.toJson())),
      };

  @override
  String toString() => 'PagingShopModel { count: $count }';
}

class PagingCouponModel extends PagingModel<CouponModel> {
  PagingCouponModel({count, next, previous, results})
      : super(
          count: count,
          next: next,
          previous: previous,
          results: results,
        );

  factory PagingCouponModel.fromJson(Map<String, dynamic> json) =>
      PagingCouponModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<CouponModel>.from(
            json["results"].map((x) => CouponModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<CouponModel>.from(results.map((x) => x.toJson())),
      };

  @override
  String toString() => 'PagingCouponModel { count: $count }';
}
