import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/pull_to_refresh.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_no_data.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/bloc/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/widget_ticket_item.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

import 'bloc/mailbox_controller.dart';
import 'tab_ticket_is_loading.dart';
import 'widget_footer.dart';

//---TAB: Phản ánh -> TAB: Đã nhận---//

class TabTicketStatusReceiver extends StatefulWidget {
  final int ticketStatus;

  _TabTicketStatusReceiverState state;

  TabTicketStatusReceiver({
    @required this.ticketStatus,
  });

  @override
  State<StatefulWidget> createState() {
    state = _TabTicketStatusReceiverState();
    return state;
  }

  void onRefresh() => state?.onRefresh();
}

class _TabTicketStatusReceiverState extends State<TabTicketStatusReceiver> {
  final FeedBloc feedBloc = FeedBloc();
  final _list = <FeedMessageModel>[];
  final _listTemp = <FeedMessageModel>[];

  int page = 0;
  bool shouldLoadMore = true;

  final _refreshController = RefreshController();
  StreamSubscription subscriptionReadFeed;

  @override
  void initState() {
    super.initState();
    subscriptionReadFeed =
        MailBoxController.eventBus.on<EventReadFeed>().listen((event) {
      if (mounted) handleEventReadFeed(event.feed);
    });
  }

  handleEventReadFeed(FeedMessageModel feed) {
    int index = _list.indexWhere((element) => element.id == feed.id);

    setState(() {
      _list[index] = feed;
    });
  }

  @override
  void dispose() {
    if (_refreshController != null) _refreshController.dispose();
    if (subscriptionReadFeed != null) subscriptionReadFeed.cancel();
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
    if (shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      feedBloc.add(FeedLoadTicketList(page: page, status: widget.ticketStatus));
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeedBloc>(
      create: (_) => feedBloc,
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
              backgroundColor: Color(0xff5b00e4),
            ),
            controller: _refreshController,
            onRefresh: onRefresh,
            onLoading: onLoading,
            child: _list.length == 0 || _list.isEmpty
                ? WidgetNoData()
                : CustomScrollView(
                    key: PageStorageKey<String>('TabTicketStatusReceiver'),
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverFixedExtentList(
                        itemExtent: MailboxStyle.heightItem,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            FeedMessageModel feed = _list[index];
                            return GestureDetector(
                              child: WidgetTicketItem(
                                model: feed,
                                status: widget.ticketStatus,
                              ),
                              onTap: () {
																// KEVTODO: /t/1quthdr
                                AppRouter.navigateToDetailFeed(
                                  context: context,
                                  feed: feed,
                                );
                              },
                            );
                          },
                          childCount: _list.length,
                        ),
                      ),
                    ],
                  ),
            footer: WidgetFooter(
              datasource: _list,
              shouldLoadMore: shouldLoadMore,
            ),
          );
        },
      ),
    );
  }
}
