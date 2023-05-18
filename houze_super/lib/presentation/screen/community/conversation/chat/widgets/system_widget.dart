import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';
import '../models/index.dart';

class MessageTypeSystem extends StatelessWidget {
  final MessageModel message;
  final String roomName;

  const MessageTypeSystem({
    Key key,
    @required this.message,
    @required this.roomName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DateUtil.createAtMessage(
              message.createdAt,
              context: context,
            ),
            style: AppFonts.medium11.copyWith(
              color: Color(0xff9c9c9c),
              fontSize: 11,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            message.getLastMessage(
              roomName,
              context,
            ),
            style: AppFonts.medium.copyWith(color: Color(0xff808080)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
