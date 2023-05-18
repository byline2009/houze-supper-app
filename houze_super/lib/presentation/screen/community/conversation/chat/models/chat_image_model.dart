import 'package:equatable/equatable.dart';

class ChatImageModel extends Equatable {
  ChatImageModel({
    this.createdAt,
    this.id,
    this.image,
    this.imageThumb,
    this.isUsed,
    this.userId,
  });

  final String createdAt;
  final int id;
  final String image;
  final String imageThumb;
  final bool isUsed;
  final String userId;

  factory ChatImageModel.fromJson(Map<String, dynamic> json) => ChatImageModel(
        createdAt: json["created_at"] == null ? null : json["created_at"],
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        imageThumb: json["image_thumb"] == null ? null : json["image_thumb"],
        isUsed: json["is_used"] == null ? null : json["is_used"],
        userId: json["user_id"] == null ? null : json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt == null ? null : createdAt,
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "image_thumb": imageThumb == null ? null : imageThumb,
        "is_used": isUsed == null ? null : isUsed,
        "user_id": userId == null ? null : userId,
      };

  @override
  List<Object> get props => [
        createdAt,
        id,
        image,
        imageThumb,
        isUsed,
        userId,
      ];
}
