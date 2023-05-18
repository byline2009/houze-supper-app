import 'package:equatable/equatable.dart';

class ConnectedSignInModel extends Equatable {
  ConnectedSignInModel({
    this.statusCode,
    this.message,
    this.data,
  });

  final int? statusCode;
  final String? message;
  final ChatLoginModel? data;

  factory ConnectedSignInModel.fromJson(Map<String, dynamic> json) =>
      ConnectedSignInModel(
        statusCode: json["statusCode"] != null ? json["statusCode"] : null,
        message: json["message"] != null ? json["message"] : null,
        data:
            json["data"] != null ? ChatLoginModel.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode != null ? statusCode : null,
        "message": message != null ? message : null,
        "data": data != null ? data!.toJson() : null,
      };

  @override
  List<Object> get props => [
        this.statusCode!,
        this.message!,
        this.data!,
      ];
}

class ChatLoginModel extends Equatable {
  ChatLoginModel({
    this.id,
    this.userId,
    this.fullName,
    this.imageThumb,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? userId;
  final String? fullName;
  final String? imageThumb;
  final String? token;
  final String? createdAt;
  final String? updatedAt;

  static ChatLoginModel fromJson(Map<String, dynamic> json) => ChatLoginModel(
        id: json["id"] != null ? json["id"] : null,
        userId: json["user_id"] != null ? json["user_id"] : null,
        fullName: json["full_name"] != null ? json["full_name"] : null,
        imageThumb: json["image_thumb"] != null ? json["image_thumb"] : null,
        token: json["token"] != null ? json["token"] : null,
        createdAt: json["created_at"] != null ? json["created_at"] : null,
        updatedAt: json["updated_at"] != null ? json["updated_at"] : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "full_name": fullName,
        "image_thumb": imageThumb,
        "token": token,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  @override
  List<Object> get props => [
        this.id ?? '',
        this.userId ?? '',
        this.fullName ?? '',
        this.imageThumb ?? '',
        this.token ?? '',
        this.createdAt ?? '',
        this.updatedAt ?? '',
      ];
}
