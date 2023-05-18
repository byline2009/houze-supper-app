import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class PollCommentAPI extends OauthAPI {
  PollCommentAPI() : super(PollPath.getThread);

  Future<PageModel> getPollCommentList(
      {required int page,
      int limit = 10,
      required String id,
      String ordering = '-created'}) async {
    try {
      final response = await this
          .get(PollPath.getThread + id + "/comments/", queryParameters: {
        "ordering": ordering,
        "offset": limit * page,
        "limit": limit,
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

  Future<PollCommentModel> sendComment(
      String description, int displayType, String threadID,
      [String? imageID]) async {
    var response;
    try {
      if (imageID != null) {
        response = await this
            .post(PollPath.getThread + threadID + "/comments/", data: {
          "description": description,
          "display_type": displayType,
          "image_ids": ["$imageID"],
        });
      } else {
        response = await this.post(PollPath.getThread + threadID + "/comments/",
            data: {"description": description, "display_type": displayType});
      }
    } on DioError catch (e) {
      if (e.response != null && e.response?.statusCode != 200)
        throw ("${e.response}");
      else {
        throw ("Lỗi kết nối máy chủ");
      }
    }

    return PollCommentModel.fromJson(response.data);
  }
}
