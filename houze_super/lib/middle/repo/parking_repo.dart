import 'dart:io';

import 'package:houze_super/middle/api/parking_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';

class ParkingRepo {
  ParkingAPI api = ParkingAPI();

  Future<ImageModel> uploadImage(File file) async {
    //Call Dio API
    final rs = await api.uploadImage(file);
    if (rs != null) {
      return rs;
    }
    return null;
  }

  Future<List<Parking>> getParkingList({String buildingId = ""}) async {
    final rs = await api.getParkingList(buildingId: buildingId);
    return rs;
  }

  Future<PageModel> getParkingVehicle(
      {String buildingId = "", String aparmentId = ""}) async {
    final rs = await api.getParkingVehicle(
        buildingId: buildingId, apartmentId: aparmentId);
    return rs;
  }

  Future<PageModel> getParkingHistoryBooking(
      {String buildingId = "", String apartmentId = ""}) async {
    final rs = await api.getParkingHistoryBooking(
        buildingId: buildingId, apartmentId: apartmentId);
    return rs;
  }

  Future<dynamic> postParkingBooking(Map<String, dynamic> params) async {
    final rs = await api.postParkingBooking(params);
    return rs;
  }
}
