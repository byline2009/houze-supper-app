import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/local/storage.dart';

import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import '../models/index.dart';

class ChatApi extends OauthAPI {
  ChatApi() : super(ChatPath.base);

  Future<List<LastMessageModel>> getLastMessages({
    @required int page,
    @required String buildingID,
  }) async {
    try {
      final profileAPI = ProfileAPI();
      await profileAPI.getProfile();

      Future.delayed(Duration(milliseconds: 300));

      final response = await Dio().get(
        ChatPath.getMessagesLast,
        queryParameters: {
          "limit": AppConstant.limitDefault,
          "skip": page * AppConstant.limitDefault,
          "title": "",
          "fields": "organization_id",
          "organization_id": buildingID
        },
        options: Options(
          headers: {
            "Authorization": "${OauthAPI.tokenType} ${Storage.getChatToken()}"
          },
        ),
      );

      final convert = (response.data['data']['list'] as List).map(
        (i) {
          return LastMessageModel.fromJson(i);
        },
      ).toList();

      return convert;
    } on DioError catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        final convert = (data['data']['list'] as List).map(
          (i) {
            return LastMessageModel.fromJson(i);
          },
        ).toList();
        return convert;
      } else
        rethrow;
    }
  }

  Future<RoomModel> getRoomDetail(
      {@required String roomId, int page = 0}) async {
    try {
      final response = await Dio().get(
        ChatPath.getMessagesChatDetail,
        queryParameters: {
          "id": roomId,
          "limit": AppConstant.limitMessages,
          "skip": page * AppConstant.limitMessages,
        },
        options: Options(
          headers: {
            "Authorization": "${OauthAPI.tokenType} ${Storage.getChatToken()}"
          },
        ),
      );

      return RoomModel.fromJson(response.data['data']['room']);
    } catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        final RoomModel result = RoomModel.fromJson(data['data']['room']);

        return result;
      } else
        rethrow;
    }
  }
}
