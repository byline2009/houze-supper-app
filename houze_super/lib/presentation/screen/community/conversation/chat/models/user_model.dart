import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  UserModel({
    this.notificationOn,
    this.id,
    this.userId,
    this.userFullName,
    this.joinedAt,
    this.readAt,
    this.userAvatar,
  });

  final bool notificationOn;
  final String id;
  final String userId;
  final String userFullName;
  final String joinedAt;
  final String readAt;
  final String userAvatar;

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        notificationOn:
            json["notification_on"] != null ? json["notification_on"] : null,
        id: json["_id"] != null ? json["_id"] : null,
        userId: json["user_id"] != null ? json["user_id"] : null,
        userFullName:
            json["user_full_name"] != null ? json["user_full_name"] : null,
        joinedAt: json["joined_at"] != null ? json["joined_at"] : null,
        readAt: json["read_at"] == null ? null : json["read_at"],
        userAvatar: json["user_avatar"] == null ? null : json["user_avatar"],
      );

  Map<String, dynamic> toJson() => {
        "notification_on": notificationOn == null ? null : notificationOn,
        "_id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "user_full_name": userFullName == null ? null : userFullName,
        "joined_at": joinedAt == null ? null : joinedAt,
        "read_at": readAt == null ? null : readAt,
        "user_avatar": userAvatar == null ? null : userAvatar,
      };

  @override
  List<Object> get props => [
        notificationOn,
        id,
        userId,
        userFullName,
        joinedAt,
        readAt,
        userAvatar,
      ];
}
