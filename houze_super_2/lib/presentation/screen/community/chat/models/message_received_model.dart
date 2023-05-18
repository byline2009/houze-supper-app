import 'package:equatable/equatable.dart';
import 'index.dart';

class MessageReceivedModel extends Equatable {
  MessageReceivedModel({
    this.id,
    this.type,
    this.parentType,
    this.message = '',
    this.senderUid,
    this.viewer,
    this.createdAt,
    this.user,
  });

  final String? id;
  final String? type;
  final String? parentType;
  final String message;
  final String? senderUid;
  final List<dynamic>? viewer;
  final String? createdAt;
  final UserModel? user;

  factory MessageReceivedModel.fromJson(Map<String, dynamic> json) =>
      MessageReceivedModel(
        id: json["_id"] == null ? null : json["_id"],
        type: json["type"] == null ? null : json["type"],
        parentType: json["parent_type"] == null ? null : json["parent_type"],
        message: json["message"] == null ? null : json["message"],
        senderUid: json["sender_uid"] == null ? null : json["sender_uid"],
        viewer: json["viewer"] == null
            ? null
            : List<dynamic>.from(json["viewer"].map((x) => x)),
        createdAt: json["created_at"] == null ? null : json["created_at"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "type": type == null ? null : type,
        "parent_type": parentType == null ? null : parentType,
        "message": message,
        "sender_uid": senderUid == null ? null : senderUid,
        "viewer":
            viewer == null ? null : List<dynamic>.from(viewer!.map((x) => x)),
        "created_at": createdAt == null ? null : createdAt,
        "user": user == null ? null : user!.toJson(),
      };

  @override
  List<Object> get props => [
        this.id ?? '',
        this.type ?? '',
        this.parentType ?? '',
        this.message,
        this.senderUid ?? '',
        this.viewer ?? '',
        this.createdAt ?? '',
        this.user ?? '',
      ];
}
