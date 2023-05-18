import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/screen/community/conversation/chat/widgets/run_constant.dart';
import 'package:houze_super/utils/localizations_util.dart';

import 'user_model.dart';

class LastMessagesItemModel extends Equatable {
  LastMessagesItemModel({
    this.id,
    this.type,
    this.message,
    this.senderUid,
    this.createdAt,
  });

  final String id;
  final String type;
  final String message;
  final String senderUid;
  final String createdAt;

  factory LastMessagesItemModel.fromJson(Map<String, dynamic> json) =>
      LastMessagesItemModel(
        id: json["_id"] == null ? null : json["_id"],
        type: json["type"] == null ? null : json["type"],
        message: json["message"] == null ? null : json["message"],
        senderUid: json["sender_uid"] == null ? null : json["sender_uid"],
        createdAt: json["created_at"] == null ? null : (json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "type": type == null ? null : type,
        "message": message == null ? null : message,
        "sender_uid": senderUid == null ? null : senderUid,
        "created_at": createdAt == null ? null : createdAt,
      };

  String getLastMessage(
    String roomName,
    BuildContext context,
    UserModel sender,
  ) {
    switch (type) {
      case RunConstant.kChatTypeSystem: // text
        String result = message;

        if (message.contains(RunConstant.kGroupCreated)) {
          result = LocalizationsUtil.of(context).translate('k_group') +
              ' ' +
              roomName +
              ' ' +
              LocalizationsUtil.of(context)
                  .translate('k_group_has_been_created');
        }
        if (message.contains(RunConstant.kUserJoined)) {
          result = message.replaceAll(RunConstant.kUserJoined, '') +
              ' ' +
              LocalizationsUtil.of(context).translate('k_joined_the_group');
        }
        return result;
        break;

      case RunConstant.kChatTypeImage:
        if (senderUid == Storage.getUserID()) {
          return LocalizationsUtil.of(context).translate(
              'k_you_have_sent_a_picture'); //'Bạn đã gửi một hình ảnh'
        }
        if (sender != null) {
          return sender.userFullName +
              ' ' +
              LocalizationsUtil.of(context)
                  .translate('k_someone_have_sent_a_picture');
        } else {
          return LocalizationsUtil.of(context).translate('k_stranger') +
              ' ' +
              LocalizationsUtil.of(context)
                  .translate('k_someone_have_sent_a_picture');
        }
        break;

      default:
        return message;
    }
  }

  @override
  List<Object> get props => [
        this.id,
        this.type,
        this.message,
        this.senderUid,
        this.createdAt,
      ];
}
