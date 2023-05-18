import 'package:equatable/equatable.dart';

class UserOppositeModel extends Equatable {
  UserOppositeModel({
    this.notificationOn,
    this.id,
    this.userId,
    this.userFullName,
    this.joinedAt,
    this.readAt,
  });

  final bool? notificationOn;
  final String? id;
  final String? userId;
  final String? userFullName;
  final String? joinedAt;
  final String? readAt;

  factory UserOppositeModel.fromJson(Map<String, dynamic> json) =>
      UserOppositeModel(
        notificationOn:
            json["notification_on"] == null ? null : json["notification_on"],
        id: json["_id"] == null ? null : json["_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        userFullName:
            json["user_full_name"] == null ? null : json["user_full_name"],
        joinedAt: json["joined_at"] == null ? null : json["joined_at"],
        readAt: json["read_at"] == null ? null : json["read_at"],
      );

  Map<String, dynamic> toJson() => {
        "notification_on": notificationOn == null ? null : notificationOn,
        "_id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "user_full_name": userFullName == null ? null : userFullName,
        "joined_at": joinedAt == null ? null : joinedAt,
        "read_at": readAt == null ? null : readAt,
      };

  @override
  List<Object> get props => [
        this.notificationOn!,
        this.id!,
        this.userId!,
        this.userFullName!,
        this.joinedAt!,
        this.readAt!,
      ];
}
