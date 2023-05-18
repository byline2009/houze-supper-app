import 'package:flutter/material.dart';
import '../models/index.dart';
import 'index.dart';

class ChatRepository {
  const ChatRepository({
    @required this.chatApi,
  });
  final ChatApi chatApi;

  Future<List<LastMessageModel>> getLastMessages({
    @required int page,
    @required String buildingID,
  }) async {
    final response = await chatApi.getLastMessages(
      page: page,
      buildingID: buildingID,
    );
    if (response != null) return response;
    return null;
  }

  Future<RoomModel> getMessagesOnRoom({
    @required String roomID,
    @required int page,
  }) async {
    final response = await chatApi.getRoomDetail(
      roomId: roomID,
      page: page,
    );
    if (response != null) return response;
    return null;
  }
}
