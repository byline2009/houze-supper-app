import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/blocs/overlay/index.dart';
import 'package:houze_super/domain/facility/facility_bloc.dart';
import 'package:houze_super/domain/facility/facility_event.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/model/facility/facility_detail_model.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/empty_page.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/detail/history/widget_facility_history.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

class NaviagationTab extends Equatable {
  final String title;
  final Widget screen;
  const NaviagationTab(
    this.title,
    this.screen,
  );

  @override
  List<Object> get props => [
        title,
        screen,
      ];
}

class UtilityHistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UtilityHistoryScreenState();
}

class _UtilityHistoryScreenState extends RouteAwareState<UtilityHistoryScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var _tabs = <NaviagationTab>[];

  late TabController controller;

  @override
  void initState() {
    super.initState();

    _tabs = [
      NaviagationTab("facility", _UtilityContent()),
      NaviagationTab(
        'service',
        const EmptyPage(
          svgPath: AppVectors.icFacility,
          content: 'there_is_no_information',
        ),
      ),
    ];
    controller = getTabController();
  }

  TabController getTabController() =>
      TabController(length: _tabs.length, vsync: this);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            LocalizationsUtil.of(context).translate('my_activity'),
            style: AppFonts.medium18,
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                indicatorColor: AppColor.purple_6001d2,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: RoundedRectIndicator(
                    color: AppColor.purple_6001d2,
                    radius: 65,
                    padding: 20,
                    weight: 2.0),
                indicatorWeight: 2.0,
                tabs: _tabs
                    .map((f) => Tab(
                        text: LocalizationsUtil.of(context).translate(f.title)))
                    .toList(),
                labelColor: AppColor.purple_6001d2,
                unselectedLabelColor: AppColor.gray_b5b5b5,
                labelStyle: TextStyle(
                    fontFamily: AppFont.font_family_display,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(
                  fontFamily: AppFont.font_family_display,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: _tabs.map((e) => e.screen).toList(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _UtilityContent extends StatefulWidget {
  @override
  __UtilityContentState createState() => __UtilityContentState();
}

class __UtilityContentState extends State<_UtilityContent> {
  final OverlayBloc overlayBloc = OverlayBloc();
  final FacilityBloc facilityBloc = FacilityBloc();
  final TabbarTitleBloc tabbarBloc = TabbarTitleBloc();
  //Service converter
  static Future<String> serviceConverter() {
    final service = ServiceConverter.convertTypeBuilding("building");
    return service;
  }

  // final List<Field> _chips = [
  //   // status
  //   Field(name: 'Tất cả', value: AppVectors.registerAll),
  //   Field(name: 'Chờ duyệt', value: AppVectors.registerPending),
  //   Field(name: 'Thành công', value: AppVectors.registerSuccess),
  //   Field(name: 'Từ chối', value: AppVectors.registerDeny),
  //   Field(name: 'Đã hủy', value: AppVectors.registerCancel),
  // ];

  // int _chipIndex;

  // final List<Field> _status = [
  //   Field(name: 'Đang chờ duyệt', value: '0xFFd68100'),
  //   Field(name: 'Đặt thành công', value: '0xFF00aa7d'),
  //   Field(name: 'Bị từ chối', value: '0xFFc50000'),
  //   Field(name: 'Đã hủy', value: '0xFF838383'),
  // ];

  // final List<String> _statusPath = [
  //   AppVectors.registerPending,
  //   AppVectors.registerSuccess,
  //   AppVectors.registerDeny,
  //   AppVectors.registerCancel,
  // ];

  // final RefreshController _refreshController = RefreshController();
  //
  int page = 0;
  //
  // Future<void> _onRefresh() async {}
  //
  // Future<void> _onLoading() async {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<OverlayBloc>(create: (_) => overlayBloc),
        BlocProvider<FacilityBloc>(create: (_) => facilityBloc),
        BlocProvider<TabbarTitleBloc>(create: (_) => tabbarBloc),
      ],
      child: BlocBuilder<OverlayBloc, OverlayBlocState>(
        builder: (_, OverlayBlocState overlayState) {
          if (overlayState is AppInitial) overlayBloc.add(BuildingPicked());

          if (overlayState is PickBuildingSuccessful) {
            return WidgetFacilityHistory(
              header: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: _pickBuilding(
                  buildings: overlayState.buildings,
                  currentBuilding: overlayState.currentBuilding,
                  context: _,
                ),
              ),
              physics: const BouncingScrollPhysics(),
              facility: FacilityDetailModel(),
            );
          }

          if (overlayState is BuildingFailure &&
              overlayState.error.error is! NoDataToLoadMoreException) {
            if (overlayState.error.error is NoDataException)
              return SomethingWentWrong(true);
            else
              return SomethingWentWrong();
          }

          return Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }

  // Widget _showUtilityList(
  //     {Iterable<String> times, List<FacilityHistoryModel> facilities}) {
  //   return facilities.isNotEmpty
  //       ? Wrap(
  //           runSpacing: 30.0,
  //           children: times
  //               .map(
  //                 (time) => Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       'Tháng $time',
  //                       style: AppFont.SEMIBOLD_BLACK_13,
  //                     ),
  //                     SizedBox(height: 10.0),
  //                     Wrap(
  //                       runSpacing: 10.0,
  //                       children: facilities
  //                           .where((e) {
  //                             final List<String> times = time.split('/');

  //                             return e.date
  //                                     .substring(5, 7)
  //                                     .startsWith(times.first) &&
  //                                 e.date.startsWith(times.last);
  //                           })
  //                           .map(
  //                             (e) => Container(
  //                               height: 90.0,
  //                               decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 borderRadius: BorderRadius.circular(10.0),
  //                                 boxShadow: [
  //                                   BoxShadow(
  //                                     color: Colors.grey[200],
  //                                     blurRadius: 5.0,
  //                                     spreadRadius: 1.0,
  //                                     offset: Offset(
  //                                       0.0, //move right 10
  //                                       1.0, //move down 10
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                               child: TextButton(
  //                                 onPressed: () =>
  //                                     Navigator.of(context).pushNamed(
  //                                   AppRouter.UTILITY_DETAIL,
  //                                   arguments: e.id,
  //                                 ),
  //                                 child: Row(
  //                                   mainAxisAlignment:
  //                                       MainAxisAlignment.spaceBetween,
  //                                   children: [
  //                                     CircleAvatar(
  //                                       radius: 20.0,
  //                                       child: SvgPicture.asset(
  //                                         _statusPath[e.status],
  //                                         width: 40.0,
  //                                         height: 40.0,
  //                                       ),
  //                                     ),
  //                                     SizedBox(width: 16.0),
  //                                     Padding(
  //                                       padding: const EdgeInsets.symmetric(
  //                                           vertical: 16.0),
  //                                       child: Column(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.spaceBetween,
  //                                         crossAxisAlignment:
  //                                             CrossAxisAlignment.start,
  //                                         children: [
  //                                           Text(
  //                                             '${e.facilityTitle} - ${e.facilitySlotName}',
  //                                             style: AppFont.BOLD_BLACK,
  //                                           ),
  //                                           Text(
  //                                             '${e.startTime} - ${e.endTime}, ${DateFormat('dd/MM/y').format(DateTime.parse(e.date))}',
  //                                             style: AppFont
  //                                                 .SEMIBOLD_GRAY_838383_13,
  //                                           ),
  //                                           Text(
  //                                             _status[e.status].name,
  //                                             style: TextStyle(
  //                                               fontFamily:
  //                                                   AppFont.font_family_display,
  //                                               fontSize: 13,
  //                                               fontWeight: FontWeight.w600,
  //                                               color: Color(
  //                                                 int.parse(
  //                                                     _status[e.status].value),
  //                                               ),
  //                                             ),
  //                                           )
  //                                         ],
  //                                       ),
  //                                     ),
  //                                     Spacer(),
  //                                     Icon(
  //                                       Icons.arrow_forward,
  //                                       color: Color(0xFFd1d6de),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           )
  //                           .toList(),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //               .toList(),
  //         )
  //       : Align(
  //           child: Text(
  //             'Chưa có tiện ích.',
  //             style: AppFont.REGULAR_GRAY,
  //           ),
  //         );
  // }

  Column _pickBuilding({
    required List<BuildingMessageModel> buildings,
    required BuildingMessageModel currentBuilding,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(0, 2.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: serviceConverter(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return SizedBox.shrink();
                    }
                    return Text(
                      LocalizationsUtil.of(context).translate(snap.data),
                      style: AppFonts.medium14,
                    );
                  }),
              SizedBox(height: 8.0),
              SizedBox(
                height: 28.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      SwitchBuilding.showBottomSheet(
                        contextParent: context,
                        buildings: buildings,
                        currentBuildingID: currentBuilding.id ?? "",
                      );
                      facilityBloc
                          .add(FacilityGetBookingHistoryEvent(page: page));
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(0)),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentBuilding.name ?? '',
                          style: AppFonts.medium14,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // SingleChildScrollView _pickStatus() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     padding: const EdgeInsets.symmetric(vertical: 30.0),
  //     child: Wrap(
  //       spacing: 16.0,
  //       children: _chips
  //           .map(
  //             (e) => ChoiceChip(
  //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //               labelPadding:
  //                   EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  //               label: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(e.name),
  //                   SizedBox(width: 16.0),
  //                   SvgPicture.asset(e.value),
  //                 ],
  //               ),
  //               labelStyle: _chips.indexOf(e) == _chipIndex
  //                   ? AppFont.BOLD_PURPLE_7a1dff
  //                   : AppFont.BOLD_BLACK,
  //               selected: _chips.indexOf(e) == _chipIndex,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(5.0),
  //                 side: BorderSide(
  //                   style: _chips.indexOf(e) == _chipIndex
  //                       ? BorderStyle.none
  //                       : BorderStyle.solid,
  //                   color: Color(0xFFdcdcdc),
  //                 ),
  //               ),
  //               backgroundColor: Colors.white,
  //               selectedColor: Color(0xFFf2e8ff),
  //               onSelected: (bool value) {
  //                 setState(() => _chipIndex = _chips.indexOf(e));
  //                 facilityBloc.add(
  //                   FacilityGetBookingHistoryEvent(
  //                     page: page,
  //                     status: _chipIndex - 1 < 0 ? null : _chipIndex - 1,
  //                   ),
  //                 );
  //               },
  //             ),
  //           )
  //           .toList(),
  //     ),
  //   );
  // }
}
