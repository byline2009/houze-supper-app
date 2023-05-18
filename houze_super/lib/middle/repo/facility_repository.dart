import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/facility_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/citizen_json_model.dart';
import 'package:houze_super/middle/model/facility/facility_detail_model.dart';
import 'package:houze_super/middle/model/facility/facility_history_model.dart';
import 'package:houze_super/middle/model/facility/index.dart';

class FacilityRepository {
  final api = FacilityAPI();

  FacilityRepository();

  Future<PageModel> getFacilities({int offset = 0, int limit}) async {
    final response = await api.getFacilities(limit: limit, offset: offset);
    return response;
  }

  Future<FacilityDetailModel> getFacilityDetail({@required String id}) async {
    return await api.getFacilityDetail(id: id);
  }

  Future<List<FacilityHistoryModel>> getHistories(String facilityId,
      {int status, int offset = 0, int limit = 5}) async {
    //Call Dio API
    final rs = await api.getHistories(facilityId,
        limit: limit, offset: offset, status: status);
    if (rs != null) {
      return (rs.results as List).map((i) {
        return FacilityHistoryModel.fromJson(i);
      }).toList();
    }
    return null;
  }

  Future<List<FacilityHistoryModel>> getBookingHistory(
      {@required int page, int status}) async {
    //Call Dio API
    final rs = await api.getBookingHistory(page: page, status: status);
    if (rs != null) {
      return (rs.results as List).map((i) {
        return FacilityHistoryModel.fromJson(i);
      }).toList();
    }
    return null;
  }

  Future<bool> sendOrder(FacilityRegistryModel ticket) async {
    //Call Dio API
    final rs = await api.sendOrder(ticket);
    if (rs != null) {
      return true;
    }
    return false;
  }

  Future<FacilityBookingDetailModel> getFacilityBookingDetail(
      {@required String id}) async {
    return await api.getFacilityBookingDetail(id: id);
  }

  Future<CitizenJsonModel> getFacilityWorking(
      {@required String id, @required String date}) async {
    return await api.getFacilityWorking(id: id, date: date);
  }

  Future<FacilitySlotListModel> getFacilitySlot(
      {@required String id,
      @required String date,
      @required String startTime,
      @required String endTime}) async {
    return await api.getFacilitySlot(
        id: id, date: date, startTime: startTime, endTime: endTime);
  }

  Future<FacilityDayoffModel> getFacilityDayoff(
      {@required String id, @required String date}) async {
    try {
      return await api.getFacilityDayoff(id: id, date: date);
    } catch (e) {
      return null;
    }
  }
}
