import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/coupon_model.dart';
import 'package:houze_super/middle/model/merchant_list_model.dart';
import 'package:houze_super/middle/model/voucher_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

class CouponAPI extends OauthAPI {
  CouponAPI() : super(MerchantPath.getCoupons);

  Future<CouponResult> createCoupon(String id) async {
    try {
      final response =
          await this.post(MerchantPath.base + "create-customer-coupon/", data: {
        "coupon_id": id,
      });

      return CouponResult.fromJson(response.data);
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<PagingCouponModel> getAllCoupon(String point,
      {int type, int limit = 10, int offset}) async {
    try {
      final response = await this.get(this.baseUrl, queryParameters: {
        "type": (type == null || type == -1) ? "" : type,
        "point": point,
        "offset": offset,
        "limit": limit,
        "is_expired": false,
        "is_picked": false,
      });

      return PagingCouponModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PagingCouponModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<CouponModel> getCouponById(String couponId) async {
    try {
      final response = await this.get(
        this.baseUrl + "$couponId/",
      );
      return CouponModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return CouponModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<PagingCouponModel> getCouponsByShop(
      {String shopId, int page, int type, int limit = 10, int offset}) async {
    try {
      final response = await this.get(this.baseUrl, queryParameters: {
        "shop_id": shopId,
        "offset": page * limit,
        "limit": limit,
      });

      return PagingCouponModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PagingCouponModel.fromJson(data);
      } else
        rethrow;
    }
  }
}
