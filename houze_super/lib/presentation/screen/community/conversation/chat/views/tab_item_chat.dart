import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/ws/chat_controller.dart';
import 'package:houze_super/middle/ws/index.dart';
import 'package:houze_super/presentation/common_widgets/stateless/empty_page.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/widget_footer.dart';

import 'package:houze_super/utils/index.dart';
import '../index.dart';

/*
 * Tabview: Tin nhắn
 */
class TabItemMessage extends StatefulWidget {
  const TabItemMessage({
    Key key,
    @required this.buildingID,
  }) : super(key: key);
  final String buildingID;
  @override
  _TabItemMessageState createState() => _TabItemMessageState();
}

class _TabItemMessageState extends State<TabItemMessage> {
  List<LastMessageModel> _listTemp;
  List<LastMessageModel> _list;
  ScrollController _scrollController;
  final _refreshController = RefreshController();
  StreamSubscription subscription;

  ChatBloc _chatBloc;
  String chatToken;
  int page;
  bool shouldLoadMore = true;

  StreamSubscription<ConnectivityResult> _checkNetworkStream;
  final _connectivity = Connectivity();
  StreamController<bool> _connectivitySubscription = StreamController();
  StreamSubscription subscriptionReadChat;
  StreamSubscription subscriptionTransportClose;
  StreamSubscription subscriptionReConnected;

  bool _isReconnectSuccesfull;

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
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatBloc = ChatBloc(
      repo: ChatRepository(
        chatApi: ChatApi(),
      ),
    );
  }

  void handleEventReadChat(
    MessageModel chat,
    String roomID,
  ) {
    int index = _list.indexWhere((element) => element.roomId == roomID);
    LastMessageModel lastMessageModel = _list[index];
    if (lastMessageModel.lastBadge &&
        lastMessageModel.lastMessages.senderUid != Storage.getUserID() &&
        chat.id == lastMessageModel.lastMessages.id) {
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
          "[***** ChatController]*** On *** EVENT_MESSAGE_LAST: room: ${newLastMsg.title} \t sender: ${newLastMsg.user.userFullName} \t LastMsg: ${newLastMsg.lastMessages.message}");
    }
  }

  void _moveUp() {
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
      if (subscriptionReConnected != null) subscriptionReConnected.cancel();
      if (subscriptionTransportClose != null)
        subscriptionTransportClose.cancel();
      if (subscriptionReadChat != null) subscriptionReadChat.cancel();
      if (_scrollController != null) _scrollController.dispose();
      if (_refreshController != null) _refreshController.dispose();
      if (subscription != null) subscription.cancel();
      if (_connectivitySubscription != null) _connectivitySubscription.close();
      if (_checkNetworkStream != null) _checkNetworkStream.cancel();
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
          return BlocBuilder<ChatBloc, ChatState>(
            cubit: _chatBloc,
            builder: (context, state) {
              if (state is ChatInitialState && widget.buildingID != null) {
                _chatBloc.add(
                  ChatLoadLastMessageList(
                    buildingID: widget.buildingID,
                    page: page,
                  ),
                );
              }
              if (state is GetListChatFailureState) {
                return SomethingWentWrong(true);
              }
              if (state is ChatOnLoadingState && page == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MessageListLoading(),
                );
              }

              if (state is GetListChatSuccessState && _listTemp.isEmpty) {
                final List<LastMessageModel> test = (state.elementListModel);
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
                  child: _buildBody());
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
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(
            20,
          ),
          sliver: SliverToBoxAdapter(
            child: SearchBoxWidget(
              datasource: _list,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 0,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ChatItemWidget(
                chat: _list[index],
              ),
              childCount: _list.length,
            ),
          ),
        )
      ],
    );
  }
}
