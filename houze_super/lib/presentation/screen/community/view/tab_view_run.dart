import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:houze_super/common/blocs/app_event_bloc.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/run/blocs/index.dart';
import 'package:houze_super/presentation/screen/community/run/blocs/run_bloc.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/index.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:houze_super/middle/model/building_model.dart';

import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/indicators/apple_refresh_indicator.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/definitions.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/widget.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/screen/community/index.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/index.dart';
import 'package:houze_super/presentation/screen/community/run/activity/index.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/index.dart';

import 'package:houze_super/utils/file_util.dart';

import '../../../app_router.dart';

class TabViewRun extends StatefulWidget {
  final BuildingMessageModel building;

  const TabViewRun({
    @required this.building,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabViewRunState();
}

class _TabViewRunState extends State<TabViewRun> {
  final _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _checkNetworkStream;
  StreamSubscription<BlocEvent> _subChallengeUpdateItem;
  List<EventModel> events;

  @override
  void initState() {
    super.initState();

    _initVariable();
    _initConnectivity();
    _initLisenter();
  }

  _initVariable() {
    events = [];
  }

  _initLisenter() {
    _checkNetworkStream = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );

    _subChallengeUpdateItem = AppEventBloc().listenEvent(
      eventName: EventName.challengeUpdateItem,
      handler: _handleChallengeUpdateItem,
    );
  }

  void _handleChallengeUpdateItem(BlocEvent evt) {
    final value = evt.value;

    if (mounted && value is EventModel) {
      final int index = events.indexWhere((element) => element.id == value.id);
      if (index != null && index >= 0)
        setState(() {
          events[index] = value;
        });
    }
  }

  /*
 * Kiểm tra mạng lần đầu initState
 */
  Future<void> _initConnectivity() async {
    try {
      ConnectivityResult result = await _connectivity.checkConnectivity();
      if (result != ConnectivityResult.none) {
        await checkFile();
        return;
      }
    } catch (e) {
      print(e.toString());
    }
  }

/*
 * Kiểm tra mạng sau mỗi lần thay đổi kết nối mạng
 */
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    try {
      if (result != ConnectivityResult.none) {
        await checkFile();
        return;
      }
    } catch (error) {
      print('Not connected error: ${error.toString()}');
    }
  }

