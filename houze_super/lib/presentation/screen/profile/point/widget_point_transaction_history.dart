import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/model/houze_point/point_transaction_history_model.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/empty_page.dart';
import 'package:houze_super/presentation/common_widgets/grouped_list.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/src/indicator/custom_indicator.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/src/indicator/material_indicator.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/src/smart_refresher.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/list_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton_config.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton_theme.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_no_data_display.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_slide_animation.dart';

import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/common_widgets/bottom_sheet/header_bottom_sheet.dart';
import 'package:houze_super/presentation/screen/home/home_tab/style/style_hone_page.dart';
import 'package:houze_super/presentation/screen/profile/point/bloc/point_event.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/string_util.dart';
import 'package:intl/intl.dart';

import 'bloc/point_bloc.dart';

const ICON_SIZE = 45.0;

class FilterActionType {
  String type;
  String content;
  FilterActionType({this.type, this.content});
}

class WidgetPointHistory extends StatefulWidget {
  final ScrollPhysics physics;
  final Widget header;
  WidgetPointHistory({this.physics, this.header});

  @override
  _WidgetPointHistoryState createState() => _WidgetPointHistoryState();
}

class _WidgetPointHistoryState extends State<WidgetPointHistory> {
  final _pointBloc = PointHistoryBloc();
  final _refreshController = RefreshController(initialRefresh: true);

  final dataSourceFdate = <KeyValueModel>[];
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

  List<FilterActionType> _listActionType = [
    FilterActionType(type: '', content: 'all_activities'),
    FilterActionType(type: 'ticket_created_award', content: 'send_a_request'),
    FilterActionType(type: 'ticket_rating_award', content: 'start_review'),
    FilterActionType(
        type: 'fee_bank_transfer_award', content: 'online_payment'),
    FilterActionType(type: 'run', content: 'running'),
    FilterActionType(type: 'run_award', content: 'run_award'),
    FilterActionType(type: 'xu_use', content: 'houze_xu_used'),
    FilterActionType(type: 'run_exercise_award', content: 'run_exercise_award'),
  ];
  int currentIndexActivity;
  int currentIndexTime;
  String date;
  int page = 0;
  bool shouldLoadMore = true;
  var _listTemp = <PointTransationHistoryModel>[];
  var _list = <PointTransationHistoryModel>[];

  @override
  void initState() {
    super.initState();
    currentIndexActivity = 0;
    currentIndexTime = null;
    _initDataSourceTime();
    _pointBloc.add(
        GetPointHistory(action: _listActionType[currentIndexActivity].type));
  }

  void _onLoading() {
    if (this.shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      _pointBloc.add(GetPointHistory(
          action: _listActionType[currentIndexActivity].type,
          page: page,
          date: this.date));
    }
    _refreshController.loadComplete();
  }

