import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

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
          .citizenJson
          .map((i) {
        return i;
      }).toList();
    } catch (e) {
      if (e.error is String) {
        final Map<String, dynamic> data = json.decode(e.error);

        final List<ApartmentMessageModel> apartments =
            (data['citizen_json'] as List)
                .map((e) => ApartmentMessageModel.fromJson(e))
                .toList();

        return apartments;
      }
    }
    return null;
  }

  Future<ApartmentDetailModel> getApartmentByID({String id}) async {
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
}
