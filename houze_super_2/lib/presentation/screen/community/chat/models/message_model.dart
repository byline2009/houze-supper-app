import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/screen/community/chat/models/user_model.dart';
import 'package:houze_super/presentation/screen/community/chat/widgets/run_constant.dart';
import 'package:houze_super/utils/localizations_util.dart';

class MessageModel extends Equatable {
  MessageModel({
    this.id,
    this.type,
    this.message = '',
    this.senderUid,
    this.viewer,
    this.createdAt,
    this.isMe = false,
    this.user,
  });

  final String? id;
  final String? type;
  final String message;
  final String? senderUid;
  final List<dynamic>? viewer;
  final String? createdAt;
  final bool isMe;
  final UserModel? user;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["_id"] == null ? null : json["_id"],
        type: json["type"] == null ? null : json["type"],
        message: json["message"] == null ? null : json["message"],
        senderUid: json["sender_uid"] == null ? null : json["sender_uid"],
        viewer: json["viewer"] == null
            ? null
            : List<dynamic>.from(json["viewer"].map((x) => x)),
        createdAt: json["created_at"] == null ? null : json["created_at"],
        isMe: json["is_me"] == null ? null : json["is_me"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "type": type == null ? null : type,
        "message":  message,
        "sender_uid": senderUid == null ? null : senderUid,
        "viewer":
            viewer == null ? null : List<dynamic>.from(viewer!.map((x) => x)),
        "created_at": createdAt == null ? null : createdAt,
        "is_me": isMe,
        "user": user == null ? null : user!.toJson(),
      };

  String getLastMessage(
    String roomName,
    BuildContext context,
  ) {
    if (type == RunConstant.kChatTypeSystem) {
      String result = message;

      if (message.contains(RunConstant.kGroupCreated)) {
        // result = 'Nhóm $roomName đã được tạo';
        result = LocalizationsUtil.of(context).translate('k_group') +
            ' ' +
            roomName +
            ' ' +
            LocalizationsUtil.of(context).translate('k_group_has_been_created');
      }
      if (message.contains(RunConstant.kUserJoined)) {
        result = message.replaceAll(RunConstant.kUserJoined, '') +
            ' ' +
            LocalizationsUtil.of(context).translate('k_joined_the_group');
      }
      return result;
    }
    return message;
  }

  bool get senderIsMe => isMe || senderUid == Storage.getUserID();
  @override
  List<Object> get props => [
        this.id ?? '',
        this.type ?? '',
        this.message,
        this.senderUid ?? '',
        this.viewer ?? '',
        this.createdAt ?? '',
        this.isMe,
      ];
}
