import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SocketOnConnectEvent extends ChatEvent {}

class SocketConnectTimeoutEvent extends ChatEvent {
  final dynamic data;

  SocketConnectTimeoutEvent(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'SocketConnectTimeoutEvent { data: $data }';
}

class SocketDisconnectEvent extends ChatEvent {}

class SocketErrorEvent extends ChatEvent {
  final dynamic data;

  SocketErrorEvent(this.data);

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'SocketErrorEvent { data: $data }';
}

class ChatLoadLastMessageList extends ChatEvent {
  const ChatLoadLastMessageList({
    @required this.page,
    @required this.buildingID,
  });
  final String buildingID;

  final int page;

  @override
  List<Object> get props => [page, buildingID];

  @override
  String toString() =>
      'ChatLoadLastMessageList { page: $page buildingID: $buildingID}';
}

class EventChatDetailLoadMessages extends ChatEvent {
  const EventChatDetailLoadMessages({
    @required this.roomID,
    @required this.page,
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