  void _onRefresh() {
    page = 1;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    _pointBloc.add(GetPointHistory(
        action: _listActionType[currentIndexActivity].type,
        page: page,
        date: this.date));

    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext parentCtx) {
    return Scrollbar(
        child: SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      physics: widget.physics ?? AlwaysScrollableScrollPhysics(),
      header: MaterialClassicHeader(),
      footer: CustomFooter(builder: (BuildContext context, LoadStatus mode) {
        Widget body = const SizedBox.shrink();

        if (shouldLoadMore == false) {
          mode = LoadStatus.noMore;
        }

        if (_pointBloc.isNext == false) {
          mode = LoadStatus.noMore;
        }

        if (mode == LoadStatus.loading) {
          body = PointHistoryIsLoading();
        }

        if (mode == LoadStatus.noMore) {
          body = NoDataBottomLine(parentContext: context);
        }

        return SizedBox(
          height: 50,
          child: Center(child: body),
        );
      }),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      bodyBuilder: (List<Widget> list) {
        List<Widget> headers = [
          SliverToBoxAdapter(
            child: widget.header ?? const SizedBox.shrink(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: _filter(context),
            ),
          ),
        ];
        return headers + list;
      },
      child: BlocProvider<PointHistoryBloc>(
        create: (_) => _pointBloc,
        child: BlocBuilder<PointHistoryBloc, List<PointTransationHistoryModel>>(
            builder: (BuildContext context,
                List<PointTransationHistoryModel> _pointHistoryModel) {
          if (_pointHistoryModel == null) {
            return Center(
                child: Text(LocalizationsUtil.of(context)
                    .translate("lost_connection")));
          }

          if (!_pointBloc.isNext &&
              _pointHistoryModel != null &&
              _pointHistoryModel.length == 0) {
            return EmptyPage(
              svgPath: AppVectors.icFacility,
              content: 'there_is_no_information',
            );
          }

          _refreshController.loadComplete();
          _refreshController.refreshCompleted();

          if (_pointHistoryModel.length > 0) {
            final List<PointTransationHistoryModel> test = _pointHistoryModel;
            shouldLoadMore = test.length >= AppConstant.limitDefault;
            _listTemp.addAll(test);
            _list.addAll(test.toList());

            return AnimationLimiter(
                child: GroupedListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    sort: false,
                    padding: const EdgeInsets.all(0),
                    elements: _pointHistoryModel,
                    groupBy: (element) => DateFormat('MM/yyyy')
                        .format(DateTime.parse(element.created)),
                    groupSeparatorBuilder: (dynamic groupByValue) {
                      List<String> rs = groupByValue.toString().split('/');

                      String _month = StringUtil.getMonthStr(int.parse(rs[0]));
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 10.0, left: 20.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              LocalizationsUtil.of(context).translate(_month) +
                                  rs[1],
                              style: AppFonts.medium14
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    },
                    indexedItemBuilder:
                        (context, PointTransationHistoryModel element, index) {
                      return WidgetSlideAnimation(
                        position: index,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10.0, left: 20.0, right: 20.0),
                          child: houzeXuItem(
                            element,
                            _getDateInItem(element),
                          ),
                        ),
                      );
                    }));
          }

          return PointHistoryIsLoading();
        }),
      ),
    ));
  }

  Widget houzeXuItem(PointTransationHistoryModel element, String date) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(color: Color(0xfff5f5f5), width: 2.0)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: SvgPicture.asset(
              "assets/svg/profile/${element.action}.svg",
              width: ICON_SIZE,
              height: ICON_SIZE,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationsUtil.of(context).translate(element.action),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  date,
                  style: TextStyle(
                      color: Color(0xff838383),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  element.amount > 0
                      ? '+ ${element.amount.toString()}'
                      : '${element.amount.toString()}',
                  style: TextStyle(
                      color: element.amount > 0
                          ? Color(0xffd68100)
                          : Color(0xff838383),
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDateInItem(PointTransationHistoryModel element) {
    return "${DateFormat('hh:mm').format(DateTime.parse(element.created).toLocal())} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(element.created).toLocal())}";
  }

  Widget _filter(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showBottomSheetActivity(context: context);
          },
          child: this.currentIndexActivity == 0
              ? DottedBorder(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  borderType: BorderType.RRect,
                  dashPattern: [4, 4],
                  color: Color(0xff737373),
                  radius: Radius.circular(5),
                  child: Container(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Color(0xff838383),
                          size: 18.0,
                        ),
                        const SizedBox(width: 8),
                        Text(LocalizationsUtil.of(context).translate('active'),
                            style: AppFonts.semibold13
                                .copyWith(color: Color(0xff838383))),
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xff6001d2),
                  ),
                  height: 38.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: SizedBox(
                          width: 60.0,
                          child: Text(
                            LocalizationsUtil.of(context).translate(
                                _listActionType[this.currentIndexActivity]
                                    .content),
                            style: AppFonts.semibold13
                                .copyWith(color: Colors.white),
                            softWrap: false,
                            overflow: _listActionType[this.currentIndexActivity]
                                        .content
                                        .length >
                                    11
                                ? TextOverflow.ellipsis
                                : null,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        width: 1,
                        color: Colors.white,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          onPressed: () {
                            setState(() {
                              this.currentIndexActivity = 0;
                              _pointBloc.add(GetPointHistory(
                                  action: _listActionType[currentIndexActivity]
                                      .type,
                                  page: 1,
                                  date: this.date));
                            });
                          })
                    ],
                  ),
                ),
        ),
        const SizedBox(width: 15.0),
        GestureDetector(
          onTap: () {
            showBottomSheetTime(context: context);
          },
          child: currentIndexTime == null
              ? DottedBorder(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  borderType: BorderType.RRect,
                  dashPattern: [4, 4],
                  color: Color(0xff737373),
                  radius: Radius.circular(5),
                  child: Container(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Color(0xff838383),
                          size: 18.0,
                        ),
                        const SizedBox(width: 8),
                        Text(LocalizationsUtil.of(context).translate('time'),
                            style: AppFonts.semibold13
                                .copyWith(color: Color(0xff838383)))
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xff6001d2),
                  ),
                  height: 38.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          LocalizationsUtil.of(context)
                                  .translate('month_with_camel_case') +
                              " " +
                              dataSourceFdate[this.currentIndexTime].value,
                          style:
                              AppFonts.semibold13.copyWith(color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        width: 1,
                        color: Colors.white,
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          onPressed: () {
                            setState(() {
                              this.currentIndexTime = null;
                              this.date = null;
                            });
                            _pointBloc.add(GetPointHistory(
                                action:
                                    _listActionType[currentIndexActivity].type,
                                page: 1,
                                date: this.date));
                          })
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  void showBottomSheetActivity({@required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        builder: (context) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(StyleHomePage.borderRadius),
                  topRight: Radius.circular(StyleHomePage.borderRadius),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.65,
              child: Column(
                children: [
                  HeaderBottomSheet(
                      title: LocalizationsUtil.of(context)
                          .translate('pick_activity'),
                      parentContext: context),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _listActionType.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Container(
                            decoration: BaseWidget.dividerBottom(
                                height: 1, color: Color(0xfff5f5f5)),
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: _listActionType[index].content,
                                  activeColor: Color(0xff6001d2),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  hoverColor: Color(0xff6001d2),
                                  focusColor: Color(0xff6001d2),
                                  onChanged: (_) {
                                    _activityFilter(index);
                                  },
                                  groupValue:
                                      _listActionType[this.currentIndexActivity]
                                          .content,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    LocalizationsUtil.of(context).translate(
                                        _listActionType[index].content),
                                    style: AppFonts.medium14
                                        .copyWith(color: Colors.black))
                              ],
                            ),
                          ),
                          onTap: () {
                            _activityFilter(index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _activityFilter(int index) {
    setState(() {
      this.currentIndexActivity = index;
    });
    _pointBloc.add(GetPointHistory(
        action: _listActionType[currentIndexActivity].type,
        page: 1,
        date: this.date));
    Navigator.pop(context);
  }

  void showBottomSheetTime({@required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        builder: (context) {
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(StyleHomePage.borderRadius),
                  topRight: Radius.circular(StyleHomePage.borderRadius),
                ),
              ),
              height: StyleHomePage.bottomSheetHeight(context),
              child: Column(
                children: [
                  HeaderBottomSheet(
                      title:
                          LocalizationsUtil.of(context).translate('pick_time'),
                      parentContext: context),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: dataSourceFdate.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: Container(
                            decoration: BaseWidget.dividerBottom(
                                height: 1, color: Color(0xfff5f5f5)),
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                  value: dataSourceFdate[index].value,
                                  activeColor: Color(0xff6001d2),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  hoverColor: Color(0xff6001d2),
                                  focusColor: Color(0xff6001d2),
                                  onChanged: (String value) {
                                    _timeFilter(index);
                                  },
                                  groupValue: this.currentIndexTime != null
                                      ? dataSourceFdate[this.currentIndexTime]
                                          .value
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    LocalizationsUtil.of(context).translate(
                                            'month_with_camel_case') +
                                        " " +
                                        dataSourceFdate[index].value,
                                    style: AppFonts.medium14
                                        .copyWith(color: Colors.black))
                              ],
                            ),
                          ),
                          onTap: () {
                            _timeFilter(index);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _timeFilter(int index) {
    setState(() {
      this.currentIndexTime = index;
      this.date = dataSourceFdate[currentIndexTime].key;
    });
    _pointBloc.add(GetPointHistory(
        action: _listActionType[currentIndexActivity].type,
        page: 1,
        date: this.date));
    Navigator.pop(context);
  }
}

class PointHistoryIsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListSkeleton(
        length: 3,
        shrinkWrap: true,
        config: SkeletonConfig(
          isCircleAvatar: true,
          isShowAvatar: true,
          theme: SkeletonTheme.Light,
          bottomLinesCount: 2,
        ),
      ),
    );
  }
}
