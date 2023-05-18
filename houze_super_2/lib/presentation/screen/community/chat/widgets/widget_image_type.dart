import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

import 'index.dart';
import '../models/index.dart';

class MessageTypeImage extends StatelessWidget {
  final MessageModel message;
  const MessageTypeImage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        key: Key(message.id!),
        margin: EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 15,
        ),
        decoration: BoxDecoration(
            color: message.isMe ? Color(0xfff5f5f5) : Colors.white,
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
            const SizedBox(height: 5),
            ImageOnMessage(
              image: message.message,
            ),
          ],
        ),
      ),
    );
  }

  Widget text(
    MessageTextModel rs,
  ) =>
      SelectableText(
        rs.message!,
        style: AppFonts.regular14,
        toolbarOptions: ToolbarOptions(
          copy: true,
          selectAll: true,
          cut: false,
          paste: false,
        ),
      );
}
