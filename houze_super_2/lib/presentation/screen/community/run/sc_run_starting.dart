import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:houze_super/middle/model/houze_location.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/base_scaffold_no_focus.dart';
import 'package:houze_super/presentation/common_widgets/widget_button_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/index.dart';

import 'package:houze_super/utils/distance_calculator.dart';

import '../background_locator/location_callback_handler.dart';
import '../background_locator/location_service_repository.dart';

class RunStartingArgument {
  final int startTime;
  final int time;
  final double totalDistance;
  final Set<Polyline> polylines;

  const RunStartingArgument({
    required this.startTime,
    required this.time,
    required this.totalDistance,
    required this.polylines,
  });
}

class RunStartingScreen extends StatefulWidget {
  final RunStartingArgument args;

  const RunStartingScreen({
    required this.args,
  });

  @override
  _RunStartingScreenState createState() => _RunStartingScreenState();
}

class _RunStartingScreenState extends RouteAwareState<RunStartingScreen> {
  late Timer timer;

  final ReceivePort port = ReceivePort();

  bool isRunning = false;

  final locationDtoList = <LocationDto>[];

  final locations = <HouzeLocation>[];

  final points = <LatLng>[];

  final polylines = <Polyline>{};

  late double totalDistance, distance = 0.0;

  late int time;

  Future<bool> _checkLocationPermission() async {
    final access = await geo.Geolocator.checkPermission();
    switch (access) {
      case geo.LocationPermission.denied:
        final permission = await geo.Geolocator.requestPermission();
        if (permission != geo.LocationPermission.denied ||
            permission != geo.LocationPermission.deniedForever) {
          return true;
        } else {
          return false;
        }

      case geo.LocationPermission.deniedForever:
        AppSettings.openLocationSettings();
        return false;

      case geo.LocationPermission.whileInUse:
      case geo.LocationPermission.always:
        return true;

      default:
        return false;
    }
  }

  Future<void> _startLocator() async {
    Map<String, dynamic> data = {'countInit': 1};
    await BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.callback,
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: data,
/*
        Comment initDataCallback, so service not set init variable,
        variable stay with value of last run after unRegisterLocationUpdate
 */
      disposeCallback: LocationCallbackHandler.disposeCallback,
      iosSettings: IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: 10,
      ),
      autoStop: false,
      androidSettings: AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 5,
        distanceFilter: 10,
        client: LocationClient.google,
        androidNotificationSettings: AndroidNotificationSettings(
          notificationChannelName: 'Location tracking',
          notificationTitle: 'Start Location Tracking',
          notificationMsg: 'Track location in background',
          notificationBigMsg:
              'Background location is on to keep the app up-to-date with your location. This is required for main features to work properly when the app is not running.',
          notificationIcon: '',
          notificationIconColor: Colors.grey,
          notificationTapCallback: LocationCallbackHandler.notificationCallback,
        ),
      ),
    );
  }

  Future<void> _onStart() async {
    if (await _checkLocationPermission()) {
      await _startLocator();
      final _isRunning = await BackgroundLocator.isServiceRunning();
      setState(() {
        isRunning = _isRunning;
      });
    } else {
      // show error
    }
  }

  Future<void> _onStop() async {
    port.close();

    distance = totalDistance - widget.args.totalDistance;

    locations.addAll(
      locationDtoList.map(
        (e) => HouzeLocation(
          latitude: e.latitude,
          longitude: e.longitude,
          accuracy: e.accuracy,
          altitude: e.altitude,
          speed: e.speed,
          speedAccuracy: e.speedAccuracy,
          heading: e.heading,
          time: e.time,
          isMocked: e.isMocked,
        ),
      ),
    );

    points.addAll(
      locations.map(
        (e) => LatLng(
          e.latitude,
          e.longitude,
        ),
      ),
    );

    polylines.add(
      Polyline(
        polylineId: PolylineId('polyline${polylines.length}'),
        points: points,
        color: Colors.blue,
        width: 5,
      ),
    );
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }
    BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();

    isRunning = _isRunning;
  }

  Future<void> _onReset() async {
    port.close();
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }
    BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();

    isRunning = _isRunning;
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();

    setState(() {
      isRunning = _isRunning;
    });

    print('Running ${isRunning.toString()}');
    await _onStart();
  }

  String formatTime(int milliseconds) {
    if (milliseconds == 0) return '00:00:00';

    final secs = milliseconds ~/ 1000;
    final hours = (secs ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void initState() {
    super.initState();

    totalDistance = widget.args.totalDistance;

    time = widget.args.time;

    polylines.addAll(widget.args.polylines);

    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
      port.sendPort,
      LocationServiceRepository.isolateName,
    );

    port.listen(
      (dynamic data) {
        if (data != null) {
          if (data.accuracy >= 30.0) return;

          if (locationDtoList.isNotEmpty)
            totalDistance += getDistance(locationDtoList.last, data);

          locationDtoList.add(data);
        }
      },
    );

    initPlatformState();

    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        setState(() => time = DateTime.now().millisecondsSinceEpoch -
            widget.args.startTime +
            widget.args.time);
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String timeStr = formatTime(time);

    final scHeight = MediaQuery.of(context).size.height;

    Column buildField(String title, String value) {
      return Column(
        children: [
          Text(
              LocalizationsUtil.of(context).translate(title) +
                  "${title == 'distance' ? " (km)" : ''}",
              style: AppFonts.bold24.copyWith(
                color: Color(0xff838383),
              ) //BOLD_GRAY_838383_24,
              ),
          SizedBox(height: scHeight * 0.01),
          Text(
            value,
            style: AppFonts.bold.copyWith(
              fontSize: 54,
            ),
          ),
        ],
      );
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: BaseScaffoldNoFocus(
        title: LocalizationsUtil.of(context).translate('running'),
        bottom: Container(
          height: 5,
          color: const Color(0xffe3a500),
        ),
        leading: CloseButton(
          onPressed: () async => await DialogCustom.showAlertDialog(
            context: context,
            title: 'confirm_to_cancel_the_running',
            content:
                'are_you_sure_you_want_to_cancel_running_all_results_will_be_deleted_after_cancellation',
            buttonText: 'confirm',
            onPressed: () async {
              await _onReset();

              Navigator.of(context).popUntil(
                ModalRoute.withName(
                  AppRouter.COMMUNITY_RUN_MAIN_PAGE,
                ),
              );
            },
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
            left: scHeight * 0.025,
            right: scHeight * 0.025,
            bottom: scHeight * 0.05,
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: scHeight * 0.075,
            ),
            Column(
              children: [
                buildField(
                  'distance',
                  totalDistance.toStringAsFixed(2),
                ),
                SizedBox(height: scHeight * 0.06),
                buildField(
                  'run_time',
                  timeStr,
                ),
                SizedBox(height: scHeight * 0.1),
                SvgPicture.asset('assets/svg/community/ic-map.svg'),
                SizedBox(height: scHeight * 0.02),
                Text(
                  LocalizationsUtil.of(context).translate(
                      'your_track_map_will_be_drawn_when_you_stop_running_the_feature_of_real_time_display_will_be_developed_in_the_next_version'),
                  style: AppFonts.semibold13.copyWith(
                    color: Color(0xff838383),
                  ),
                ),
                SizedBox(height: scHeight * 0.05),
                RunPauseButton(
                  _onStop,
                  {
                    'distance': distance,
                    'total_distance': totalDistance,
                    'time': time,
                    'polylines': polylines,
                    'locations': locations,
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
