import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class ApartmentAPI extends OauthAPI {
  ApartmentAPI() : super(PropertyPath.getApartments);

  Future<List<ApartmentMessageModel>> getApartments(
      {String buildingId = "", int page = 0}) async {
    try {
      final response = await this.get(
        this.baseUrl,
        queryParameters: {
          "building": buildingId,
          "page": page,
        },
      );

      return ApartmentMessageBaseModel.fromJson(response.data)
          .citizenJson!
          .map((i) {
        return i;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<ApartmentDetailModel> getApartmentByID({required String id}) async {
    try {
      final response = await this.get("$baseUrl$id/");

      return ApartmentDetailModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return ApartmentDetailModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<ApartmentAccModel> getApartmentAccByID({String? id}) async {
    try {
      final response = await this.get("${PropertyPath.apartmentAcc}/",
          queryParameters: {"apartment_id": id});

      return ApartmentAccModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return ApartmentAccModel.fromJson(data);
      } else
        rethrow;
    }
  }
}
