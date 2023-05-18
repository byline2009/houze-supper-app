import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/user_permission_model.dart';
import 'package:houze_super/utils/constant/api_constant.dart';
import 'package:houze_super/utils/sqflite.dart';

class PollApi extends OauthAPI {
  PollApi() : super('');

  Future<PageModel?> getPolls({int offset = 0, int limit = 5}) async {
    try {
      final buildingId = Sqflite.currentBuildingID;
      final response = await this.get(PollPath.getPollInfo, queryParameters: {
        "offset": offset,
        "limit": limit,
        "building_id": buildingId,
      });
      return PageModel.fromJson(response.data);
    } on DioError catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<PageModel?> getVoting(
      {int offset = 0, int limit = 5, required String id}) async {
    try {
      final response = await this
          .get(PollPath.getPollInfo + id + "/user-choices/", queryParameters: {
        "offset": offset,
        "limit": limit,
      });
      var data = json.decode(json.encode(response.data));
      return PageModel.fromJson(data);
    } on DioError catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future sendVote(
      {required String userChoiceID, required String choiceID}) async {
    final response = await this.patch(PollPath.userChoice + userChoiceID + '/',
        data: {"choice_id": choiceID});
    var data = json.decode(json.encode(response.data));
    return VotingModel.fromJson(data);
  }

  Future<UserPermission?> getUserPermission(
      {required BuildingMessageModel currentBuilding}) async {
    try {
      final response =
          await this.get(PollPath.userPermission + currentBuilding.id! + '/');
      if (response.statusCode == 200) {
        var data = json.decode(json.encode(response.data));
        return UserPermission.fromJson(data);
      }
    } catch (e) {
      throw e;
    }
  }
}
