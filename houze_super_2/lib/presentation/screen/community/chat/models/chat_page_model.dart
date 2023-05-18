import 'package:equatable/equatable.dart';

import 'index.dart';

class ChatPageModel extends Equatable {
  const ChatPageModel({
    this.room,
  });

  final RoomModel? room;

  factory ChatPageModel.fromJson(Map<String, dynamic> json) => ChatPageModel(
        room: json["room"] == null ? null : RoomModel.fromJson(json["room"]),
      );

  Map<String, dynamic> toJson() => {
        "room": room == null ? null : room!.toJson(),
      };
  @override
  List<Object> get props => [room!];
}
