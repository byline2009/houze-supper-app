import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

class BuildingAPI extends OauthAPI {
  BuildingAPI() : super(PropertyPath.getBuildings);

  Future<List<BuildingMessageModel>> getBuildings({int page = 0}) async {
    try {
      final response = await this.get(this.baseUrl);
      return (response.data['citizen_json'] as List).map((i) {
        return BuildingMessageModel.fromJson(i);
      }).toList();
    } on DioError catch (e) {
      print(
          "Get building không thành công. Error: ${e.error} \t message: ${e.message}");
    } catch (e) {
      if (e.error is String) {
        final Map<String, dynamic> data = json.decode(e.error);

        final List<BuildingMessageModel> result = (data['citizen_json'] as List)
            .map((e) => BuildingMessageModel.fromJson(e))
            .toList();

        return result;
      } else
        print("Get building không thành công. ${e.toString()}");
    }
    return null;
  }
}
