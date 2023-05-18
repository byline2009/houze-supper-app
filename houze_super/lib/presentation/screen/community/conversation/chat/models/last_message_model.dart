import 'index.dart';

class LastMessageModel {
  LastMessageModel({
    this.title,
    this.lastMessages,
    this.oneToOne,
    this.user,
    this.lastBadge,
    this.roomId,
    this.users,
  });

  String title;
  LastMessagesItemModel lastMessages;
  bool oneToOne;
  UserModel user;
  bool lastBadge;
  String roomId;
  List<UserModel> users;

  factory LastMessageModel.fromJson(Map<String, dynamic> json) =>
      LastMessageModel(
        title: json["title"] == null ? null : json["title"],
        lastMessages: json["last_messages"] == null
            ? null
            : LastMessagesItemModel.fromJson(json["last_messages"]),
        oneToOne: json["one_to_one"] == null ? null : json["one_to_one"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        lastBadge: json["last_badge"] == null ? null : json["last_badge"],
        roomId: json["room_id"] == null ? null : json["room_id"],
        users: json["users"] == null
            ? null
            : List<UserModel>.from(
                json["users"].map((x) => UserModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "last_messages": lastMessages == null ? null : lastMessages.toJson(),
        "one_to_one": oneToOne == null ? null : oneToOne,
        "user": user == null ? null : user.toJson(),
        "last_badge": lastBadge == null ? null : lastBadge,
        "room_id": roomId == null ? null : roomId,
        "users": users == null ? null : users,
      };
}