  Future<void> checkFile() async {
    bool hasError;

    final file = await FileUtil.singleton.getFile('run_log');

    if (file == null) return;

    final _file = File(file.path);

    DialogCustom.showAlertDialog(
      context: context,
      title: "announcement",
      content: "would_you_like_to_send_your_last_run_activity_to_houze_server",
      buttonText: "ok",
      onPressed: () async {
        final activityUpdate = await RunRequest().sendActivity(_file);

        Navigator.of(context).pop();

        hasError = activityUpdate == null;
      },
    ).then(
      (value) async {
        if (hasError == null) return;

        if (hasError)
          await DialogCustom.showErrorDialog(
            context: context,
            title: 'network_connection_error',
            errMsg: 'there_is_an_issue_please_try_again_later_1',
            buttonText: 'back',
            callback: () => Navigator.pop(context),
          );
        else
          await DialogCustom.showSuccessDialog(
            context: context,
            title: 'send_successfully',
            content: 'your_last_run_activity_is_posted_successfully',
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunLoadDataBloc, RunLoadDataState>(
      builder: (BuildContext context, RunLoadDataState state) {
        if (state.isInitial) {
          context.read<RunLoadDataBloc>().add(
                RunLoadDataEvent(
                  buildingID: widget.building.id,
                ),
              );
        }

        if (state.hasError) {
          return SliverToBoxAdapter(
            child: SomethingWentWrong(true),
          );
        }

        if (state.hasData) {
          events = state.events;
          final _achivements = state.achivements;
          final _overview = state.overview;
          final _distanceDate = state.distanceDate;
          return Stack(
            children: [
              CustomRefreshIndicator(
                leadingGlowVisible: false,
                trailingGlowVisible: false,
                indicatorBuilder:
                    (BuildContext context, CustomRefreshIndicatorData d) {
                  if (d.isDraging) {
                    return Positioned(
                      top: 20,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: DraggingActivityIndicator(
                          percentageComplete: d.value,
                          radius: 12,
                        ),
                      ),
                    );
                  }

                  if (d.isArmed) {
                    return const Positioned(
                      top: 20,
                      right: 0,
                      left: 0,
                      child: CupertinoActivityIndicator(
                        radius: 12,
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
                onRefresh: () async {
                  await Future.delayed(
                    Duration.zero,
                    () {
                      context.read<RunLoadDataBloc>().add(
                            RunLoadDataEvent(
                              buildingID: widget.building.id,
                            ),
                          );
                    },
                  );
                },
                child: CustomScrollView(
                  key: const PageStorageKey<String>('TabViewRun'),
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    if (_overview != null) ...[
                      SliverToBoxAdapter(
                        key: const Key('SummaryStatisticSection'),
                        child: WidgetBoxesContainer(
                          child: SummaryStatisticSection(
                            distanceDate: _distanceDate,
                            overview: _overview,
                          ),
                        ),
                      )
                    ],
                    if (_achivements != null) ...[
                      SliverToBoxAdapter(
                        key: const Key('AchievementListWidget'),
                        child: WidgetBoxesContainer(
                          hasLine: hasEventsList,
                          child: AchievementListWidget(
                            achivements: _achivements,
                          ),
                        ),
                      )
                    ],
                    if (hasEventsList) ...[
                      SliverToBoxAdapter(
                        key: const Key('EventListWidget'),
                        child: EventListWidget(
                          events: events,
                        ),
                      )
                    ],
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 120,
                      ),
                    )
                  ],
                ),
              ),
              buildButtonRunNow(),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              BaseWidget.containerRounder(
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ParkingCardSkeleton(
                            width: 176,
                            height: 16,
                          ),
                          ParkingCardSkeleton(
                            width: 100,
                            height: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 21),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ParkingCardSkeleton(
                                  width: 130,
                                  height: 16,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ParkingCardSkeleton(
                                  width: 83,
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          DecoratedBox(
                            // margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            child: const SizedBox(
                              width: 1,
                              height: 30,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ParkingCardSkeleton(width: 130, height: 16),
                                const SizedBox(height: 5),
                                ParkingCardSkeleton(width: 83, height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ParkingCardSkeleton(width: 335, height: 16),
              const SizedBox(
                height: 10,
              ),
              ParkingCardSkeleton(width: 335, height: 16),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }

  bool get hasEventsList => events != null && events.length > 0;
  Future<bool> _checkLocationPermission() async {
    final access = await geo.Geolocator.checkPermission();

    switch (access) {
      case geo.LocationPermission.denied:
        final permission = await geo.Geolocator.requestPermission();

        if (permission != geo.LocationPermission.denied &&
            permission != geo.LocationPermission.deniedForever) {
          return true;
        } else {
          return false;
        }
        break;

      case geo.LocationPermission.deniedForever:
        return false;
        break;
      case geo.LocationPermission.whileInUse:
      case geo.LocationPermission.always:
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  _onCallBack(dynamic value) async {
    // widget.callback(true);
    await Future.delayed(Duration.zero, () {
      context.read<RunLoadDataBloc>().add(
            RunLoadDataEvent(
              buildingID: widget.building.id,
            ),
          );
    });
  }

  Widget buildButtonRunNow() => Align(
        alignment: Alignment.bottomCenter,
        child: ButtonRunNow(
          parentContext: context,
          callback: () async {
            final bool isGranted = await _checkLocationPermission();

            if (isGranted) {
              AppRouter.pushDialogNoParamsWithCallBack(
                context,
                AppRouter.COMMUNITY_RUN_MAIN_PAGE,
                _onCallBack,
              );
            } else {
              DialogCustom.show(
                context: context,
                content: 'houze_run_popup_location_permission_content',
                title: 'houze_run_popup_location_permission_title',
                buttonText: 'houze_run_popup_location_permission_allow',
                buttonCancel: 'houze_run_popup_location_permission_dont_allow',
                callback: () async {
                  await openAppSettings()
                      .whenComplete(() => Navigator.pop(context));
                },
              );
            }
          },
        ),
      );

  @override
  void dispose() {
    if (_checkNetworkStream != null) _checkNetworkStream.cancel();
    if (_subChallengeUpdateItem != null) _subChallengeUpdateItem.cancel();
    super.dispose();
  }
}
