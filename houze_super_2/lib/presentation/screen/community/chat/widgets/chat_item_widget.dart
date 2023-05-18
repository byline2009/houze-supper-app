import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/ws/index.dart';
import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/screen/community/chat/index.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/date_util.dart';

import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';

class ChatItemWidget extends StatelessWidget {
  const ChatItemWidget({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final LastMessageModel chat;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        elevation: 0,
        tapTargetSize: MaterialTapTargetSize.padded,
        padding: EdgeInsets.all(0),
      ),
      key: ValueKey(chat.roomId),
      onPressed: () {
        if (ChatController().isSocketOpen &&
            chat.roomId?.isNotEmpty == true &&
            chat.title?.isNotEmpty == true) {
          ChatController().emitEventJoinRoom(
            roomID: chat.roomId!,
            title: chat.title!,
          );
          AppRouter.push(
            context,
            AppRouter.ROOM_CHAT_DETAIL_SCREEN,
            ChatRoomScreenArgument(
              groupRefID: '',
              roomID: chat.roomId!,
              roomName: chat.title!,
              lastMessageModel: chat,
            ),
          );
        }

        //Firebase Analytics
        GetIt.instance<FBAnalytics>()
            .sendEventViewConversation(userID: Storage.getUserID() ?? "");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: <Widget>[
            //Avatar
            GroupChatAvatarWidget(
              user: chat.user ?? UserModel(),
              users: chat.users ?? [],
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
                      chat.title!,
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
                            chat.lastMessages!.getLastMessage(
                              chat.title ?? '',
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
                                chat.lastMessages?.createdAt ?? '',
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
      chat.lastBadge! && // server return true
      chat.lastMessages!.senderUid != Storage.getUserID();
}
