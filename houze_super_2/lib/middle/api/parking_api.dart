import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class ParkingAPI extends OauthAPI {
  ParkingAPI() : super(BasePath.citizen);

  Future<ImageModel> uploadImage(File image) async {
    try {
      FormData formData = FormData.fromMap({
        "image":
            await MultipartFile.fromFile(image.path, filename: "parking.jpg")
      });

      final options =
          Options(sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);
      final response = await this.post(
        APIConstant.createVehicleImage,
        data: formData,
        options: options,
      );
      if (response.statusCode != 200) throw ('uploadImage failure');
      final rs = ImageModel.fromJson(response.data);
      print("Image with id: ${rs.id}");
      return rs;
    } on DioError catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<Parking>> getParkingList({String buildingId = ""}) async {
    try {
      final response = await this.get(
        APIConstant.getParkingList,
        queryParameters: {"building_id": buildingId},
      );
      return (response.data['citizen_json'] as List)
          .map((i) => Parking.fromJson(i))
          .toList();
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return (data['citizen_json'] as List)
            .map((i) => Parking.fromJson(i))
            .toList();
      } else
        rethrow;
    }
  }

  Future<PageModel> getParkingVehicle({
    String buildingId = "",
    String apartmentId = "",
  }) async {
    try {
      final response = await this.get(APIConstant.getParkingVehicle,
          queryParameters: {
            "building_id": buildingId,
            "apartment_id": apartmentId,
            "limit": 100
          });

      return PageModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<PageModel> getParkingHistoryBooking({
    String buildingId = "",
    String apartmentId = "",
  }) async {
    try {
      final response = await this.get(
        APIConstant.getParkingBookingHistory,
        queryParameters: {
          "building_id": buildingId,
          "apartment_id": apartmentId,
          "limit": 100,
        },
      );

      return PageModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<dynamic> postParkingBooking(Map<String, dynamic> params) async {
    try {
      final response = await this
          .post(APIConstant.createVehicleParkingBooking, data: params);
      return response.data;
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode != 200)
        throw ("${e.response}");
      else {
        throw ("Lỗi kết nối máy chủ");
      }
    }
  }
}
