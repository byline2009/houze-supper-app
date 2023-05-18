import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/empty_page.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/bloc/feed/feed_bloc.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/widget_footer.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/index.dart';

class FeedImportantListScreen extends StatefulWidget {
  @override
  _FeedImportantListScreenState createState() =>
      new _FeedImportantListScreenState();
}

class _FeedImportantListScreenState extends State<FeedImportantListScreen> {
  final _feedBloc = FeedBloc();
  ScrollController _scrollController;
  List _listTemp = <FeedMessageModel>[];
  List<FeedMessageModel> _list = <FeedMessageModel>[];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  bool shouldLoadMore = true;
  StreamSubscription subscriptionReadFeed;

  @override
  void initState() {
    super.initState();

    subscriptionReadFeed =
        MailBoxController.eventBus.on<EventReadFeed>().listen((event) {
      handleEventReadFeed(event.feed);
    });
    _scrollController = ScrollController();
  }

  handleEventReadFeed(FeedMessageModel feed) {
    if (mounted) {
      final int index = _list.indexWhere((element) => element.id == feed.id);
      if (index != null && mounted)
        setState(() {
          _list[index] = feed;
        });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    if (subscriptionReadFeed != null) subscriptionReadFeed.cancel();

    super.dispose();
  }

  void _onRefresh() {
    page = 0;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    _feedBloc.add(
      FeedLoadList(
        page: page,
        tags: AppStrings.important,
        limit: AppConstant.limitDefault,
      ),
    );
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  void _onLoading() {
    if (this.shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      _feedBloc.add(FeedLoadList(
          page: page,
          tags: AppStrings.important,
          limit: AppConstant.limitDefault));
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: 'important_news',
      child: BlocProvider<FeedBloc>(
        create: (_) => _feedBloc,
        child: BlocBuilder<FeedBloc, FeedState>(
          builder: (_, FeedState state) {
            if (state is FeedInitial)
              _feedBloc.add(
                FeedLoadList(
                  page: page,
                  tags: AppStrings.important,
                  limit: AppConstant.limitDefault,
                ),
              );

            if (state is FeedLoading && page == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: ListSkeleton(
                  shrinkWrap: true,
                  length: 4,
                  config: SkeletonConfig(
                    theme: SkeletonTheme.Light,
                    isShowAvatar: true,
                    isCircleAvatar: true,
                    bottomLinesCount: 2,
                  ),
                ),
              );
            }

            if (state is FeedFailure &&
                state.error.error is! NoDataToLoadMoreException) {
              if (state.error.error is NoDataException)
                return SomethingWentWrong(true);
              else
                return SomethingWentWrong();
            }

            if (state is MailboxLoadAnnoucementsSuccessful &&
                _listTemp.isEmpty) {
              final List<FeedMessageModel> test = state.result;

              shouldLoadMore = test.length >= 10;
              _listTemp.addAll(test);
              _list.addAll(test.toList());

              if (_list.length == 0) {
                return const EmptyPage(
                    svgPath: AppVectors.ic_notification_empty,
                    content: 'there_is_no_important_announcement');
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
              child: _buildBody(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      cacheExtent: MailboxStyle.heightItem,
      slivers: <SliverList>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => GestureDetector(
              onTap: () {
                AppRouter.navigateToDetailFeed(
                  context: context,
                  feed: _list[index],
                );
              },
              child: WidgetAnnouncementItem(
                data: _list[index],
              ),
            ),
            childCount: _list.length,
          ),
        ),
      ],
    );
  }
}
