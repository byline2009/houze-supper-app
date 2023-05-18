import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/domain/facility/facility_event.dart';
import 'package:houze_super/domain/facility_list/facility_list_bloc.dart';
import 'package:houze_super/middle/model/facility/facility_detail_model.dart';
import 'package:houze_super/middle/model/facility/facility_history_model.dart';
import 'package:houze_super/presentation/common_widgets/group_radio_tags_widget.dart';
import 'package:houze_super/presentation/common_widgets/grouped_list.dart';
import 'package:houze_super/presentation/common_widgets/widget_booking_item.dart';
import 'package:houze_super/presentation/common_widgets/widget_no_data_display.dart';
import 'package:houze_super/presentation/common_widgets/widget_slide_animation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/detail/history/widget_empty_history.dart';
import 'package:intl/intl.dart';

typedef CallbackHorizoltalHandler = Function(dynamic index);

class CategoriesHorizoltal extends StatelessWidget {
  CallbackHorizoltalHandler? callbackHandler;

  CategoriesHorizoltal(CallbackHorizoltalHandler callback) {
    this.callbackHandler = callback;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: GroupRadioTagsWidget(
        tags: <GroupRadioTags>[
          GroupRadioTags(
              id: -1,
              title: "all",
              icon: SvgPicture.asset(AppVectors.icRegistercDone)),
          GroupRadioTags(
              id: 0,
              title: "pending",
              icon: SvgPicture.asset(AppVectors.icRegistercPending)),
          GroupRadioTags(
              id: 1,
              title: "successful",
              icon: SvgPicture.asset(AppVectors.icRegistercSuccess)),
          GroupRadioTags(
              id: 2,
              title: "rejected_0",
              icon: SvgPicture.asset(AppVectors.icRegisterDeny)),
          GroupRadioTags(
              id: 3,
              title: "canceled",
              icon: SvgPicture.asset(AppVectors.icRegistercCancel))
        ],
        defaultIndex: 0,
        callback: (dynamic index) {
          this.callbackHandler!(index);
        },
      ),
    );
  }
}

class WidgetFacilityHistory extends StatefulWidget {
  final ScrollPhysics? physics;
  final Widget? header;
  final FacilityDetailModel? facility;
  WidgetFacilityHistory({this.header, this.physics, this.facility});

  @override
  WidgetFacilityHistoryState createState() => WidgetFacilityHistoryState();
}

class WidgetFacilityHistoryState extends State<WidgetFacilityHistory> {
  final _facilityHistoryBloc = FacilityHistoryBloc();
  final _refreshController = RefreshController(initialRefresh: true);
  int? index;
  int page = 1;
  bool shouldLoadMore = true;
  var _listTemp = <FacilityHistoryModel>[];
  var _list = <FacilityHistoryModel>[];

  void _onLoading() {
    if (this.shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      _facilityHistoryBloc.add(FacilityGetHistoryPager(
          facilityId: widget.facility?.id ?? "",
          page: this.page,
          status: this.index ?? -1));
      _refreshController.loadComplete();
    }
  }

  @override
  void initState() {
    super.initState();

    _facilityHistoryBloc.add(FacilityGetHistoryPager(
        facilityId: widget.facility?.id ?? "", page: 1));
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
        Widget body = Center();

        if (shouldLoadMore == false) {
          mode = LoadStatus.noMore;
        }

        if (_facilityHistoryBloc.isNext == false) {
          mode = LoadStatus.noMore;
        }

        if (mode == LoadStatus.loading) {
          body = FacilityHistoryIsLoading();
        }

        if (mode == LoadStatus.noMore) {
          body = NoDataBottomLine(parentContext: context);
        }

        return SizedBox(
          height: 50,
          child: Center(child: body),
        );
      }),
      onRefresh: () {
        _facilityHistoryBloc.add(FacilityGetHistoryPager(
            facilityId: widget.facility!.id ?? "",
            page: 1,
            status: this.index ?? -1));
      },
      onLoading: _onLoading,
      bodyBuilder: (List<Widget> list) {
        List<Widget> headers = [
          SliverToBoxAdapter(
            child: widget.header ?? Center(),
          ),
          SliverToBoxAdapter(
            child: CategoriesHorizoltal((index) {
              setState(() {
                this.index = index;
              });
              _facilityHistoryBloc.add(FacilityGetHistoryPager(
                  facilityId: widget.facility?.id ?? "",
                  page: 1,
                  status: index));
            }),
          ),
        ];
        return headers + list;
      },
      child: BlocProvider<FacilityHistoryBloc>(
        create: (_) => _facilityHistoryBloc,
        child: BlocBuilder<FacilityHistoryBloc, List<FacilityHistoryModel>>(
            builder: (BuildContext context,
                List<FacilityHistoryModel>? facilityHistoryModel) {
          if (facilityHistoryModel == null) {
            return Center(
                child: Text(LocalizationsUtil.of(context)
                    .translate("lost_connection")));
          }

          if (!_facilityHistoryBloc.isNext &&
              facilityHistoryModel.length == 0) {
            return EmptyHistory(parentContext: parentCtx); //_historyEmpty();

          }

          _refreshController.loadComplete();
          _refreshController.refreshCompleted();

          if (facilityHistoryModel.length > 0) {
            final List<FacilityHistoryModel> test = facilityHistoryModel;
            shouldLoadMore = test.length >= AppConstant.limitDefault;
            _listTemp.addAll(test);
            _list.addAll(test.toList());
            return AnimationLimiter(
                child: GroupedListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    sort: false,
                    padding: const EdgeInsets.all(0),
                    elements: facilityHistoryModel,
                    groupBy: (dynamic element) => DateFormat('MM/yyyy')
                        .format(DateTime.parse(element.date)),
                    groupSeparatorBuilder: (dynamic groupByValue) {
                      List<String> rs = groupByValue.toString().split('/');

                      String _month = StringUtil.getMonthStr(int.parse(rs[0]))!;
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(children: <Widget>[
                            Text(
                                LocalizationsUtil.of(context)
                                        .translate(_month) +
                                    rs[1],
                                style: AppFonts.medium14),
                          ]));
                    },
                    indexedItemBuilder:
                        (context, FacilityHistoryModel element, index) {
                      return WidgetSlideAnimation(
                        position: index,
                        child: GestureDetector(
                            onTap: () {
                              AppRouter.pushDialog(
                                  context,
                                  AppRouter.FACILITY_BOOKING_DETAIL_PAGE,
                                  FacilityBookingDetailScreenArgument(
                                      id: element.id!));
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: BookingRowData(
                                    title: _getTitleFacilityInItem(element),
                                    date: _getDateInItem(element),
                                    status: BookingRowData.statusOrder(
                                        context, element.status),
                                    statusCode: element.status))),
                      );
                    }));
          }

          return FacilityHistoryIsLoading();
        }),
      ),
    ));
  }

  String _getTitleFacilityInItem(FacilityHistoryModel element) {
    return widget.facility?.title == null
        ? "${element.facilityTitle} -  ${element.facilitySlotName}"
        : "${element.facilitySlotName}";
  }

  String _getDateInItem(FacilityHistoryModel element) {
    return "${element.startTime} - ${element.endTime}, ${DateFormat('dd/MM/yyyy').format(DateTime.parse(element.date!))}";
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}

class FacilityHistoryIsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
