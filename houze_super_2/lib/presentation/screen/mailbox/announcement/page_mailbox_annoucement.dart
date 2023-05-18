import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/api/feed_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/middle/model/token_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_no_data.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/chat/widgets/widget_footer.dart';

import 'package:houze_super/utils/constant/share_keys.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';
import 'package:jose/jose.dart';

import 'bloc/announcement_bloc.dart';

/*Thông báo Page */
class TabViewFeed extends StatefulWidget {
  _TabViewFeedState? state;

  @override
  State<StatefulWidget> createState() {
    state = _TabViewFeedState();
    return state!;
  }

  void onRefresh() => state!.onRefresh();
}

const String kFilterTag = 'tag';
const String kFilterType = 'type';
const String kFilterDate = 'date';

class _TabViewFeedState extends State<TabViewFeed> {
  //with AutomaticKeepAliveClientMixin<TabViewFeed>, TickerProviderStateMixin {
  final ftype = DropdownWidgetController();
  final fdate = DropdownWidgetController();
  List dataSourceType = <KeyValueModel>[];
  final dataSourceFdate = <KeyValueModel>[];

  final controlFilter = {kFilterTag: '', kFilterDate: '', kFilterType: ''};
  // Bloc create
  bool _didTap = true;
  final StreamController<int> _tabFeedController = StreamController.broadcast();
  late final AnnouncementBloc _announcementBloc;

  final _listTemp = <FeedMessageModel>[];
  List _list = <FeedMessageModel>[];
  int page = 0;
  final _refreshController = RefreshController();
  bool shouldLoadMore = false;
  late int _currentTabFilter = 0;
  late StreamSubscription subscriptionReadFeed;

  final category = ["all", "unread"];
  final feedAPI = FeedAPI();
  bool _hasNoData = false;

  @override
  void initState() {
    super.initState();
    _initDataSourceTime();
    controlFilter[kFilterType] = (controlFilter[kFilterType] == ''
        ? filterAllType
        : controlFilter[kFilterType])!;

    subscriptionReadFeed =
        MailBoxController.eventBus.on<EventReadFeed>().listen((event) {
      handleEventReadFeed(event.feed);
    });

    _announcementBloc = BlocProvider.of<AnnouncementBloc>(context);
    _tabFeedController.stream.listen((newIndexTab) {
      if (_currentTabFilter != newIndexTab) {
        _currentTabFilter = newIndexTab;

        _announcementBloc.add(
          AnnouncementFetched(
            page: page,
            type: controlFilter[kFilterType]!,
            time: controlFilter[kFilterDate]!,
            buildingID: Sqflite.currentBuildingID,
            tag: controlFilter[kFilterTag]!,
            isRead: _currentTabFilter == 0 ? null : false,
          ),
        );

        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
      }
    });

    _announcementBloc.add(
      AnnouncementFetched(
        page: page,
        type: controlFilter[kFilterType]!,
        time: controlFilter[kFilterDate]!,
        buildingID: Sqflite.currentBuildingID,
        tag: controlFilter[kFilterTag]!,
        isRead: _currentTabFilter == 0 ? null : false,
      ),
    );
  }

  void handleEventReadFeed(FeedMessageModel feed) {
    int index = _list.indexOf(feed);
    if (_currentTabFilter == 0) {
      //TabView: Tất cả
      if (!mounted) return;
      setState(() {
        _list[index] = feed;
      });
    } else {
      //TabView: Chưa đọc
      final newList = List.from(_list)..removeAt(index);
      if (!mounted) return;
      setState(() {
        _list = newList;
      });
    }
  }

  void _clearData() {
    page = 0;
    _listTemp.clear();
    _list.clear();
  }

