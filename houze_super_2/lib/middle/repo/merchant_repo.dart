import 'package:houze_super/middle/api/coupon_api.dart';
import 'package:houze_super/middle/api/merchant_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/coupon_model.dart';
import 'package:houze_super/middle/model/merchant_list_model.dart';
import 'package:houze_super/middle/model/shop_detail_model.dart';
import 'package:houze_super/middle/model/voucher_model.dart';

class MerchantRepository {
  final merchantAPI = MerchantAPI();
  final couponAPI = CouponAPI();

  /* User-coupon */
  Future<PrivatePromotionPageModel> getUserCoupon(bool status,
      {int offset = 0, int limit = 10}) async {
    final rs =
        await merchantAPI.getUserCoupon(status, offset: offset, limit: limit);
    return rs;
  }

  Future<CouponModel> getCouponById(String id) async {
    //Call Dio API
    final rs = await couponAPI.getCouponById(id);
    return rs;
  }

  Future<ShopDetailModel> getMerchantShopByID(String id) async {
    //Call Dio API
    final rs = await merchantAPI.getMerchantShopById(id);
    return rs;
  }

  Future<PagingCouponModel> getAllCoupon(String point,
      {int? type, int offset = 0, int limit = 10}) async {
    //Call Dio API
    try {
      final rs = await couponAPI.getAllCoupon(point,
          offset: offset, limit: limit, type: type);
      return rs;
    } catch (e) {
      rethrow;
    }
  }

  Future<CouponResult> createCoupon(String id) async {
    //Call Dio API
    try {
      final rs = await couponAPI.createCoupon(id);
      return rs;
    } catch (e) {
      return throw (e.toString());
    }
  }

  Future<PageModel> getLimitShops(String point,
      {int? type, int offset = 0, int limit = 4}) async {
    final rs = await merchantAPI.getShops(point,
        offset: offset, limit: limit, type: type);
    return rs;
  }

  Future<PageModel> getShopsByType(String point,
      {int? type, int offset = 0, int? limit}) async {
    final rs = await merchantAPI.getShops(point,
        offset: offset, limit: limit, type: type);
    return rs;
  }

  Future<PagingCouponModel> getCouponsByShop(
      {String? shopID, int? page, int limit = 10}) async {
    final rs = await couponAPI.getCouponsByShop(
      shopId: shopID,
      page: page,
      limit: limit,
    );
    return rs;
  }

  Future<PrivatePromotionModel> getUserCouponById(String id) async {
    //Call Dio API
    final rs = await merchantAPI.getUserCouponById(id);
    return rs;
  }
}
