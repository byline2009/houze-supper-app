import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/chat/models/index.dart';

abstract class SocketEvent extends Equatable {
  const SocketEvent();
  @override
  List<Object> get props => [];
}

class EventReceivedMessage extends SocketEvent {
  final MessageReceivedModel messageModel;
  EventReceivedMessage({
    required this.messageModel,
  });
  @override
  List<Object> get props => [
        messageModel,
      ];
}

class EventLoadNewLastMessage extends SocketEvent {
  final LastMessageModel data;
  const EventLoadNewLastMessage(
    this.data,
  );
  @override
  List<Object> get props => [
        data,
      ];
}

class EventJoinRoom extends SocketEvent {
  final JoinRoomModel data;
  const EventJoinRoom(this.data);
  @override
  List<Object> get props => [
        data,
      ];
}

class EventReConnected extends SocketEvent {
  EventReConnected({
    required this.isConnected,
  });
  final bool isConnected;
  @override
  List<Object> get props => [isConnected];
}

class EventSocketDisconnected extends SocketEvent {
  final String reason;
  const EventSocketDisconnected({
    required this.reason,
  });
  @override
  List<Object> get props => [
        reason,
      ];
}

class EventReadChat extends SocketEvent {
  final MessageModel item;
  final String roomID;
  const EventReadChat({
    required this.item,
    required this.roomID,
  });
  @override
  List<Object> get props => [
        item,
        roomID,
      ];
}
