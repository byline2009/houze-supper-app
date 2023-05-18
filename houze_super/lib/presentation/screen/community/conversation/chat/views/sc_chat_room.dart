import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/index.dart';

import '../index.dart';

/*
 * Screen: Tin nhắn chi tiết
 */

class ChatRoomScreenArgument extends Equatable {
  const ChatRoomScreenArgument({
    @required this.roomID,
    @required this.roomName,
    @required this.groupRefID,
    @required this.lastMessageModel,
  });
  final LastMessageModel lastMessageModel;
  final String roomID;
  final String groupRefID;
  final String roomName;

  @override
  List<Object> get props => [
        roomID,
        roomName,
        groupRefID,
      ];
}

class ChatRoomScreen extends StatelessWidget {
  final ChatRoomScreenArgument param;
  const ChatRoomScreen({
    Key key,
    @required this.param,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProgressHUD _progressToolkit = Progress.instanceCreateWithNormal();

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          resizeToAvoidBottomPadding: true,
          appBar: buildAppBar(context),
          body: BlocProvider<ChatBloc>(
            create: (BuildContext context) => ChatBloc(
              repo: ChatRepository(
                chatApi: ChatApi(),
              ),
            ),
            child: BodyChatRoomDetail(
              progressToolkit: _progressToolkit,
              roomID: param.roomID,
              roomName: param.roomName,
              groupRefID: param.groupRefID,
            ),
          ),
        ),
        _progressToolkit
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: null,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(
              10,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Text(
              param.roomName,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.medium18.copyWith(letterSpacing: 0.29),
            ),
          ),
          Positioned(
            left: 2,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                color: Colors.transparent,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          // Positioned(
          //   right: 10,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: Container(
          //       color: Colors.white,
          //       child: IconButton(
          //         padding: const EdgeInsets.all(0),
          //         onPressed: () {
          //           AppRouter.push(
          //             context,
          //             AppRouter.CHAT_ROOM_SETTING_PAGE,
          //             ChatRoomSettingScreenArgument(
          //               roomName: param.roomName,
          //               chat: param.lastMessageModel,
          //             ),
          //           );
          //         },
          //         icon: Icon(
          //           Icons.more_horiz_outlined,
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
