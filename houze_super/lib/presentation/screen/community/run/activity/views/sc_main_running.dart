import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

import 'package:houze_super/middle/model/houze_location.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_button_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/activity/widget/bottom_sheet_running_pause.dart';
import 'package:houze_super/presentation/screen/community/run/run_request.dart';
import 'package:houze_super/presentation/screen/community/run/sc_run_starting.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/gpx_util.dart';
import 'package:houze_super/utils/prefs.dart';

import '../index.dart';

//---SCREEN: Chạy bộ---//

class RunMainScreen extends StatefulWidget {
  @override
  _RunMainScreenState createState() => _RunMainScreenState();
}

class _RunMainScreenState extends State<RunMainScreen> {
  File file;

  final ProgressHUD progressHUD = Progress.instanceCreateWithNormal();

  final _controller = Completer<GoogleMapController>();

  CameraPosition _cameraPosition;

  final houzeRoutes = <HouzeRoute>[];

  final markers = <Marker>{};

  bool isStarted = false;

  double totalDistance, lastDistance = 0.0;

  double minLat = 85.0, minLong = 180.0, maxLat = -85.0, maxLong = -180.0;

  Map<String, dynamic> mapValue;

  LatLngBounds bounds;

  bool isServiceEnabled = false;

  String formatTime(int milliseconds) {
    if (milliseconds == 0) return null;

    final secs = milliseconds ~/ 1000;
    final hours = (secs ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Future<geo.Position> _getLocation() async {
    geo.Position _current;

    lastDistance = await Prefs.getLastDistance() ?? 0.0;

    isServiceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (isServiceEnabled == false) {
      AppSettings.openLocationSettings();
    }

    // geo.GeolocationStatus geolocationStatus =
    //     await geolocator.checkGeolocationPermissionStatus();
    // if (geolocationStatus != geo.GeolocationStatus.granted) {
    //   await Future.delayed(const Duration(milliseconds: 2000));
    // }

    try {
      _current = await geo.Geolocator.getCurrentPosition(
          desiredAccuracy: geo.LocationAccuracy.best);

      await Prefs.setLastLatitude(_current.latitude);

      await Prefs.setLastLongitude(_current.longitude);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        _current = await _getLastLocation();
        if (_current == null) throw NoLocation();
      } else
        rethrow;
    } catch (e) {
      rethrow;
    }

    _cameraPosition = CameraPosition(
      target: LatLng(_current.latitude, _current.longitude),
      zoom: 15.0,
    );

    return _current;
  }

  Future<geo.Position> _getLastLocation() async {
    // final isServiceEnabled = await geo.GeolocationPermission;

    final lastLatitude = await Prefs.getLastLatitude();
    final lastLongitude = await Prefs.getLastLongitude();

    if (lastLatitude == null || lastLongitude == null) return null;

    final position = geo.Position(
      latitude: lastLatitude,
      longitude: lastLongitude,
    );

    return position;
  }

  Future<void> navigateToRunStartingPage(BuildContext _) async {
    mapValue = await Navigator.of(_).push(
      MaterialPageRoute(
        builder: (_) => RunStartingScreen(
          args: RunStartingArgument(
            startTime: DateTime.now().millisecondsSinceEpoch,
            time: mapValue['time'],
            totalDistance: mapValue['total_distance'],
            polylines: mapValue['polylines'],
          ),
        ),
        fullscreenDialog: true,
        settings: RouteSettings(name: AppRouter.COMMUNITY_RUN_STARTING_PAGE),
      ),
    );

    if (mapValue != null) {
      final List<HouzeLocation> locations = mapValue['locations'];

      if (locations.isEmpty) {
        setState(() {});

        return;
      }

      if (markers.isEmpty)
        markers.add(
          Marker(
            markerId: MarkerId('startPoint'),
            position: LatLng(
              locations.first.latitude,
              locations.first.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        );
      else
        markers.remove(markers.elementAt(1));

      markers.add(
        Marker(
          markerId: MarkerId('endPoint'),
          position: LatLng(locations.last.latitude, locations.last.longitude),
        ),
      );

      bounds = setBounds(locations);

      final double distance = mapValue['distance'];

      final double averageSpeed =
          locations.map((e) => e.speed).reduce((v, e) => v + e) /
              locations.length;

      // add new locations.
      houzeRoutes.add(
        HouzeRoute(
          locations: locations,
          distance: distance,
          averageSpeed: averageSpeed,
        ),
      );

      setState(() {});
    } else {
      houzeRoutes.clear();

      markers.clear();

      minLat = 85.0;
      minLong = 180.0;
      maxLat = -85.0;
      maxLong = -180.0;

      bounds = null;

      setState(() => isStarted = false);
    }
  }

  void _goToNewBounds(GoogleMapController controller) {
    if (bounds != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 64.0),
      );
    }
  }

  LatLngBounds setBounds(List<HouzeLocation> locations) {
    minLat = locations.map((e) => e.latitude).fold(minLat, min);
    maxLat = locations.map((e) => e.latitude).fold(maxLat, max);

    minLong = locations.map((e) => e.longitude).fold(minLong, min);
    maxLong = locations.map((e) => e.longitude).fold(maxLong, max);

    return LatLngBounds(
      southwest: LatLng(minLat, minLong),
      northeast: LatLng(maxLat, maxLong),
    );
  }

  @override
  Widget build(BuildContext context) {
    mapValue ??= {
      'total_distance': 0.0,
      'time': 0,
      'polylines': <Polyline>{},
      'locations': <HouzeLocation>[],
    };

    totalDistance = mapValue['total_distance'];

    final double compare = totalDistance - lastDistance;

    final String timeStr = formatTime(mapValue['time']) ?? '00:00:00';

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            LocalizationsUtil.of(context).translate('running'),
            style: AppFonts.semibold18,
          ),
          leading: CloseButton(
            onPressed: () async => DialogCustom.showAlertDialog(
              context: context,
              title: 'confirm_to_cancel_the_running',
              content:
                  'are_you_sure_you_want_to_cancel_running_all_results_will_be_deleted_after_cancellation',
              buttonText: 'confirm',
              onPressed: () {
                // _onReset();

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: FutureBuilder<geo.Position>(
          future: _getLocation(),
          builder:
              (BuildContext context, AsyncSnapshot<geo.Position> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.blue[100],
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 150,
                      child: SizedBox(
                        child: CupertinoActivityIndicator(),
                      )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 300,
                      color: Colors.transparent,
                      child: Container(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 40),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0),
                            )),
                        child: SafeArea(
                          bottom: true,
                          maintainBottomViewPadding: true,
                          child: BottomSheetStartRunning(
                            parentContext: context,
                            isActive: false,
                            callback: (success) {},
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            if (snapshot.hasData) {
              return Stack(children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: _cameraPosition,
                    markers: markers,
                    polylines: mapValue['polylines'],
                    onMapCreated: (GoogleMapController controller) {
                      if (!_controller.isCompleted)
                        _controller.complete(controller);

                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _goToNewBounds(controller));
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 300,
                    color: Colors.transparent,
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 40),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0),
                          )),
                      child: SafeArea(
                        bottom: true,
                        maintainBottomViewPadding: true,
                        child: isStarted == false
                            ? BottomSheetStartRunning(
                                isActive: true,
                                parentContext: context,
                                callback: (start) {
                                  if (start) {
                                    if (isServiceEnabled) {
                                      setState(() => isStarted = true);
                                      navigateToRunStartingPage(context);
                                    }
                                  }
                                })
                            : BottomSheetRunningPause(
                                parentContext: context,
                                compare: compare,
                                pauseCallback: (pause) async {
                                  if (pause) {
                                    await stopActivity(
                                      compare: compare,
                                      timeStr: timeStr,
                                    );
                                  }
                                },
                                continueCallback: (continued) {
                                  if (continued && isServiceEnabled) {
                                    navigateToRunStartingPage(context);
                                  }
                                },
                                mapValue: mapValue),
                      ),
                    ),
                  ),
                ),
                progressHUD
              ]);
              // return Stack(
              //   children: [
              //     Column(
              //       children: [
              //         Flexible(
              //           child: GoogleMap(
              //             myLocationEnabled: true,
              //             initialCameraPosition: _cameraPosition,
              //             markers: markers,
              //             polylines: mapValue['polylines'],
              //             onMapCreated: (GoogleMapController controller) {
              //               if (!_controller.isCompleted)
              //                 _controller.complete(controller);

              //               WidgetsBinding.instance.addPostFrameCallback(
              //                   (_) => _goToNewBounds(controller));
              //             },
              //           ),
              //         ),
              //         bottomSheet(compare: compare, timeStr: timeStr)
              //       ],
              //     ),
              //     progressHUD //ProgressIndicatorWidget(isProgressing),
              //   ],
              // );
            }

            if (snapshot.hasError) {
              final String err = snapshot.error is NoLocation
                  ? 'request_turn_on_location_permission'
                  : snapshot.error.toString();

              return Align(
                child: Text(
                  LocalizationsUtil.of(context).translate(err),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Align(
              child: Text(
                LocalizationsUtil.of(context)
                    .translate('google_services_not_supported_by_device'),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget bottomSheet({double compare, String timeStr}) {
    return BottomSheet(
      enableDrag: false,
      backgroundColor: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (_) {
        Widget buildField({String title, String value}) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationsUtil.of(context).translate(title),
                style: AppFonts.semibold13.copyWith(
                  color: Color(0xff838383),
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                value,
                style: AppFonts.bold27,
              ),
            ],
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 40.0,
            right: 20.0,
            bottom: 20.0,
          ),
          child: ListBody(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      margin: EdgeInsets.only(left: 32.0),
                      child: buildField(
                        title: 'distance',
                        value: '${totalDistance.toStringAsFixed(2)} km',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                    child: VerticalDivider(
                      color: const Color(0xffc4c4c4),
                      width: 48.0,
                      thickness: 1.0,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      margin: EdgeInsets.only(right: 16.0),
                      child: buildField(
                        title: 'time',
                        value: timeStr,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 32.0, bottom: 40.0),
                child: isStarted
                    ? Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: FlatStadiumButton(
                              buttonText: 'continue',
                              onPressed: !isServiceEnabled
                                  ? null
                                  : () => navigateToRunStartingPage(context),
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Flexible(
                            fit: FlexFit.tight,
                            child: FlatStadiumButton(
                              buttonText: 'end',
                              onPressed: () async {
                                await stopActivity(
                                  compare: compare,
                                  timeStr: timeStr,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Align(
                        child: RaisedStadiumButton(
                          buttonText: 'start',
                          onPressed: !isServiceEnabled
                              ? null
                              : () {
                                  setState(() => isStarted = true);

                                  navigateToRunStartingPage(context);
                                },
                        ),
                      ),
              ),
              isStarted
                  ? compare >= 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                                'assets/svg/community/ic-walk.svg'),
                            SizedBox(width: 4.0),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: LocalizationsUtil.of(context)
                                        .translate(
                                            'great_you_ran_more_than_last_time'),
                                    style: AppFonts.semibold13.copyWith(
                                      color: Color(0xff838383),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' +${compare.toStringAsFixed(2)} km',
                                    style: AppFonts.semibold13
                                        .copyWith(color: Color(0xff00aa7d)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/svg/community/ic-walk.svg'),
                        SizedBox(width: 4.0),
                        Text(
                          LocalizationsUtil.of(context).translate(
                              'remember_to_warm_up_before_starting_the_run'),
                          style: AppFonts.semibold13.copyWith(
                            color: Color(0xff838383),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
      onClosing: () {},
    );
  }

  Future<void> stopActivity({
    double compare,
    String timeStr,
  }) async {
    try {
      await Prefs.setLastDistance(totalDistance);
      file = await GpxUtil.encryptRouteFile(houzeRoutes);

      final result = await RunRequest().sendActivity(
        file,
        progressHUD,
      );
      if (result != null) {
        await DialogCustom.showRunFinishDialog(
          context: context,
          distance: totalDistance.toStringAsFixed(2),
          compare: compare,
          runTime: timeStr,
        );
      }
    } catch (e) {
      print(e);

      await DialogCustom.showErrorDialog(
          errMsg: 'there_is_an_issue_please_try_again_later_0',
          title: 'announcement',
          context: context,
          buttonText: 'back_to_main_page',
          callback: () {
            Navigator.of(context).popUntil(
              (route) {
                if (route.settings.name == AppRouter.ROOT) {
                  return true;
                }
                return false;
              },
            );
          });
    }
  }
}
