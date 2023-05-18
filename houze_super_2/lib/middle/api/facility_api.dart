import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/citizen_json_model.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/sqflite.dart';

class FacilityAPI extends OauthAPI {
  FacilityAPI() : super(FacilityPath.getFacilities);

  Future<PageModel> getFacilities({int offset = 0, int limit = 5}) async {
    try {
      final buildingId = Sqflite.currentBuildingID;

      final response = await this.get(this.baseUrl, queryParameters: {
        "offset": offset,
        "limit": limit,
        "building_id": buildingId,
      });

      return PageModel.fromJson(response.data);
    } on DioError catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        return PageModel.fromJson(data);
      }

      throw error;
    }
  }

  Future<FacilityDetailModel> getFacilityDetail({required String id}) async {
    try {
      String url = FacilityPath.getDetail + id + "/";
      final response = await this.get(url);

      return FacilityDetailModel.fromJson(response.data);
    } catch (err) {
      throw err;
    }
  }

  Future<PageModel?> getHistories(String facilityId,
      {int? status, int offset = 0, int limit = 5}) async {
    try {
      final response = await this.get(
        FacilityPath.getFacilityHistories,
        queryParameters: {
          "building_id": Sqflite.currentBuildingID,
          "offset": offset,
          "limit": limit,
          "status": status,
          "facility_id": facilityId,
        },
      );

      return PageModel.fromJson(response.data);
    } catch (err) {
      // if (err.error is String) {
      //   final Map<String, dynamic> data = json.decode(err.error);

      //   return PageModel.fromJson(data);
      // } else
      rethrow;
    }
  }

  Future<PageModel> getBookingHistory({required int page, int? status}) async {
    final response = await this.get(
      FacilityPath.getFacilityHistories,
      queryParameters: {
        "building_id": Sqflite.currentBuildingID,
        "status": status,
        "limit": 10,
        "offset": page * 10,
      },
    );

    return PageModel.fromJson(response.data);
  }

  Future<FacilityRegistryModel> sendOrder(
      FacilityRegistryModel facility) async {
    try {
      String url = FacilityPath.getBookingDetail;
      final response = await this.post(url, data: facility.toJson());

      return response.statusCode != 200
          ? throw ('sendOrder failure')
          : FacilityRegistryModel.fromJson(response.data);
    } on DioError catch (_) {
      rethrow;
    }
  }

  Future<FacilityBookingDetailModel> getFacilityBookingDetail(
      {required String id}) async {
    try {
      String url = FacilityPath.getBookingDetail + id + '/';

      final response = await this.get(url);

      return FacilityBookingDetailModel.fromJson(response.data);
    } catch (err) {
      // if (err.error is String) {
      //   final Map<String, dynamic> data = json.decode(err.error);

      //   return FacilityBookingDetailModel.fromJson(data);
      // } else
      rethrow;
    }
  }

  Future<CitizenJsonModel> getFacilityWorking(
      {required String id, required String date}) async {
    String url = FacilityPath.getFacilities + '$id/$date/';
    final response = await this.get(url);

    return CitizenJsonModel.fromJson(response.data);
  }

  Future<FacilitySlotListModel> getFacilitySlot(
      {required String id,
      required String date,
      required String startTime,
      required String endTime}) async {
    String url =
        FacilityPath.getFacilities + '$id/slot/$date/$startTime/$endTime/';
    final response = await this.get(url);

    return FacilitySlotListModel.fromJson(response.data);
  }

  Future<FacilityDayoffModel> getFacilityDayoff(
      {required String id, required String date}) async {
    final response = await this.get(
      "${FacilityPath.getFacilities}$id/day-off/$date/",
    );

    return FacilityDayoffModel.fromJson(response.data);
  }
}
