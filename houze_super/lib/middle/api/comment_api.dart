import 'dart:convert';

import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/comment_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

class CommentAPI extends OauthAPI {
  CommentAPI() : super(TicketPath.ticketBase);

  Future<PageModel> getComment(String ticketID,
      {int offset = 0, int limit = 5}) async {
    try {
      final response = await this.get(
          "${TicketPath.ticketBase}$ticketID/comment/",
          queryParameters: {"offset": offset, "limit": limit});

      return PageModel.fromJson(response.data);
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PageModel.fromJson(data);
      }
      rethrow;
    }
  }

  Future<PageModel> getCommentByPage(String ticketID, int page,
      {int limit = 10}) async {
    try {
      final response = await this
          .get("${TicketPath.ticketBase}$ticketID/comment/", queryParameters: {
        "limit": limit,
        "offset": page * limit,
      });

      return PageModel.fromJson(response.data);
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PageModel.fromJson(data);
      }
      rethrow;
    }
  }

  Future<CommentModel> sendComment(String ticketID, String description,
      [CommentImageModel image]) async {
    var response;
    if (image != null) {
      response =
          await this.post("${TicketPath.ticketBase}$ticketID/comment/", data: {
        "description": description,
        "images": [
          {"image": image.image, "image_thumb": image.imageThumb}
        ]
      });
    } else {
      response =
          await this.post("${TicketPath.ticketBase}$ticketID/comment/", data: {
        "description": description,
      });
    }
    return CommentModel.fromJson(response.data);
  }
}
