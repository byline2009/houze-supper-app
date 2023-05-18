import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/presentation/common_widgets/empty_page.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';

import '../../../../base/route_aware_state.dart';

class FeedImportantListScreen extends StatefulWidget {
  @override
  _FeedImportantListScreenState createState() =>
      new _FeedImportantListScreenState();
}

class _FeedImportantListScreenState extends RouteAwareState<FeedImportantListScreen> {
  final _feedBloc = FeedBloc();
  late ScrollController _scrollController;
  var _listTemp = <FeedMessageModel>[];
  var _list = <FeedMessageModel>[];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
  bool shouldLoadMore = true;
  late StreamSubscription? subscriptionReadFeed;

  @override
  void initState() {
    super.initState();
    //Firebase Analytics
    GetIt.instance<FBAnalytics>()
        .sendEventViewImportantNewsList(userID: Storage.getUserID() ?? "");
    subscriptionReadFeed =
        MailBoxController.eventBus.on<EventReadFeed>().listen((event) {
      handleEventReadFeed(event.feed);
    });
    _scrollController = ScrollController();
  }

  handleEventReadFeed(FeedMessageModel feed) {
    if (mounted) {
      int index = _list.indexWhere((element) => element.id == feed.id);
      if (index != -1)
        setState(() {
          _list[index] = feed;
        });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    if (subscriptionReadFeed != null) subscriptionReadFeed?.cancel();

    super.dispose();
  }

  void _onRefresh() {
    page = 0;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    _feedBloc.add(FeedLoadList(
      page: page,
      tags: AppStrings.important,
      limit: AppConstant.limitDefault,
      buildingID: Sqflite.currentBuildingID,
    ));
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  void _onLoading() {
    if (this.shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      _feedBloc.add(FeedLoadList(
          buildingID: Sqflite.currentBuildingID,
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
      child: Container(
        color: Colors.white,
        child: BlocProvider<FeedBloc>(
          create: (_) => _feedBloc,
          child: BlocBuilder<FeedBloc, FeedState>(
            builder: (_, FeedState state) {
              if (state is FeedInitial)
                _feedBloc.add(FeedLoadList(
                    page: page,
                    buildingID: Sqflite.currentBuildingID,
                    tags: AppStrings.important,
                    limit: AppConstant.limitDefault));

              if (state is FeedLoading && page == 0) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget? body;
                    if (shouldLoadMore == false) {
                      mode = LoadStatus.noMore;
                    }

                    if (mode == LoadStatus.idle || mode == LoadStatus.loading) {
                      body = CupertinoActivityIndicator();
                    } else {
                      if (_list.length > 0)
                        body = Text(
                          LocalizationsUtil.of(context)
                              .translate("no_more_information"),
                          style: AppFonts.regular14,
                        );
                    }
                    return Container(height: 80, child: Center(child: body));
                  },
                ),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        //Firebase Analytics
                        GetIt.instance<FBAnalytics>()
                            .sendEventViewImportantNews(
                                userID: Storage.getUserID() ?? "");
                        AppRouter.navigateToDetailFeed(
                          context: context,
                          feed: _list[index],
                        );
                      },
                      child: WidgetAnnouncementItem(
                        data: _list[index],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
