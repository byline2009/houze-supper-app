import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/blocs/index.dart';

import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/ws/index.dart';
import 'package:houze_super/presentation/common_widgets/empty_page.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/chat/blocs/chat_list_bloc/index.dart';
import 'package:houze_super/presentation/screen/community/chat/widgets/widget_footer.dart';
import 'package:houze_super/presentation/screen/community/index.dart';

import '../index.dart';

/*
 * Tabview: Tin nhắn
 */

class MessageTabItem extends StatelessWidget {
  const MessageTabItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String buildingID = context.select((OverlayBloc bloc) =>
        (bloc.state is PickBuildingSuccessful)
            ? (bloc.state as PickBuildingSuccessful).currentBuilding.id!
            : Sqflite.currentBuildingID);
    return BlocProvider(
      create: (context) => ChatListBloc(
        repo: ChatRepository(
          chatApi: ChatApi(dio: Dio()),
        ),
      ),
      child: _MessageList(
        buildingID: buildingID,
      ),
    );
  }
}

class _MessageList extends StatefulWidget {
  const _MessageList({
    Key? key,
    required this.buildingID,
  }) : super(key: key);
  final String buildingID;
  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  List<LastMessageModel> _listTemp = [];
  List<LastMessageModel> _list = [];
  late ScrollController _scrollController;
  final _refreshController = RefreshController();
  late StreamSubscription subscription;

  late ChatListBloc _chatBloc;
  late String chatToken = '';
  int page = 0;
  bool shouldLoadMore = true;

  late StreamSubscription<ConnectivityResult> _checkNetworkStream;
  final _connectivity = Connectivity();
  StreamController<bool> _connectivitySubscription = StreamController();
  late StreamSubscription subscriptionReadChat;
  late StreamSubscription subscriptionTransportClose;
  late StreamSubscription subscriptionReConnected;

  bool _isReconnectSuccesfull = false;

  @override
  void initState() {
    super.initState();

    _initVariable();
    _initListeners();
    _initConnectivity();
  }

