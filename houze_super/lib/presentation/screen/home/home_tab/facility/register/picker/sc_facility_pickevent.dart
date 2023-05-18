import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/domain/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_base_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/register/picker/facility_pickevent_card.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_networking.dart';

const double ICON_SIZE = 22.0;

typedef void CallBackSlotHandler(FacilitySlotModel result);
typedef void CallBackFacilityRegistryModel(FacilityRegistryModel result);

class FacilityPickEventScreenArgument {
  final String facilityId;
  final CallBackFacilityRegistryModel callback;

  FacilityPickEventScreenArgument({
    @required this.facilityId,
    @required this.callback,
  });
}

class FacilityPickEventScreen extends StatefulWidget {
  final FacilityPickEventScreenArgument params;

  FacilityPickEventScreen({Key key, @required this.params}) : super(key: key);

  @override
  FacilityPickEventScreenState createState() =>
      new FacilityPickEventScreenState();
}

class FacilityPickEventScreenState extends State<FacilityPickEventScreen> {
  var _calendarController = CalendarController();
  final _panelFacilityBloc = FacilityBloc();
  DateTime _pickedDate = DateTime.now();
  DateTime current = DateTime.now();
  final _repo = CalendarRepo();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "make_your_booking",
      child: SingleChildScrollView(
        child: Column(
          children: [
            _calendarHeader(),
            FutureBuilder(
              future: _repo.getData(
                id: widget.params.facilityId,
                year: current.year.toString(),
                month: current.month.toString(),
              ),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                if (snap.hasError) {
                  return AnimatedWidget(
                    widget: _buildCalendar(list: []),
                  );
                }
                final availableDaysInMonth =
                    snap.data as AvailableDaysInMonthModel;
                availableDaysInMonth.days
                    .removeWhere((element) => element < current.day);
                return SafeArea(
                  child: AnimatedWidget(
                    widget: _buildCalendar(list: availableDaysInMonth.days),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  DateTime _getCurrentDate() {
    if (_calendarController.focusedDay != null) {
      return _calendarController.focusedDay;
    } else {
      return DateTime.now();
    }
  }

  Widget _calendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          padding: const EdgeInsets.only(left: 15.0),
          icon: Icon(
            Icons.arrow_back_ios,
            size: ICON_SIZE,
          ),
          onPressed: () => _calendarController.previousPage(),
        ),
        Text(
          LocalizationsUtil.of(context)
                  .translate(StringUtil.getMonthStr(_getCurrentDate().month)) +
              _getCurrentDate().year.toString(),
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        IconButton(
          padding: const EdgeInsets.only(right: 10.0),
          icon: Icon(
            Icons.arrow_forward_ios,
            size: ICON_SIZE,
          ),
          onPressed: () => _calendarController.nextPage(),
        )
      ],
    );
  }

  void _showModalBottomSheet({BuildContext contextParent}) {
    showModalBottomSheet(
        context: contextParent,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0))),
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: _panel());
        });
  }

  Widget _panel() {
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
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            BlocBuilder<FacilityBloc, FacilityState>(
                cubit: _panelFacilityBloc,
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
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(timeBetween, style: AppFonts.bold24),
                    ),
                  );
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
          color: Color(0xfff5f7f8),
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Text(
                LocalizationsUtil.of(context)
                    .translate('please_choose_the_location_below'),
                textAlign: TextAlign.left,
                style: AppFonts.medium14.copyWith(color: Color(0xff838383)),
              )
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<FacilityBloc, FacilityState>(
            cubit: _panelFacilityBloc,
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

              if (slots.length > 0) {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: slots.length,
                  itemBuilder: (BuildContext context, int index) {
                    FacilitySlotModel item = slots[index];
                    return GestureDetector(
                      onTap: () {
                        if (item.isFree == true &&
                            widget.params.callback != null) {
                          widget.params.callback(FacilityRegistryModel(
                            startTime: _params['start_time'],
                            endTime: _params['end_time'],
                            dateTime: _pickedDate,
                            facilitySlotId: item.id,
                            facilityName: item.name,
                          ));
                          Navigator.of(context).popUntil((route) {
                            return (route.settings.name ==
                                AppRouter.FACILITY_REGISTER_PAGE);
                          });
                        }
                      },
                      child: Container(
                        key: Key(item.id),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xfff5f5f5),
                                  width: 1,
                                  style: BorderStyle.solid)),
                        ),
                        padding: const EdgeInsets.only(
                            right: 20.0, top: 20.0, bottom: 20.0, left: 10.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 50.0,
                              child: slots[index].isFree == true
                                  ? Radio(
                                      value: item.id,
                                      activeColor: Color(0xff6001d2),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      groupValue: _characterGroup,
                                      hoverColor: Color(0xff6001d2),
                                      focusColor: Color(0xff6001d2),
                                      onChanged: (String value) async {
                                        if (item.isFree == true &&
                                            widget.params.callback != null) {
                                          widget.params
                                              .callback(FacilityRegistryModel(
                                            startTime: _params['start_time'],
                                            endTime: _params['end_time'],
                                            dateTime: _pickedDate,
                                            facilitySlotId: item.id,
                                            facilityName: item.name,
                                          ));

                                          Navigator.of(context)
                                              .popUntil((route) {
                                            return (route.settings.name ==
                                                AppRouter
                                                    .FACILITY_REGISTER_PAGE);
                                          });
                                        }
                                      },
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(slots[index].name,
                                      style: AppFonts.medium14
                                          .copyWith(color: Colors.black)),
                                  SizedBox(height: 5),
                                  statusRegistry(context, slots[index].isFree)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return Center(
                child: Text(
                  LocalizationsUtil.of(context)
                      .translate("no_registration_location_yet"),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget statusRegistry(BuildContext context, bool isFree) {
    if (isFree == true) {
      return Text(
        LocalizationsUtil.of(context).translate('available_for_booking'),
        style: AppFonts.medium14
            .copyWith(color: Colors.white)
            .copyWith(color: Color(0xff00aa7d)),
      );
    }
    return Text(
      LocalizationsUtil.of(context).translate('not_available_for_booking'),
      style: AppFonts.medium14
          .copyWith(color: Colors.white)
          .copyWith(color: Color(0xffc50000)),
    );
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      if (DateTime.now().month == _calendarController.visibleDays.first.month &&
          DateTime.now().year == _calendarController.visibleDays.first.year) {
        current = DateTime.now();
      } else {
        current = _calendarController.visibleDays.first;
        _pickedDate = _calendarController.visibleDays.first;
      }
    });
  }

  Widget _buildCalendar({@required List<int> list}) {
    final _language = Storage.getLanguage();
    final _facilityBloc = FacilityBloc();
    return CustomScrollView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: TableCalendar(
            headerVisible: false,
            locale: _language.locale,
            calendarController: _calendarController,
            startDay: current,
            initialSelectedDay: (current.month == DateTime.now().month &&
                    current.year == DateTime.now().year)
                ? DateTime.now()
                : current,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              titleTextStyle: AppFonts.bold.copyWith(fontSize: 16),
            ),
            initialCalendarFormat: CalendarFormat.month,
            availableCalendarFormats: {
              CalendarFormat.month: LocalizationsUtil.of(context)
                  .translate('table_calendar_month')
            },
            onDaySelected: (date, events, holidays) {
              if (DateTime.now().isAfter(date)) {
                _facilityBloc.add(UserTapOnInvalidDate());
              } else {
                _facilityBloc.add(FacilityGetWorking(
                    id: widget.params.facilityId,
                    date: DateFormat('yyyy-MM-dd').format(date)));
                _pickedDate = date;
              }
            },
            calendarStyle: CalendarStyle(
                selectedColor: Color(0xff7A1DFF), outsideDaysVisible: false),
            enabledDayPredicate: (date) {
              return list.contains(date.day);
            },
            onVisibleDaysChanged: _onVisibleDaysChanged,
          ),
        ),
        list.length > 0
            ? BlocBuilder<FacilityBloc, FacilityState>(
                cubit: _facilityBloc,
                builder: (
                  BuildContext context,
                  FacilityState facilityState,
                ) {
                  Widget content = SizedBox.shrink();

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
                    if (list.contains(current.day)) {
                      var now = DateTime.now();
                      if (now.year == current.year &&
                          now.month == current.month &&
                          now.day == current.day) {
                        _pickedDate = current;
                      }
                      _facilityBloc.add(FacilityGetWorking(
                          id: widget.params.facilityId,
                          date: DateFormat('yyyy-MM-dd').format(current)));
                    } else {
                      _facilityBloc.add(UserTapOnInvalidDate());
                    }
                  }

                  if (facilityState is GetFacilityDayoff) {
                    return SliverToBoxAdapter(
                      child: BaseWidget.icon404(
                        SvgPicture.asset(
                            "assets/svg/icon/404/ic-calendar-off.svg"),
                        Text(
                          LocalizationsUtil.of(context)
                              .translate(facilityState.description),
                          textAlign: TextAlign.center,
                          style: AppFonts.medium16
                              .copyWith(color: Color(0xff808080)),
                        ),
                      ),
                    );
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
                            style: AppFonts.medium16
                                .copyWith(color: Color(0xff808080)),
                          ),
                        ),
                      );
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
                                    _showModalBottomSheet(
                                        contextParent: context);
                                    _panelFacilityBloc.add(FacilityGetSlot(
                                        id: widget.params.facilityId,
                                        date: DateFormat('yyyy-MM-dd')
                                            .format(_pickedDate),
                                        startTime: facilityState
                                            .result[index].startTime,
                                        endTime: facilityState
                                            .result[index].endTime));
                                  },
                                  child: FacilityPickerEventCard(
                                    facilityWorkingModel:
                                        facilityState.result[index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }, childCount: facilityState.result.length),
                      ),
                    );
                  }

                  return SliverToBoxAdapter(child: content);
                })
            : SliverToBoxAdapter(
                child: SizedBox.shrink(),
              ),
      ],
    );
  }
}

class AnimatedWidget extends StatelessWidget {
  final Widget widget;
  AnimatedWidget({@required this.widget});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 1000),
      builder: (BuildContext context, double opacity, Widget child) {
        return Opacity(opacity: opacity, child: widget);
      },
    );
  }
}