  void onRefresh() {
    _clearData();
    shouldLoadMore = true;
    controlFilter[kFilterType] = (controlFilter[kFilterType] == ''
        ? filterAllType
        : controlFilter[kFilterType])!;

    _announcementBloc.add(
      AnnouncementFetched(
        page: page,
        type: controlFilter[kFilterType]!,
        time: controlFilter[kFilterDate]!,
        buildingID: Sqflite.currentBuildingID,
        tag: controlFilter[kFilterTag]!,
        isRead: _currentTabFilter == 0 ? null : false,
      ),
    );

    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  void onLoading() {
    if (shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      _announcementBloc.add(AnnouncementFetched(
        page: page,
        type: controlFilter[kFilterType]!,
        time: controlFilter[kFilterDate]!,
        buildingID: Sqflite.currentBuildingID,
        tag: controlFilter[kFilterTag]!,
        isRead: _currentTabFilter == 0 ? null : false,
      ));
    }
    _refreshController.loadComplete();
  }

  void _initDataSourceTime() {
    DateTime today = DateTime.now();

    var _month = today.month;
    var _year = today.year;
    for (var i = 0; i < 12; ++i) {
      if (_month <= 0) {
        _year--;
        _month = 12;
      }

      dataSourceFdate.add(
        KeyValueModel(
            key: "${_year.toString()}-$_month",
            value: '$_month/${_year.toString()}'),
      );
      _month--;
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    if (dataSourceType.length == 0)
      dataSourceType = [
        KeyValueModel(
            key: "type:announcement",
            value: LocalizationsUtil.of(context).translate('announcement')),
        KeyValueModel(
            key: "type:announcement",
            value: LocalizationsUtil.of(context)
                .translate(ShareKeys.kImportantAnnouncement)),
        KeyValueModel(
            key: "type:facility_booking",
            value: LocalizationsUtil.of(context).translate('facility_booking')),
        KeyValueModel(
            key: "type:fee_sent",
            value: LocalizationsUtil.of(context).translate('announcement_fee')),
        KeyValueModel(
            key: "type:receipt_sent",
            value: LocalizationsUtil.of(context).translate('receipt_paid')),
      ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildFilter(),
        const SizedBox(height: 20),
        Expanded(
          child: contentList(),
        ),
      ],
    );
  }

/*Build result list when filter by type annoucement and time*/
  Widget contentList() {
    return BlocConsumer<AnnouncementBloc, AnnouncementState>(
      listener: (context, feedState) {
        if (feedState.status == FeedStatus.failure) {
          _refreshController.refreshCompleted();
        }
        if (feedState.status == FeedStatus.success && _listTemp.length == 0) {
          final List<FeedMessageModel> test = feedState.feeds;
          shouldLoadMore = test.length >= AppConstant.limitDefault;
          _listTemp.addAll(test);
          _list.addAll(test.toList());
          if (_list.length == 0) {
            setState(() {
              this._hasNoData = true;
            });
          } else {
            setState(() {
              this._hasNoData = false;
            });
          }
        }
      },
      builder: (context, state) {
        return BlocBuilder<AnnouncementBloc, AnnouncementState>(
          builder: (context, feedState) {
            return Scrollbar(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(),
                onRefresh: onRefresh,
                onLoading: onLoading,
                footer: WidgetFooter(
                  datasource: _list,
                  shouldLoadMore: shouldLoadMore,
                ),
                child: CustomScrollView(
                  key: PageStorageKey<String>('TabViewFeed'),
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    _allAndUnreadFilter(),
                    if (feedState.status == FeedStatus.loading && page == 0)
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverToBoxAdapter(
                          child: ListSkeleton(
                            length: 4,
                            shrinkWrap: true,
                            config: SkeletonConfig(
                              isCircleAvatar: true,
                              isShowAvatar: true,
                              theme: SkeletonTheme.Light,
                              bottomLinesCount: 2,
                            ),
                          ),
                        ),
                      ),
                    if (_list.length > 0)
                      SliverFixedExtentList(
                        itemExtent: MailboxStyle.heightItem,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final feed = _list[index];
                            return AbsorbPointer(
                              absorbing:
                                  !this._didTap, //prevent multiple tapping
                              child: GestureDetector(
                                child: WidgetAnnouncementItem(
                                  data: feed,
                                ),
                                onTap: () {
                                  if (!mounted) return;
                                  setState(() {
                                    this._didTap = false;
                                  });
                                  AppRouter.navigateToDetailFeed(
                                    context: context,
                                    feed: feed,
                                  );
                                  this._didTap = true;
                                },
                              ),
                            );
                          },
                          childCount: _list.length,
                        ),
                      ),
                    if (this._hasNoData)
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 110.0),
                        child: WidgetNoData(),
                      )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /* Build filter: All & Unread */
  Widget _allAndUnreadFilter() {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 15.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: category
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: StreamBuilder<int>(
                          initialData: _currentTabFilter,
                          stream: _tabFeedController.stream,
                          builder: (context, snapshot) {
                            final _currentTab = category[snapshot.data!] == e;
                            return GestureDetector(
                              onTap: () {
                                _clearData();
                                final int index = category.indexOf(e);
                                _tabFeedController.sink.add(index);
                                if (index == 1) {
                                  // user tap on "unread"
                                  // Firebase analytics
                                  GetIt.instance<FBAnalytics>()
                                      .sendEventSelectViewAnnouncementUnread(
                                          userID: Storage.getUserID() ?? "");
                                }
                              },
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: _currentTab
                                      ? Color(0xfff2e8ff)
                                      : Color(0xffeeeeee),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      15,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                      LocalizationsUtil.of(context)
                                          .translate(e),
                                      style: _currentTab
                                          ? AppFonts.medium14.copyWith(
                                              color: Color(0xff7A1DFF),
                                            )
                                          : AppFonts.medium14),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                  .toList(),
            ),
            GestureDetector(
              onTap: () {
                // tap on 'read all' icon
                _readAllFeed();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                width: 30,
                height: 30,
                color: Colors.transparent,
                child: SvgPicture.asset(
                  'assets/svg/mailbox/mdi-done-all.svg',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _readAllFeed() async {
    TokenModel? token = Storage.getToken();
    var jwt = new JsonWebToken.unverified(token?.access ?? '');
    var json = jwt.claims.toJson();
    final buildingId = Sqflite.currentBuildingID;
    try {
      await feedAPI.get("${APIConstant.baseFeedReadAll + json["user_id"]}",
          queryParameters: {
            "app_id": APIConstant.app_feed_id,
            "building_id": buildingId,
          });
    } on DioError catch (e) {
      // reponse code will be 500 but it's acceptable
      setState(() {
        if (_currentTabFilter == 1) {
          this._list.clear();
        }
        this._list.map((element) {
          // mark read all
          element.isRead = true;
        }).toList();
      });
      print('printing ----- ${e.error} -----');
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xff7a1dff),
          duration: Duration(seconds: 3),
          content: Text(
            LocalizationsUtil.of(context).translate("read_all_msg"),
            style: AppFonts.regular14.copyWith(color: Colors.white),
          ),
        ),
      );
    }
  }

  /*Build filter: Type and Time*/
  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
              child: DropdownWidget(
            controller: ftype,
            boxStyle: DropDownStyle.line,
            defaultHintText: 'all_mails',
            dataSource: dataSourceType,
            buildChild: (index) {
              return Center(
                  child: Text(LocalizationsUtil.of(context)
                      .translate(dataSourceType[index].value)));
            },
            doneEvent: (index) {
              var values = dataSourceType[index].key.split(":");
              controlFilter[kFilterTag] = dataSourceType[index].value ==
                      LocalizationsUtil.of(context)
                          .translate(ShareKeys.kImportantAnnouncement)
                  ? AppStrings.important
                  : '';
              controlFilter[kFilterType] = values[1];
              onRefresh();
              // Firebase analytics
              GetIt.instance<FBAnalytics>().sendEventFilterAnnouncement(
                  userID: Storage.getUserID() ?? "",
                  time: controlFilter[kFilterDate],
                  category: controlFilter[kFilterType]!);
            },
            cancelEvent: (index) {
              controlFilter[kFilterType] = "";
              controlFilter[kFilterTag] = '';
              onRefresh();
            },
          )),
          const SizedBox(width: 25),
          Flexible(
            child: DropdownWidget(
              controller: fdate,
              boxStyle: DropDownStyle.line,
              dataSource: dataSourceFdate,
              defaultHintText: 'all_time',
              buildChild: (index) {
                return Center(
                    child: Text(LocalizationsUtil.of(context)
                        .translate("${dataSourceFdate[index].value}")));
              },
              doneEvent: (index) {
                if (mounted) {
                  controlFilter[kFilterDate] = dataSourceFdate[index].key;
                  onRefresh();
                  // Firebase analytics
                  GetIt.instance<FBAnalytics>().sendEventFilterAnnouncement(
                      userID: Storage.getUserID() ?? "",
                      time: controlFilter[kFilterDate],
                      category: controlFilter[kFilterType]);
                }
              },
              cancelEvent: (index) {
                if (mounted) {
                  controlFilter[kFilterDate] = "";
                  onRefresh();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

/*
type: Lấy tất cả thông báo về
 */
  String get filterAllType =>
      'announcement,facility_booking,fee_sent,receipt_sent';

  // @override
  // bool get wantKeepAlive => false;

  @override
  void dispose() {
    _refreshController.dispose();
    ftype.controller.dispose();
    fdate.controller.dispose();
    subscriptionReadFeed.cancel();
    _tabFeedController.close();
    super.dispose();
  }
}