  _initListeners() {
    if (mounted) {
      /*Nhận tin nhắn cuối cùng đọc được từ roomID*/

      subscriptionReadChat =
          ChatController.eventBus.on<EventReadChat>().listen((event) {
        handleEventReadChat(
          event.item,
          event.roomID,
        );
      });

      /*Kiểm tra trạng thái socket bị disconnected*/
      subscriptionTransportClose =
          ChatController.eventBus.on<EventSocketDisconnected>().listen(
        (event) {
          handleEventSocketDisconnected();
        },
      );

      /*Kiểm tra trạng thái socket đã reconnect thành công sau khi disconnected*/
      subscriptionReConnected =
          ChatController.eventBus.on<EventReConnected>().listen((event) {
        handleEventReConnected();
      });

      /*Nhận sự kiện có new last message*/

      subscription =
          ChatController.eventBus.on<EventLoadNewLastMessage>().listen((event) {
        handleNewLastMessgae(
          event.data,
        );
      });

      _checkNetworkStream = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
      );
    }
  }

  void _initVariable() {
    _chatBloc = BlocProvider.of<ChatListBloc>(context);
    _isReconnectSuccesfull = ChatController().isSocketOpen;
    chatToken = Storage.getChatToken();
    page = 0;
    _list = [];
    _listTemp = [];
    _scrollController = ScrollController();
  }

  void handleEventSocketDisconnected() {
    checkStatusReconnectSuccessful();
  }

  void checkStatusReconnectSuccessful() {
    if (mounted) {
      setState(() {
        _isReconnectSuccesfull = ChatController().isSocketOpen;
      });
    }
  }

  Future<void> _initConnectivity() async {
    try {
      ConnectivityResult result = await _connectivity.checkConnectivity();
      return _updateConnectionStatus(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    try {
      _isReconnectSuccesfull = ChatController().isSocketOpen;

      bool _isConnected = result != ConnectivityResult.none;
      if (_isConnected) {
        if (_list.length == 0) {
          _chatBloc.add(
            ChatLoadLastMessageList(
              buildingID: widget.buildingID,
              page: page,
            ),
          );
        }
      }
      _connectivitySubscription.sink.add(_isConnected);
    } catch (error) {
      print(error.toString());
    }
  }

  void handleEventReadChat(
    MessageModel chat,
    String roomID,
  ) {
    int index = _list.indexWhere((element) => element.roomId == roomID);
    LastMessageModel lastMessageModel = _list[index];
    if (lastMessageModel.lastBadge! &&
        lastMessageModel.lastMessages!.senderUid != Storage.getUserID() &&
        chat.id == lastMessageModel.lastMessages!.id) {
      lastMessageModel.lastBadge = false;
      if (mounted) {
        setState(() {
          _list[index] = lastMessageModel;
        });
      }
    }
  }

  void handleEventReConnected() {
    _chatBloc.add(
      ChatLoadLastMessageList(
        buildingID: widget.buildingID,
        page: page,
      ),
    );
    checkStatusReconnectSuccessful();
  }

  void handleNewLastMessgae(LastMessageModel newLastMsg) {
    if (mounted) {
      if (_list.length >= 2) {
        _list.removeWhere((element) => element.roomId == newLastMsg.roomId);
        _list.insert(0, newLastMsg);
        _moveUp();
      } else {
        _list.clear();
        _list.add(newLastMsg);
      }
      setState(() {});
      print(
          "[***** ChatController]*** On *** EVENT_MESSAGE_LAST: room: ${newLastMsg.title} \t sender: ${newLastMsg.user?.userFullName} \t LastMsg: ${newLastMsg.lastMessages?.message}");
    }
  }

  void _moveUp() {
    if (mounted)
      _scrollController.animateTo(
        0.0,
        curve: Curves.ease,
        duration: Duration(
          milliseconds: 300,
        ),
      );
  }

  void _onRefresh() {
    page = 0;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    _chatBloc.add(
      ChatLoadLastMessageList(
        buildingID: widget.buildingID,
        page: page,
      ),
    );
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    if (mounted) {
      if (shouldLoadMore) {
        this.page++;
        _listTemp.clear();
        _chatBloc.add(
          ChatLoadLastMessageList(
            buildingID: widget.buildingID,
            page: page,
          ),
        );
      }
      _refreshController.loadComplete();
    }
  }

  @override
  void dispose() {
    if (mounted) {
      subscriptionReConnected.cancel();
      subscriptionTransportClose.cancel();
      subscriptionReadChat.cancel();
      _scrollController.dispose();
      _refreshController.dispose();
      subscription.cancel();
      _connectivitySubscription.close();
      _checkNetworkStream.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _connectivitySubscription.stream,
      builder: (BuildContext c, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data == false) {
            return NoInternetPage();
          }
          if (_isReconnectSuccesfull == false) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MessageListLoading(),
            );
          }
          return BlocBuilder<ChatListBloc, ChatListState>(
            bloc: _chatBloc,
            builder: (context, state) {
              if (state.status == ChatListStatus.initial) {
                _chatBloc.add(
                  ChatLoadLastMessageList(
                    buildingID: widget.buildingID,
                    page: page,
                  ),
                );
              }
              if (state.status == ChatListStatus.failure) {
                return SomethingWentWrong();
              }
              if (state.status == ChatListStatus.loading && page == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MessageListLoading(),
                );
              }

              if (state.status == ChatListStatus.success && _listTemp.isEmpty) {
                final List<LastMessageModel> test = (state.result);
                shouldLoadMore = test.length >= AppConstant.limitDefault;
                _listTemp.addAll(test);
                _list.addAll(test.toList());
                if (_list.length == 0) {
                  return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: MaterialClassicHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: EmptyPage(
                      svgPath: AppVectors.icChatLight,
                      content: 'k_there_are_currently_no_chat_groups',
                      width: 60,
                      height: 60,
                    ),
                  );
                }
              }

              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(),
                controller: _refreshController,
                onRefresh: snapshot.data ? _onRefresh : null,
                onLoading: snapshot.data ? _onLoading : null,
                footer: WidgetFooter(
                  datasource: _list,
                  shouldLoadMore: shouldLoadMore,
                ),
                child: _buildBody(),
              );
            },
          );
        }
        if (snapshot.hasError) return SomethingWentWrong();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: MessageListLoading(),
        );
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.all(20),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SearchBoxWidget(
            datasource: _list,
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 20),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _list.length,
            itemBuilder: (c, index) => ChatItemWidget(
              chat: _list[index],
            ),
          )
        ],
      ),
    );
  }
}
