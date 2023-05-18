import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'index.dart';
import '../models/index.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({@required this.repo})
      : assert(repo != null),
        super(ChatInitialState());
  final ChatRepository repo;
  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatLoadLastMessageList) {
      yield* _mapChatLoadLastMessageListToState(event);
    }
    if (event is EventChatDetailLoadMessages) {
      yield* _mapChatDetailLoadListToState(event);
    }
  }

  Stream<ChatState> _mapChatDetailLoadListToState(
      EventChatDetailLoadMessages event) async* {
    yield ChatOnLoadingState();
    try {
      // final repo = ChatRepository(chatApi: ChatApi());

      final RoomModel result = await repo.getMessagesOnRoom(
        roomID: event.roomID,
        page: event.page,
      );
      yield ChatDetailLoadListSuccess(
        roomModel: result,
      );
    } catch (e) {
      yield ChatDetailLoadListFailure(
        error: e,
      );
    }
  }

  Stream<ChatState> _mapChatLoadLastMessageListToState(
      ChatLoadLastMessageList event) async* {
    yield ChatOnLoadingState();

    try {
      final repo = ChatRepository(
        chatApi: ChatApi(),
      );

      final result = await repo.getLastMessages(
        page: event.page,
        buildingID: event.buildingID,
      );
      yield GetListChatSuccessState(
        elementListModel: result,
      );
    } catch (e) {
      yield GetListChatFailureState(
        error: e,
      );
    }
  }
}
