import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/shop_detail_model.dart';
import 'package:houze_super/middle/model/voucher_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

class MerchantAPI extends OauthAPI {
  MerchantAPI() : super(MerchantPath.getShops);

  Future<PageModel> getShops(String point,
      {int type, int limit, int offset}) async {
    try {
      final response = await this.get(this.baseUrl, queryParameters: {
        "type": (type == null || type == -1) ? "" : type,
        "point": point,
        "offset": offset,
        "limit": limit,
      });

      return PageModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.error is String) {
        final Map<String, dynamic> data = json.decode(e.error);

        return PageModel.fromJson(data);
      }

      throw e;
    }
  }

  Future<ShopDetailModel> getMerchantShopById(String id) async {
    try {
      final response = await this.get(this.baseUrl + "$id/");
      return ShopDetailModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return ShopDetailModel.fromJson(data);
      } else
        rethrow;
    }
  }

  /* user-coupon */
  Future<PrivatePromotionPageModel> getUserCoupon(bool status,
      {int limit, int offset}) async {
    try {
      final response =
          await this.get(MerchantPath.getUserCoupon, queryParameters: {
        "offset": offset,
        "limit": limit,
        "can_use": status,
      });
      return PrivatePromotionPageModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PrivatePromotionPageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<PrivatePromotionModel> getUserCouponById(String id) async {
    try {
      final response = await this.get(MerchantPath.getUserCoupon + id);
      return PrivatePromotionModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PrivatePromotionModel.fromJson(data);
      } else
        rethrow;
    }
  }
}
