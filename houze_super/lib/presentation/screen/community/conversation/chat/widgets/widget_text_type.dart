import 'package:flutter/material.dart';
// import 'package:linkable/linkable.dart';
import '../models/index.dart';
import 'message_on_chat.dart';
import 'index.dart';

class MessageTypeText extends StatelessWidget {
  final MessageModel message;
  const MessageTypeText({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        key: Key(message.id),
        margin: const EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                  )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SenderSendingMessage(
              message: message,
            ),
            const SizedBox(width: 2),
            MessageOnChat(
              text: message.message,
            ),
          ],
        ),
      ),
    );
  }

  // Widget text() => Linkable(
  //       text: message.message,
  //       style: AppFonts.regular14,
  //     );
}
