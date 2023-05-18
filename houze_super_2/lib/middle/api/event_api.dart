import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'package:houze_super/utils/constant/index.dart';

import 'oauth_api.dart';

class EventAPI extends OauthAPI {
  EventAPI() : super(RunPath.baseUrl);
  Future<PageModel> getAllEvent({
    required int page,
    required String buildingID,
  }) async {
    try {
      Map<String, dynamic> query = buildingID.length == 0
          ? {
              "offset": page * AppConstant.limitDefault,
              "limit": AppConstant.limitDefault
            }
          : {
              "organization_id": buildingID,
              "offset": page * AppConstant.limitDefault,
              "limit": AppConstant.limitDefault
            };
      final response =
          await this.get(RunPath.getAllEvent, queryParameters: query);

      return PageModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);
        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<EventModel> getEventByID({required String id}) async {
    try {
      final response = await this.get(RunPath.getAllEvent + "$id/");
      return response.statusCode != 200
          ? throw ('getEventByID failure')
          : EventModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);
        return EventModel.fromJson(data);
      } else
        rethrow;
    }
  }
}
