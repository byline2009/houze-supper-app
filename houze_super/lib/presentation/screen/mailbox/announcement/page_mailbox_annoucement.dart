import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/pull_to_refresh.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_no_data.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_something_went_wrong.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/bloc/index.dart';
import 'package:houze_super/presentation/screen/mailbox/announcement/widget_annoucement_item.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/widget_footer.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/index.dart';

import '../ticket/bloc/mailbox_controller.dart';

/*Thông báo Page */
class TabViewFeed extends StatefulWidget {
  _TabViewFeedState state;

  @override
  State<StatefulWidget> createState() {
    state = _TabViewFeedState();
    return state;
  }

  void onRefresh() => state.onRefresh();
}

const String Filter_Tag = 'tag';
const String Filter_Type = 'type';
const String Filter_Date = 'date';

class _TabViewFeedState extends State<TabViewFeed>
    with AutomaticKeepAliveClientMixin<TabViewFeed>, TickerProviderStateMixin {
  //Form controller
  final ftype = DropdownWidgetController();
  final fdate = DropdownWidgetController();

  //Willbe load by API
  var dataSourceType = <KeyValueModel>[];

  final dataSourceFdate = <KeyValueModel>[];

  final controlFilter = {Filter_Tag: '', Filter_Date: '', Filter_Type: ''};

  // Bloc create
  final feedBloc = FeedBloc();
  final _listTemp = <FeedMessageModel>[];
  final _list = <FeedMessageModel>[];
  int page = 0;
  final _refreshController = RefreshController();
  bool shouldLoadMore = true;
  StreamSubscription subscriptionReadFeed;
  bool _didTap = true;

  @override
  void initState() {
    super.initState();

    _initDataSourceTime();
    controlFilter[Filter_Type] = controlFilter[Filter_Type] == ''
        ? filterAllType
        : controlFilter[Filter_Type];

    subscriptionReadFeed =
        MailBoxController.eventBus.on<EventReadFeed>().listen((event) {
      handleEventReadFeed(event.feed);
    });
  }

  handleEventReadFeed(FeedMessageModel feed) {
    if (mounted) {
      int index = _list.indexWhere((element) => element.id == feed.id);
      if (index != null) {
        if (mounted) {
          setState(() {
            _list[index] = feed;
          });
        }
      }
    }
  }

  _clearData() {
    page = 0;
    _listTemp.clear();
    _list.clear();
  }

  @override
  void dispose() {
    if (mounted) {
      if (_refreshController != null) _refreshController.dispose();
      if (ftype.controller != null) ftype.controller.dispose();
      if (fdate.controller != null) fdate.controller.dispose();
      if (subscriptionReadFeed != null) subscriptionReadFeed.cancel();
    }
    super.dispose();
  }

  void onRefresh() {
    _clearData();
    shouldLoadMore = true;
    controlFilter[Filter_Type] = controlFilter[Filter_Type] == ''
        ? filterAllType
        : controlFilter[Filter_Type];

    feedBloc.add(
      FeedLoadList(
        page: page,
        type: controlFilter[Filter_Type],
        date: controlFilter[Filter_Date],
        tags: controlFilter[Filter_Tag],
        limit: AppConstant.limitDefault,
      ),
    );

    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  void onLoading() {
    if (shouldLoadMore) {
      this.page++;
      _listTemp.clear();

      feedBloc.add(
        FeedLoadList(
          page: page,
          type: controlFilter[Filter_Type],
          date: controlFilter[Filter_Date],
          tags: controlFilter[Filter_Tag],
          limit: 10,
        ),
      );
    }
    _refreshController.loadComplete();
  }

  _initDataSourceTime() {
    DateTime today = DateTime.now();

    var _month = today.month;
    var _year = today.year;
    for (var i = 1; i < 10; ++i) {
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
    super.build(context);
    dataSourceType = dataSourceType.length == 0
        ? [
            KeyValueModel(
                key: "type:announcement",
                value: LocalizationsUtil.of(context).translate('announcement')),
            KeyValueModel(
                key: "type:announcement",
                value: LocalizationsUtil.of(context)
                    .translate('important_announcement')),
            KeyValueModel(
                key: "type:facility_booking",
                value: LocalizationsUtil.of(context)
                    .translate('facility_booking')),
            KeyValueModel(
                key: "type:fee_sent",
                value: LocalizationsUtil.of(context)
                    .translate('announcement_fee')),
            KeyValueModel(
                key: "type:receipt_sent",
                value: LocalizationsUtil.of(context).translate('receipt_paid')),
          ]
        : dataSourceType;

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildFilter(),
          const SizedBox(height: 20),
          Expanded(child: contentList()),
        ]);
  }

/*Build result list when filter by type annoucement and time*/
  Widget contentList() {
    return BlocProvider<FeedBloc>(
      create: (_) => feedBloc,
      child: BlocBuilder<FeedBloc, FeedState>(
        builder: (BuildContext context, FeedState feedState) {
          if (feedState is FeedInitial) {
            _clearData();
            feedBloc.add(FeedLoadList(
              page: page,
              type: controlFilter[Filter_Type],
              date: controlFilter[Filter_Date],
              limit: AppConstant.limitDefault,
            ));
          }

          if (feedState is FeedLoading && page == 0) {
            return CardListSkeleton(
              shrinkWrap: true,
              length: 4,
              config: SkeletonConfig(
                theme: SkeletonTheme.Light,
                bottomLinesCount: 0,
                radius: 0.0,
              ),
            );
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

          if (feedState is MailboxLoadAnnoucementsSuccessful &&
              _listTemp.isEmpty) {
            List<FeedMessageModel> test = (feedState.result).map((i) {
              return i;
            }).toList();
            shouldLoadMore = test.length >= AppConstant.limitDefault;
            _listTemp.addAll(test);
            _list.addAll(test.toList());
          }

          if (_list.isEmpty) {
            return WidgetNoData();
          }

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
                  SliverFixedExtentList(
                    itemExtent: MailboxStyle.heightItem,
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final feed = _list[index];
                        return AbsorbPointer(
                          absorbing: !this._didTap, //prevent multiple tapping
                          child: GestureDetector(
                            child: WidgetAnnouncementItem(
                              data: feed,
                            ),
                            onTap: () {
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
                ],
              ),
            ),
          );
        },
      ),
    );
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
              controlFilter[Filter_Tag] = dataSourceType[index].value ==
                      LocalizationsUtil.of(context)
                          .translate('important_announcement')
                  ? AppStrings.important
                  : '';
              controlFilter[Filter_Type] = values[1];
              onRefresh();
            },
            cancelEvent: (index) {
              controlFilter[Filter_Type] = "";
              controlFilter[Filter_Tag] = '';
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
                  controlFilter[Filter_Date] = dataSourceFdate[index].key;
                  onRefresh();
                }
              },
              cancelEvent: (index) {
                if (mounted) {
                  controlFilter[Filter_Date] = "";
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

  @override
  bool get wantKeepAlive => false;
}
