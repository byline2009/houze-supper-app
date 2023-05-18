import 'package:flutter/material.dart';

import 'package:houze_super/presentation/screen/base/base_widget.dart';
import '../models/index.dart';
import 'package:houze_super/presentation/screen/community/index.dart';
import 'index.dart';

class MessageItemWidget extends StatelessWidget {
  final MessageModel message;
  final String roomName;
  const MessageItemWidget({
    Key key,
    @required this.message,
    @required this.roomName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.type == RunConstant.kChatTypeSystem)
      return MessageTypeSystem(
        message: message,
        roomName: roomName,
      );

    Widget typeMessageText(MessageModel message) {
      switch (message.type) {
        case RunConstant.kChatTypeText:
          return MessageTypeText(
            message: message,
          );
          break;

        case RunConstant.kChatTypeImage:
          if (message.message.startsWith('https://')) {
            return MessageTypeImage(
              message: message,
            );
          }
          return MessageTypeImageText(
            message: message,
          );
          break;
        default:
          return SizedBox();
      }
    }

    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.senderIsMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            (message.user != null)
                ? BaseWidget.avatar(
                    fullname: message.user.userFullName,
                    size: 28,
                    imageUrl: message.user.userAvatar,
                  )
                : BaseWidget.avatar(
                    size: 28,
                  ),
            const SizedBox(width: 12),
          ],
          typeMessageText(message),
        ],
      ),
    );
  }
}
