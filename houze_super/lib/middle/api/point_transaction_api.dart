import 'dart:convert';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/houze_point/point_transaction_history_model.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/sqflite.dart';

class PointTransationHistoryAPI extends OauthAPI {
  PointTransationHistoryAPI() : super(PointPath.getPointTransationHistory);

  Future<PageModel> getPointTransactionHistory(
      {String buildingId,
      String action,
      int offset = 0,
      int limit = 5,
      String date}) async {
    String startDate;
    String endDate;
    if (date != null) {
      final String month = date.substring(5, date.length);
      final String year = date.substring(0, 4);
      final int lastdayOfMonth =
          DateTime(int.parse(year), int.parse(month) + 1, 0).day;
      startDate = date + "-01";
      endDate = date + "-${lastdayOfMonth.toString()}";
    }

    try {
      final response =
          await this.get(PointPath.getPointTransationHistory, queryParameters: {
        "building_id": Sqflite.currentBuildingID,
        "action": action,
        "offset": offset,
        "limit": limit,
        "created_gte": date != null ? startDate : null,
        "created_lte": date != null ? endDate : null
      });
      return PageModel.fromJson(response.data);
    } catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<TotalPointModel> getTotalPoint() async {
    try {
      final response = await this.get(PointPath.getTotalHouzePoint);
      return TotalPointModel.fromJson(response.data);
    } catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        return TotalPointModel.fromJson(data);
      } else
        rethrow;
    }
  }
}
