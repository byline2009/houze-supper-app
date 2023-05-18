import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/domain/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/register/picker/calendar_networking.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../base/route_aware_state.dart';

typedef void CallBackSlotHandler(FacilitySlotModel result);
typedef void CallBackFacilityRegistryModel(FacilityRegistryModel result);

class FacilityPickEventScreenArgument {
  final String facilityId;
  final CallBackFacilityRegistryModel? callback;

  FacilityPickEventScreenArgument({
    required this.facilityId,
    required this.callback,
  });
}

class FacilityPickEventScreen extends StatefulWidget {
  final FacilityPickEventScreenArgument params;

  FacilityPickEventScreen({Key? key, required this.params}) : super(key: key);

  @override
  FacilityPickEventScreenState createState() =>
      new FacilityPickEventScreenState();
}

class FacilityPickEventScreenState extends RouteAwareState<FacilityPickEventScreen> {
  final panelController = PanelController();
  final _panelFacilityBloc = FacilityBloc();
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  DateTime? _pickedDate = DateTime.now();
  final _repo = CalendarRepo();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'make_your_booking',
      child: ValueListenableBuilder<DateTime>(
        valueListenable: _focusedDay,
        builder: (context, value, _) {
          return Stack(
            children: <Widget>[
              FutureBuilder(
                future: _repo.getData(
                    id: widget.params.facilityId,
                    year: value.year.toString(),
                    month: value.month.toString()),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  if (snap.hasError) {
                    return AnimatedCalendarWidget(
                        widget: _buildCalendar(list: []));
                  }
                  final availableDaysInMonth =
                      snap.data as AvailableDaysInMonthModel;
                  if (DateTime.now().month == value.month) {
                    // disable invalid days
                    availableDaysInMonth.days
                        .removeWhere((element) => element < DateTime.now().day);
                  }
                  return SafeArea(
                    child: AnimatedCalendarWidget(
                        widget:
                            _buildCalendar(list: availableDaysInMonth.days)),
                  );
                },
              ),
              _slidingUpPanel(),
            ],
          );
        },
      ),
    );
  }

  Widget _slidingUpPanel() {
    return SlidingUpPanel(
        controller: panelController,
        parallaxEnabled: true,
        parallaxOffset: .5,
        minHeight: 0,
        backdropEnabled: true,
        isDraggable: false,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        renderPanelSheet: true,
        panelBuilder: (sc) => _panel(sc),
        onPanelClosed: () {});
  }

  Widget _panel(ScrollController sc) {
    final height = 65.0;
    var _characterGroup = '';
    final _screenSize = MediaQuery.of(context).size;
    final padding = _screenSize.width * 15 / 100;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: height,
                width: padding,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColor.black,
                  ),
                  onPressed: () {
                    panelController.close();
                  },
                )),
            BlocBuilder<FacilityBloc, FacilityState>(
                bloc: _panelFacilityBloc,
                builder: (
                  BuildContext context,
                  FacilityState facilityState,
                ) {
                  final _params =
                      _panelFacilityBloc.getFacilitySlotParams(facilityState);
                  var timeBetween = "";
                  if (_params != null) {
                    timeBetween =
                        "${_params['start_time']} - ${_params['end_time']}";
                  }

                  return Container(
                      height: height,
                      padding: const EdgeInsets.all(10),
                      child: Center(
                          child:
                              Text(timeBetween, style: AppFont.BOLD_BLACK_24)));
                }),
            SizedBox(
              height: height,
              width: padding,
            ),
          ],
        ),
        Container(
            width: double.infinity,
            height: 50,
            color: AppColor.gray_f5f7f8,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(children: <Widget>[
              Text(
                LocalizationsUtil.of(context)
                    .translate('please_choose_the_location_below'),
                textAlign: TextAlign.left,
                style: AppFont.MEDIUM_GRAY_838383_14,
              )
            ])),
        Expanded(
            child: BlocBuilder<FacilityBloc, FacilityState>(
                bloc: _panelFacilityBloc,
                builder: (
                  BuildContext context,
                  FacilityState facilityState,
                ) {
                  List<FacilitySlotModel> slots =
                      _panelFacilityBloc.getFacilitySlot(facilityState);
                  final _params =
                      _panelFacilityBloc.getFacilitySlotParams(facilityState);

                  if (facilityState is FacilityLoadingInProgress) {
                    return Center(child: CupertinoActivityIndicator());
                  }

                  if (slots.length == 0 || slots.isEmpty) {
                    return Center(
                        child: Text(LocalizationsUtil.of(context)
                            .translate("no_registration_location_yet")));
                  }

                  if (slots.length > 0) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        controller: sc,
                        itemCount: slots.length,
                        itemBuilder: (BuildContext context, int index) {
                          FacilitySlotModel item = slots[index];
                          return GestureDetector(
                              onTap: () {
                                if (item.isFree == true &&
                                    widget.params.callback != null) {
                                  widget.params.callback!(FacilityRegistryModel(
                                    startTime: _params['start_time'],
                                    endTime: _params['end_time'],
                                    dateTime: _pickedDate,
                                    facilitySlotId: item.id,
                                    facilityName: item.name,
                                  ));
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Container(
                                  key: Key(item.id!),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: AppColor.gray_f5f5f5,
                                            width: 1,
                                            style: BorderStyle.solid)),
                                  ),
                                  padding: const EdgeInsets.only(
                                      right: 20, top: 20, bottom: 20, left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 50,
                                        child: slots[index].isFree == true
                                            ? Radio(
                                                value: item.id,
                                                activeColor:
                                                    AppColor.purple_6001d2,
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                groupValue: _characterGroup,
                                                hoverColor:
                                                    AppColor.purple_6001d2,
                                                focusColor:
                                                    AppColor.purple_6001d2,
                                                onChanged:
                                                    (dynamic value) async {
                                                  if (item.isFree == true &&
                                                      widget.params.callback !=
                                                          null) {
                                                    widget.params.callback!(
                                                        FacilityRegistryModel(
                                                      startTime:
                                                          _params['start_time'],
                                                      endTime:
                                                          _params['end_time'],
                                                      dateTime: _pickedDate,
                                                      facilitySlotId: item.id,
                                                      facilityName: item.name,
                                                    ));
                                                    Navigator.of(context).pop();
                                                  }
                                                })
                                            : Center(),
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(slots[index].name!,
                                              style: AppFonts.medium14),
                                          SizedBox(height: 5),
                                          statusRegistry(
                                              context, slots[index].isFree!)
                                        ],
                                      ))
                                    ],
                                  )));
                        });
                  }

                  return Center(child: CupertinoActivityIndicator());
                }))
      ],
    );
  }

  Widget statusRegistry(BuildContext context, bool isFree) {
    if (isFree == true) {
      return Text(
        LocalizationsUtil.of(context).translate('available_for_booking'),
        style: AppFonts.medium14.copyWith(color: AppColor.green_00aa7d),
      );
    }
    return Text(
      LocalizationsUtil.of(context).translate('not_available_for_booking'),
      style: AppFonts.medium14.copyWith(color: AppColor.red_c50000),
    );
  }

  Widget _buildCalendar({required List<int> list}) {
    final _language = Storage.getLanguage();
    final kToday = DateTime.now();
    final kFirstDay = DateTime(kToday.year, kToday.month - 12, kToday.day);
    final kLastDay = DateTime(kToday.year, kToday.month + 12, kToday.day);
    final _facilityBloc = FacilityBloc();
    return CustomScrollView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: TableCalendar(
              locale: _language.locale,
              firstDay: kFirstDay,
              lastDay: kLastDay,
              currentDay: kToday,
              focusedDay: _focusedDay.value,
              headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextStyle: AppFonts.bold16,
              ),
              calendarFormat: CalendarFormat.month,
              availableCalendarFormats: {
                CalendarFormat.month: LocalizationsUtil.of(context)
                    .translate('table_calendar_month'),
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_pickedDate, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  _facilityBloc.add(FacilityGetWorking(
                      id: widget.params.facilityId,
                      date: DateFormat('yyyy-MM-dd').format(selectedDay)));
                  setState(() {
                    _pickedDate = selectedDay;
                    _focusedDay.value = focusedDay;
                  });
                }
              },
              calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                      color: const Color(0xff7a1dff), shape: BoxShape.circle),
                  outsideDaysVisible: false),
              selectedDayPredicate: (day) {
                print("selectedDayPredicate " + day.toString());
                return isSameDay(_pickedDate, day);
              },
              enabledDayPredicate: (date) {
                if (date.isBefore(DateTime.now())) {
                  // disable invalid days
                  if (date.day < DateTime.now().day) {
                    return [].contains(date.day);
                  }
                }
                return list.contains(date.day);
              },
              onPageChanged: (date) {
                print("onPageChanged " + date.toString());
                _pickedDate = null;
                _focusedDay.value = date;
              },
            ),
          ),
          BlocBuilder<FacilityBloc, FacilityState>(
              bloc: _facilityBloc,
              builder: (
                BuildContext context,
                FacilityState facilityState,
              ) {
                Widget content = Center();

                if (facilityState is FacilityLoadingInProgress) {
                  return SliverToBoxAdapter(
                      child: CardListSkeleton(
                    shrinkWrap: true,
                    length: 2,
                    config: SkeletonConfig(
                      theme: SkeletonTheme.Light,
                      isShowAvatar: false,
                      isCircleAvatar: false,
                      bottomLinesCount: 2,
                      radius: 0.0,
                    ),
                  ));
                }

                if (facilityState is FacilityInitial) {
                  if (_pickedDate != null) {
                    // user pick a day
                    if (list.contains(_pickedDate!.day)) {
                      // disable invalid days
                      _facilityBloc.add(FacilityGetWorking(
                          id: widget.params.facilityId,
                          date: DateFormat('yyyy-MM-dd').format(_pickedDate!)));
                    } else {
                      _facilityBloc.add(UserTapOnInvalidDate());
                    }
                  } else {
                    // calendar's page changed
                    if (list.length > 0 &&
                        list[0] == DateTime.now().day &&
                        _focusedDay.value.month == DateTime.now().month) {
                      _pickedDate = DateTime.now();
                      _facilityBloc.add(FacilityGetWorking(
                          id: widget.params.facilityId,
                          date: DateFormat('yyyy-MM-dd').format(_pickedDate!)));
                    } else {
                      _facilityBloc.add(UserTapOnInvalidDate());
                    }
                  }
                }

                if (facilityState is GetFacilityDayoff) {
                  return facilityState.description.length > 0
                      ? SliverToBoxAdapter(
                          child: BaseWidget.icon404(
                              SvgPicture.asset(
                                  "assets/svg/icon/404/ic-calendar-off.svg"),
                              Text(
                                facilityState.description,
                                textAlign: TextAlign.center,
                                style: AppFont.MEDIUM_GRAY_808080_16,
                              )))
                      : SliverToBoxAdapter(child: const SizedBox.shrink());
                }

                if (facilityState is GetFacilityWorkingSuccess) {
                  if (facilityState.result.length == 0) {
                    return SliverToBoxAdapter(
                        child: BaseWidget.icon404(
                            SvgPicture.asset(
                                "assets/svg/icon/404/ic-calendar-empty.svg"),
                            Text(
                              LocalizationsUtil.of(context)
                                  .translate('this_facility_is_this_today'),
                              textAlign: TextAlign.center,
                              style: AppFont.MEDIUM_GRAY_808080_16,
                            )));
                  }

                  return AnimationLimiter(
                      child: SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 200),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: GestureDetector(
                              onTap: () {
                                panelController.open();
                                _panelFacilityBloc.add(FacilityGetSlot(
                                    id: widget.params.facilityId,
                                    date: DateFormat('yyyy-MM-dd')
                                        .format(_pickedDate!),
                                    startTime:
                                        facilityState.result[index].startTime!,
                                    endTime:
                                        facilityState.result[index].endTime!));
                              },
                              child: FacilityPickerEventCard(
                                  facilityWorkingModel:
                                      facilityState.result[index])),
                        ),
                      ),
                    );
                  }, childCount: facilityState.result.length)));
                }

                return SliverToBoxAdapter(child: content);
              }),
        ]);
  }
}

class AnimatedCalendarWidget extends StatelessWidget {
  final Widget widget;
  AnimatedCalendarWidget({required this.widget});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 1000),
      builder: (BuildContext context, double opacity, Widget? child) {
        return Opacity(opacity: opacity, child: widget);
      },
    );
  }
}
