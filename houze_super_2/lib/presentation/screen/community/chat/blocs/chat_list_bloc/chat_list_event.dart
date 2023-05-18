import 'package:equatable/equatable.dart';
import 'package:houze_super/utils/index.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override
  List<Object> get props => [];
}

class ChatLoadLastMessageList extends ChatListEvent {
  const ChatLoadLastMessageList({
    required this.page,
    required this.buildingID,
  });
  final String buildingID;
  final int page;

  @override
  List<Object> get props => [page, buildingID];

  @override
  String toString() =>
      'ChatLoadLastMessageList { page: $page buildingID: $buildingID buildingName: ${Sqflite.currentBuilding?.name}}';
}
