/*
*Screen:
*Chi tiết tin nhắn
*/

import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/ws/index.dart';
import 'package:houze_super/presentation/common_widgets/empty_page.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/chat/models/index.dart';
import 'package:houze_super/presentation/screen/community/chat/widgets/run_constant.dart';

import 'package:houze_super/presentation/screen/community/index.dart';

import '../blocs/index.dart';
import 'chat_input_field.dart';
import 'message_item_widget.dart';
import 'widget_footer.dart';

class BodyChatRoomDetail extends StatefulWidget {
  final String roomID;
  final String groupRefID;

  final String roomName;
  final ProgressHUD progressToolkit;
  const BodyChatRoomDetail({
    Key? key,
    required this.roomID,
    required this.groupRefID,
    required this.roomName,
    required this.progressToolkit,
  }) : super(key: key);

  @override
  _BodyChatRoomDetailState createState() => _BodyChatRoomDetailState();
}

class _BodyChatRoomDetailState extends State<BodyChatRoomDetail>
    with WidgetsBindingObserver {
  final StreamController<ChatImageModel> imageUploadController =
      StreamController<ChatImageModel>.broadcast();
  final _scrollController = ScrollController();
  final _refreshController = RefreshController();
  final _listTemp = <MessageModel>[];
  final _list = <MessageModel>[];
  final focusNode = FocusNode(
    canRequestFocus: true,
  );
  late ChatDetailBloc bloc;
  int _page = 0;
  bool shouldLoadMore = false;
  // String _message = '';
  //RoomID sau khi join room thành công
  String roomIDLocal = '';
  /*Events from chat*/

  //Event nhận về trạng thái Join room thành công
  late StreamSubscription subscriptionJoinIn;

  //Event nhận về trạng thái Socket tự reconnect thành công
  late StreamSubscription subscriptionReConnected;

  //Event nhận về báo Socket bị lỗi
  late StreamSubscription subscriptionSocketDisconnected;

  //Event nhận về Tin nhắn mơi
  late StreamSubscription subscriptionReceivedNewMsg;

  /*Event check network*/
  StreamController<bool> _connectivitySubscription = StreamController();
  late StreamSubscription<ConnectivityResult> _checkNetworkStream;
  final _connectivity = Connectivity();

  /*Variable check status join room*/
  late bool _isJoinRoomSuccess;
  // late ChatImageModel? _imageModel;

  @override
  void initState() {
    super.initState();

    _initVariable();
    _initConnectivity();
    _initListeners();
  }

  void _initVariable() {
    bloc = context.read<ChatDetailBloc>();
    _isJoinRoomSuccess = false;
  }

/*
 * Kiểm tra mạng lần đầu initState
 */
  Future<void> _initConnectivity() async {
    try {
      final ConnectivityResult result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isAndroid && state == AppLifecycleState.resumed) {
      _initConnectivity();
    }
  }

/*
 * Đăng ký lắng nghe các sự kiện
 */
  void _initListeners() {
    // WidgetsBinding.instance.addObserver(this);
    _checkNetworkStream =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    subscriptionSocketDisconnected =
        ChatController.eventBus.on<EventSocketDisconnected>().listen(
      (event) {
        handleEventSocketDisconnected();
      },
    );
    subscriptionReConnected =
        ChatController.eventBus.on<EventReConnected>().listen((event) {
      handleEventReConnected();
    });
    subscriptionJoinIn =
        ChatController.eventBus.on<EventJoinRoom>().listen((event) {
      handleEventJoinInGroup(event.data);
    });

    subscriptionReceivedNewMsg =
        ChatController.eventBus.on<EventReceivedMessage>().listen((event) {
      handleEventReceivedNewMessage(event.messageModel);
      print(
          '[***** ChatController]*** On *** EVENT_MESSAGE_SEND: sender: ${event.messageModel.user?.userFullName} \t New message: "${event.messageModel.message}" \n');
    });
  }

  void checkStatusJoinRoomSuccessful() {
    if (mounted)
      setState(() {
        _isJoinRoomSuccess = ChatController().isSocketOpen;
      });
  }

/*
 * Kiểm tra mạng sau mỗi lần thay đổi kết nối mạng
 */
  void _updateConnectionStatus(ConnectivityResult result) {
    _connectivitySubscription.sink.add(result != ConnectivityResult.none);
  }

/*
Sau khi socket reconnect thành công 
Yêu cầu join room lại
*/
  void handleEventReConnected() {
    if (mounted) {
      /*Trường hợp yêu cầu join room từ màn hình Tin nhắn*/

      if (widget.roomID.isNotEmpty) {
        ChatController().emitEventJoinRoom(
          roomID: widget.roomID,
          title: widget.roomName,
        );
        return;
      }

      /*Trường hợp yêu cầu join room từ GroupID của giải chạy*/

      if (widget.groupRefID.isNotEmpty) {
        ChatController().userRequestJoinRoomFromTeam(
          refID: widget.groupRefID,
          title: widget.roomName,
        );
        return;
      }
    }
  }

/*
Xử lý sự kiện Socket báo lỗi
*/
  void handleEventSocketDisconnected() {
    if (mounted) {
      checkStatusJoinRoomSuccessful();
    }
  }

/*
Xử lý sự kiện Join room thành công
*/
  void handleEventJoinInGroup(JoinRoomModel joinRoom) {
    if (mounted) {
      Future.delayed(Duration.zero, () {
        roomIDLocal = joinRoom.roomId!;

        setState(() {
          _isJoinRoomSuccess = true;
        });

        bloc.add(
          EventChatDetailLoadMessages(
            page: _page,
            roomID: joinRoom.roomId!,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _connectivitySubscription.stream,
      builder: (BuildContext c, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data == false) {
            /*Mất kết nối mạng*/
            return NoInternetPage();
          }
          /*
          *Đã kết nối mạng và đang chờ trạng thái join room thành công            
          */
          if (_isJoinRoomSuccess == false) {
            return Container(
              alignment: Alignment.center,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          return GestureDetector(
            onTap: () {
              if (mounted) {
                focusNode.unfocus();
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: BlocBuilder(
                    bloc: bloc,
                    builder: (ctx, state) {
                      if (state is ChatDetailLoadListFailure) {
                        return SomethingWentWrong();
                      }

                      if (state is ChatOnLoadingState && _page == 0) {
                        return Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                      }

                      if (state is ChatDetailLoadListSuccess &&
                          _listTemp.isEmpty) {
                        final List<MessageModel> test =
                            (state.roomModel.messages!);
                        shouldLoadMore =
                            test.length >= AppConstant.limitMessages;
                        _listTemp.addAll(test);
                        _list.addAll(test.toList());
                        if (_list.length == 0) {
                          return Expanded(
                            child: EmptyPage(
                              content: 'there_is_no_information',
                            ),
                          );
                        }
                      }
                      return SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: MaterialClassicHeader(),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        footer: WidgetFooter(
                          datasource: _list,
                          shouldLoadMore: shouldLoadMore,
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 25,
                            bottom: 0,
                          ),
                          itemCount: _list.length,
                          reverse: true,
                          controller: _scrollController,
                          itemBuilder: (contex, index) {
                            return MessageItemWidget(
                              message: _list[index],
                              roomName: widget.roomName,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                ChatInputField(
                  focusNode: focusNode,
                  roomIDLocal: roomIDLocal,
                  // callback: () {

                  // sendMessageTextType(
                  //   image: _imageModel!,
                  //   message: _message,
                  // );
                  // setState(() {
                  //   _message = '';
                  //   _imageModel = null;
                  // });
                  // },
                  // callbackMessage: (message) {
                  // setState(() {
                  //   _message = message;
                  // });
                  // },
                  // callbackImage: (ChatImageModel? image) {
                  // if (mounted && image != null)
                  //   setState(() {
                  //     _imageModel = image;
                  //   });
                  // },
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return SomethingWentWrong();
          //
        }
        return const SizedBox.shrink();
      },
    );
  }

  bool hasImage(ChatImageModel image) => image.image != null;

  void sendMessageTextType({
    required ChatImageModel image,
    required String message,
  }) {
    if (roomIDLocal.isEmpty) return;
    if (hasImage(image)) {
      if (message.isNotEmpty) {
        ChatController().sendImageTextChat(
          image: image.image!,
          text: message,
          roomID: roomIDLocal,
        );
      } else {
        ChatController().sendImageChat(
          roomID: roomIDLocal,
          imageUrl: image.image!,
        );
      }
    } else {
      ChatController().sendSingleChatMessage(
        message: message,
        roomID: roomIDLocal,
      );
    }
  }

/*
Xử lý sự kiện Nhận tin nhắn mới
*/
  void handleEventReceivedNewMessage(MessageReceivedModel data) {
    if (mounted) {
      MessageModel messageModel = MessageModel(
        id: data.id,
        createdAt: data.createdAt,
        isMe: data.senderUid == Storage.getUserID(),
        message: data.message,
        senderUid: data.senderUid,
        type: data.type,
        user: UserModel.fromJson(
          data.user!.toJson(),
        ),
        viewer: data.viewer?.toList(),
      );
      _list.insert(0, messageModel);
      _list.toSet();
      if (data.senderUid == Storage.getUserID()) {
        _scrollController.animateTo(
          0.0,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }

      setState(() {});
    }
  }

  void _onRefresh() {
    if (roomIDLocal.isNotEmpty) {
      _page = 0;
      _listTemp.clear();
      _list.clear();
      shouldLoadMore = true;

      bloc.add(
        EventChatDetailLoadMessages(
          page: _page,
          roomID: roomIDLocal,
        ),
      );
    }
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  void _onLoading() {
    if (mounted) {
      if (this.shouldLoadMore) {
        if (roomIDLocal.isNotEmpty) {
          this._page++;
          _listTemp.clear();
          bloc.add(
            EventChatDetailLoadMessages(
              page: _page,
              roomID: roomIDLocal,
            ),
          );
        }
      }
      _refreshController.loadComplete();
    }
  }

  void closeSubscription() {
    // WidgetsBinding.instance.removeObserver(this);

    imageUploadController.close();
    subscriptionReConnected.cancel();
    subscriptionSocketDisconnected.cancel();
    _checkNetworkStream.cancel();
    subscriptionJoinIn.cancel();
    subscriptionReceivedNewMsg.cancel();
    _refreshController.dispose();
    _connectivitySubscription.close();
    _scrollController.dispose();
  }

  /*
   * Gửi sự kiện Rời nhóm
   */

  void leaveChatRoom() {
    if (roomIDLocal.isNotEmpty) {
      ChatController().userLeaveChatRoom(
        roomID: roomIDLocal,
        roomName: widget.roomName,
      );
    }
  }

  /*
   * Gửi sự kiện tin nhắn cuối cùng đã đọc
   */
  void readLastMessage() {
    if (_list.length > 0) {
      final messageLast = _list.first;
      if (messageLast.type != RunConstant.kChatTypeSystem &&
          messageLast.senderUid != Storage.getUserID()) {
        if (roomIDLocal.isNotEmpty) {
          ChatController().readChat(
            item: messageLast,
            roomID: roomIDLocal,
          );
        } else {
          ChatController().readChat(
            item: messageLast,
            roomID: widget.roomID,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    readLastMessage();
    leaveChatRoom();
    closeSubscription();
    super.dispose();
  }
}
