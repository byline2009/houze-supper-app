import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

import 'oauth_api.dart';

class ChallengeAPI extends OauthAPI {
  ChallengeAPI() : super(RunPath.baseUrl);

  Future<PageModel> getAllEvent({
    @required int page,
    @required String buildingID,
  }) async {
    try {
      Map<String, dynamic> query = StringUtil.isEmpty(buildingID)
          ? {
              "offset": page * AppConstant.limitDefault,
              "limit": AppConstant.limitDefault
            }
          : {
              "organization_id": buildingID,
              "offset": page * AppConstant.limitDefault,
              "limit": AppConstant.limitDefault
            };
      final response = await this.get(
        RunPath.getAllEvent,
        queryParameters: query,
      );

      return PageModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(
          err.error,
        );
        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<EventModel> getEventByID({@required String id}) async {
    try {
      final response = await this.get(RunPath.getAllEvent + "$id/");
      return EventModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);
        return EventModel.fromJson(data);
      } else
        rethrow;
    }
  }
}
