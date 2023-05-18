import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'package:houze_super/utils/constant/api_constant.dart';
import 'package:houze_super/utils/constant/app_constant.dart';

/* Challenge repository - Houze run */
class ChallengeRepository {
  ChallengeRepository();
  final api = ChallengeAPI();

  Future<List<EventModel>> getAllEvent({
    required int page,
    required String buildingID,
  }) async {
    try {
      final res = await api.getAllEvent(
        page: page,
        buildingID: buildingID,
      );
      return (res.results as List).map((i) {
        return EventModel.fromJson(i);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<EventModel> getEventDetail({
    required String id,
  }) async {
    return await api.getEventByID(
      id: id,
    );
  }
}

class ChallengeAPI extends OauthAPI {
  ChallengeAPI() : super(RunPath.baseUrl);

  Future<PageModel> getAllEvent({
    required int page,
    required String buildingID,
  }) async {
    Map<String, dynamic> query = buildingID.isEmpty
        ? {
            "offset": page * AppConstant.limitDefault,
            "limit": AppConstant.limitDefault
          }
        : {
            "organization_id": buildingID,
            "offset": page * AppConstant.limitDefault,
            "limit": AppConstant.limitDefault
          };
    try {
      final response = await this.get(
        RunPath.getAllEvent,
        queryParameters: query,
      );

      return PageModel.fromJson(response.data);
    } on DioError catch (_) {
      rethrow;
    }
  }

  Future<EventModel> getEventByID({
    required String id,
  }) async {
    try {
      final response = await this.get(RunPath.getAllEvent + "$id/");
      if (response.statusCode != 200) {
        throw ('getEventByID failure');
      }
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
