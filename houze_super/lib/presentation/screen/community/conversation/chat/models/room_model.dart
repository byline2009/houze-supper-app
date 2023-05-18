import 'package:equatable/equatable.dart';

import 'index.dart';

class RoomModel extends Equatable {
  RoomModel({
    this.id,
    this.title,
    this.refId,
    this.messages,
    this.createdAt,
    this.userOpposite,
  });

  final String id;
  final String title;
  final String refId;
  final List<MessageModel> messages;
  final String createdAt;
  final UserOppositeModel userOpposite;

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        refId: json["ref_id"] == null ? null : json["ref_id"],
        messages: json["messages"] == null
            ? null
            : List<MessageModel>.from(
                json["messages"].map((x) => MessageModel.fromJson(x))),
        createdAt: json["created_at"] == null ? null : json["created_at"],
        userOpposite: json["user_opposite"] == null
            ? null
            : UserOppositeModel.fromJson(json['user_opposite']),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "ref_id": refId == null ? null : refId,
        "messages": messages == null
            ? null
            : List<MessageModel>.from(messages.map((x) => x.toJson())),
        "created_at": createdAt == null ? null : createdAt,
        "user_opposite": userOpposite == null ? null : userOpposite.toJson(),
      };

  @override
  List<Object> get props => [
        this.id,
        this.title,
        this.refId,
        this.messages,
        this.createdAt,
      ];
}
