import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/ws/chat_controller.dart';

import 'package:houze_super/utils/constant/index.dart';

import '../index.dart';

class ChatApi {
  ChatApi({
    required Dio dio,
  })  : _dio = dio,
        super();
  final profileAPI = ProfileAPI();
  final Dio _dio;
  Future<List<LastMessageModel>?> getLastMessage({
    required int page,
    required String buildingID,
  }) async {
    try {
      if (Storage.getChatToken().isEmpty || !ChatController().isSocketOpen) {
        throw Exception();
      }
      await profileAPI.getProfile();
      await Future.delayed(Duration(milliseconds: 200));
      final response = await _dio.get(
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
    } catch (error) {
      print('${ChatPath.getMessagesLast}: error: $error');
      rethrow;
    }
  }

  Future<RoomModel> getRoomDetail(
      {required String roomId, int page = 0}) async {
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
    } on DioError catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        final RoomModel result = RoomModel.fromJson(data['data']['room']);

        return result;
      } else
        rethrow;
    }
  }
}
