import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/handbook_model.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/sqflite.dart';

import 'oauth_api.dart';

class HandbookAPI extends OauthAPI {
  HandbookAPI() : super(BasePath.citizen);

  Future<PageModel> getHandbooks(int page) async {
    final buildingId = Sqflite.currentBuildingID;

    try {
      final response = await this.get(
        APIConstant.handbook,
        queryParameters: {
          "building_id": buildingId,
          "limit": AppConstant.limitDefault,
          "offset": page * AppConstant.limitDefault,
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

  Future<Handbook> getHandbook(String id) async {
    try {
      final response = await this.get(
        APIConstant.handbook + "$id/",
      );

      return Handbook.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return Handbook.fromJson(data);
      } else
        rethrow;
    }
  }
}
