import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_no_data.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';

import 'tab_ticket_is_loading.dart';

//---TAB: Phản ánh -> TAB: Đã nhận---//

class TabTicketStatusReceiver extends StatefulWidget {
  final int ticketStatus;

  _TabTicketStatusReceiverState? state;

  TabTicketStatusReceiver({required this.ticketStatus});

  @override
  State<StatefulWidget> createState() {
    state = _TabTicketStatusReceiverState();
    return state!;
  }

  void onRefresh() => state?.onRefresh();
}

class _TabTicketStatusReceiverState extends State<TabTicketStatusReceiver> {
  final feedBloc = FeedBloc();
  final _list = <FeedMessageModel>[];
  final _listTemp = <FeedMessageModel>[];

  int page = 0;
  bool shouldLoadMore = true;

  final _refreshController = RefreshController();
  StreamSubscription? subscriptionReadFeed;

  @override
  void initState() {
    super.initState();
    subscriptionReadFeed =
        MailBoxController.eventBus.on<EventReadFeed>().listen((event) {
      handleEventReadFeed(event.feed);
    });
    // Firebase analytics
    GetIt.instance<FBAnalytics>()
        .sendEventViewReceivedRequest(userID: Storage.getUserID() ?? "");
  }

  handleEventReadFeed(FeedMessageModel feed) {
    int index = _list.indexWhere((element) => element.id == feed.id);
    setState(() {
      _list[index] = feed;
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    if (subscriptionReadFeed != null) subscriptionReadFeed?.cancel();
    super.dispose();
  }

  onRefresh() {
    page = 0;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    feedBloc.add(
      FeedLoadTicketList(page: page, status: widget.ticketStatus),
    );
    _refreshController.refreshCompleted();
  }

  onLoading() {
    if (!mounted) return;
    if (shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      feedBloc.add(FeedLoadTicketList(page: page, status: widget.ticketStatus));
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedBloc>.value(
      value: feedBloc,
      child: BlocBuilder<FeedBloc, FeedState>(
        builder: (BuildContext context, FeedState feedState) {
          if (feedState is FeedInitial) {
            feedBloc.add(
              FeedLoadTicketList(page: 0, status: widget.ticketStatus),
            );
          }
          if (feedState is FeedLoading && page == 0) {
            return TicketIsLoading();
          }

          if (feedState is FeedFailure &&
              feedState.error.error is! NoDataToLoadMoreException) {
            if (feedState.error.error is NoDataException) {
              _refreshController.refreshCompleted();
              return SomethingWentWrong(true);
            } else {
              _refreshController.refreshCompleted();
              return SomethingWentWrong();
            }
          }

          if (feedState is MailboxLoadTicketsSuccessful && _listTemp.isEmpty) {
            List<FeedMessageModel> test = (feedState.result).map((i) {
              return i;
            }).toList();
            shouldLoadMore = test.length >= 10;
            _listTemp.addAll(test);
            _list.addAll(test.toList());
          }

          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: MaterialClassicHeader(
              color: Colors.white,
              backgroundColor: AppColor.purple_5b00e4,
            ),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body = SizedBox.shrink();
                if (shouldLoadMore == false) {
                  mode = LoadStatus.noMore;
                }
                if (mode == LoadStatus.idle || mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  print("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  print("release to load more");
                } else {
                  if (_list.length > 0)
                    body = Text(
                      LocalizationsUtil.of(context)
                          .translate("no_more_information"),
                      style: AppFonts.regular14,
                    );
                }

                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: onRefresh,
            onLoading: onLoading,
            child: _list.isEmpty
                ? WidgetNoData()
                : ListView.builder(
                    itemExtent: MailboxStyle.heightItem,
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: _list.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (c, i) {
                      FeedMessageModel feed = _list[i];
                      return GestureDetector(
                        onTap: () {
                          // Firebase analytics
                          GetIt.instance<FBAnalytics>()
                              .sendEventViewRequestDetail(
                                  userID: Storage.getUserID() ?? "");
                          AppRouter.navigateToDetailFeed(
                            context: context,
                            feed: feed,
                          );
                        },
                        child: WidgetTicketItem(
                          model: feed,
                          status: widget.ticketStatus,
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
