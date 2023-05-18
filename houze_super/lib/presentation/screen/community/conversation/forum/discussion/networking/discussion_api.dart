import 'dart:convert';

import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/discussion_model.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/sqflite.dart';

class DiscussionApi extends OauthAPI {
  DiscussionApi() : super('');

  Future<PageModel> getThreads({int offset = 0, int limit = 5}) async {
    try {
      final buildingId = Sqflite.currentBuildingID;
      final response =
          await this.get(DiscusionPath.baseThread, queryParameters: {
        "offset": offset,
        "limit": limit,
        "building_id": buildingId,
      });
      return PageModel.fromJson(response.data);
    } catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<dynamic> postThread({DiscussionUpdateModel data}) async {
    try {
      final rs = await this.post(DiscusionPath.baseThread, data: data.toJson());
      return rs.data;
    } catch (e) {
      if (e.response != null && e.response.statusCode != 200)
        throw ("${e.response}");
      else {
        throw ("Lỗi kết nối máy chủ");
      }
    }
  }

  Future<dynamic> deleteThread({String id = ''}) async {
    try {
      Map<String, bool> data = {'active': false};
      final rs =
          await this.patch(DiscusionPath.baseThread + id + '/', data: data);
      return rs.data;
    } catch (e) {
      if (e.response != null && e.response.statusCode != 200)
        throw ("${e.response}");
      else {
        throw ("Lỗi kết nối máy chủ");
      }
    }
  }
}
