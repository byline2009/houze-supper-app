import 'package:equatable/equatable.dart';

class MessageTextModel extends Equatable {
  final String? imageUrl;
  final String? message;

  MessageTextModel({
    this.imageUrl,
    this.message,
  });

  factory MessageTextModel.fromJson(Map<String, dynamic> json) =>
      MessageTextModel(
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl == null ? null : imageUrl,
        "message": message == null ? null : message,
      };

  @override
  List<Object> get props => [
        imageUrl!,
        message!,
      ];
}
