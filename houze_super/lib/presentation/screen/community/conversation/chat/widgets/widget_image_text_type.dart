import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/index.dart';
import 'index.dart';

class MessageTypeImageText extends StatelessWidget {
  final MessageModel message;
  const MessageTypeImageText({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MessageTextModel rs;
    if (message.message is String) {
      final Map<String, dynamic> data = json.decode(message.message);
      rs = MessageTextModel.fromJson(data);
    }
    return Flexible(
      child: Container(
        key: Key(message.id),
        margin:const EdgeInsets.only(bottom: 25),
        padding:const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          color: message.senderIsMe ? Color(0xfff5f5f5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: message.isMe
              ? Border.all(
                  width: 0,
                  style: BorderStyle.none,
                )
              : Border.all(
                  color: Color(0xffd0d0d0),
                  width: 1,
                  style: BorderStyle.solid,
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SenderSendingMessage(
              message: message,
            ),
            const SizedBox(height: 2),
            MessageOnChat(
              text: rs.message,
            ),
            const SizedBox(
              height: 10,
            ),
            ImageOnMessage(
              image: rs.imageUrl,
            ),
          ],
        ),
      ),
    );
  }
}
