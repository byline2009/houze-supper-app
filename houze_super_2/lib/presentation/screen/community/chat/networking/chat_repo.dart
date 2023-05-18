import 'package:houze_super/presentation/screen/community/chat/models/last_message_model.dart';
import 'package:houze_super/presentation/screen/community/chat/models/room_model.dart';

import 'chat_api.dart';

class ChatRepository {
  const ChatRepository({
    required this.chatApi,
  });
  final ChatApi chatApi;

  Future<List<LastMessageModel>?> getLastMessages({
    required int page,
    required String buildingID,
  }) async {
    return await chatApi.getLastMessage(
      page: page,
      buildingID: buildingID,
    );
  }

  Future<RoomModel> getMessagesOnRoom({
    required String roomID,
    required int page,
  }) async {
    return await chatApi.getRoomDetail(
      roomId: roomID,
      page: page,
    );
  }
}
