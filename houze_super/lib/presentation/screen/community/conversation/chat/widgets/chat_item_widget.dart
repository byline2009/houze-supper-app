import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/ws/index.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/chat/models/index.dart';

import 'index.dart';
import '../views/index.dart';

class ChatItemWidget extends StatelessWidget {
  const ChatItemWidget({
    Key key,
    @required this.chat,
  }) : super(key: key);

  final LastMessageModel chat;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey(chat.roomId),
      onTap: () async {
        if (chat != null &&
            ChatController().isSocketOpen &&
            !StringUtil.isEmpty(chat.roomId) &&
            !StringUtil.isEmpty(chat.title)) {
          await ChatController().emitEventJoinRoom(
            roomID: chat.roomId,
            title: chat.title,
          );
          AppRouter.push(
            context,
            AppRouter.ROOM_CHAT_DETAIL_PAGE,
            ChatRoomScreenArgument(
              groupRefID: null,
              roomID: chat.roomId,
              roomName: chat.title,
              lastMessageModel: chat,
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: <Widget>[
            //Avatar
            GroupChatAvatarWidget(
              user: chat.user,
              users: chat.users,
            ),

            const SizedBox(width: 10),
            //Message
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      chat.title,
                      style: isUnreadMessage
                          ? AppFonts.bold15
                          : AppFonts.regular15,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            chat.lastMessages.getLastMessage(
                              chat.title,
                              context,
                              chat.user,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: isUnreadMessage
                                ? AppFonts.semibold13
                                : AppFonts.regular13.copyWith(
                                    color: Color(0xff838383),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        //Time
                        Expanded(
                          child: Text(
                              DateUtil.convertLastMessageTime(
                                chat.lastMessages.createdAt,
                                context: context,
                              ),
                              textAlign: TextAlign.end,
                              style: AppFonts.regular13.copyWith(
                                color: Color(0xff838383),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isUnreadMessage =>
      chat.lastBadge && // server return true
      chat.lastMessages.senderUid != Storage.getUserID();
}
