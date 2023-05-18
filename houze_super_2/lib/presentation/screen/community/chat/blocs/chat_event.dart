import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class EventChatDetailLoadMessages extends ChatEvent {
  const EventChatDetailLoadMessages({
    required this.roomID,
    required this.page,
  });

  final String roomID;
  final int page;

  @override
  List<Object> get props => [roomID, page];

  @override
  String toString() =>
      'EventChatDetailLoadMessages \t roomID: $roomID \t page:$page';
}

class ChatListUpdateLastMessageEvent extends ChatEvent {
  final dynamic data;

  ChatListUpdateLastMessageEvent({this.data}) : super();

  @override
  String toString() => 'ChatListUpdateLastMessageEvent { data: $data }';
}
