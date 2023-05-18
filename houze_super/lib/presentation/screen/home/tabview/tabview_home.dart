import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/bloc/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/repo/version_repo.dart';

import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/index.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/index.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:store_redirect/store_redirect.dart';

typedef void CallBack(String service);

class TabViewHome extends StatefulWidget {
  final Key tabKey;
  final String tabName;
  final CallBack callback;
  const TabViewHome(
      {Key key, this.tabKey, this.tabName, @required this.callback})
      : super(key: key);

  @override
  _TabViewHomeState createState() => _TabViewHomeState();
}

class _TabViewHomeState extends State<TabViewHome> {
  final moduleShow = {
    "important_feed": true,
    "facilities": true,
    "services": true,
  };
  final _overlayBloc = OverlayBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      width: AppConstant.screenWidth,
      height: AppConstant.screenHeight,
      allowFontScaling: false,
    );
    return BlocProvider(
      create: (BuildContext context) => _overlayBloc,
      child: BlocListener(
        cubit: _overlayBloc,
        listener: (context, overlayState) {
          if (overlayState is BuildingFailure) {
            if (overlayState.error is NoDataException) {
              return SomethingWentWrong(true);
            } else {
              return SomethingWentWrong();
            }
          }

          if (overlayState is PickBuildingSuccessful) {
            widget.callback(overlayState.currentBuilding.service +
                overlayState.currentBuilding.type.toString());
            if (overlayState.buildings.length == 0) {
              _navigateToNoBuildingPage();
            } else {
              if (overlayState.currentBuilding != null) {
                processAfterGetBuildingSuccess(overlayState.currentBuilding);
              }
            }
          }
        },
        child: BlocBuilder<OverlayBloc, OverlayBlocState>(
            builder: (BuildContext context, OverlayBlocState overlayState) {
          if (overlayState is AppInitial) {
            _overlayBloc.add(BuildingPicked());
          }

          if (overlayState is BuildingFailure) {
            if (overlayState.error is NoDataException) {
              return SomethingWentWrong(true);
            } else {
              return SomethingWentWrong();
            }
          }

          if (overlayState is PickBuildingSuccessful &&
              overlayState.buildings.length > 0) {
            return CustomRefreshIndicator(
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
                        )));
                  }

                  if (d.isArmed) {
                    return Positioned(
                        top: 20,
                        right: 0,
                        left: 0,
                        child: CupertinoActivityIndicator(radius: 12));
                  }

                  return const SizedBox.shrink();
                },
                onRefresh: () async {
                  _overlayBloc.add(BuildingPicked());
                },
                child: CustomScrollView(
                    key: PageStorageKey<String>("page_home"),
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      /* Building */
                      WidgetSwapApartmentBox(
                        agrs: BuildingSuccessArgument(
                            buildings: overlayState.buildings,
                            currentBuilding: overlayState.currentBuilding),
                      ),

                      /* Tin quan trong*/
                      if (moduleShow["important_feed"] == true)
                        WidgetNewsImportantBox(),

                      /* Dia diem xung quanh*/
                      if (moduleShow["services"] == true &&
                          overlayState.currentBuilding.long != null &&
                          overlayState.currentBuilding.lat != null)
                        WidgetNearByServiceBox(
                            point: overlayState.currentBuilding.lat.toString() +
                                "," +
                                overlayState.currentBuilding.long.toString()),

                      /* Tien ich toa nha*/
                      if (moduleShow["facilities"] == true)
                        WidgetFacilitiesBox()
                    ]));
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  bool _checkBuildingShownFirstTime(String text) =>
      Storage.getWelcome() != text;

  Future<bool> saveWelcomeToStorage(String data) =>
      Future.sync(() => Storage.saveWelcome(data));

  void showBrandWelcomePopup(BuildingMessageModel building) => showDialog(
      context: Storage.scaffoldKey.currentContext, //context,
      barrierDismissible: false,
      builder: (_) {
        return FirstBrandDialog(
            building: building,
            callback: () {
              onDismissFirstBrandPopup(Storage.scaffoldKey.currentContext);
            });
      });

  Future<void> onDismissFirstBrandPopup(BuildContext context) async {
    Navigator.of(context).pop();
    await checkVersion();
  }

  final _versionRepo = VersionRepository();

  Future<void> checkVersion() async {
    Future.delayed(Duration.zero, () async {
      final version = await _versionRepo.getVersion();
      bool _isValid = false;
      String _version1 =
          Platform.isAndroid ? version.citizenAndroid : version.citizenIos;
      String _version2 = AppConstant.appVersion;
      if (version.forceUpdate == true) {
        if (compareVerion(_version1, _version2)) {
          _isValid = true;
        }
      }

      if (_isValid) {
        AppDialog.showSimpleDialog(
          Storage.scaffoldKey.currentContext,
          <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(AppVectors.icNewVersion),
                  const SizedBox(height: 20),
                  Text(
                      LocalizationsUtil.of(Storage.scaffoldKey.currentContext)
                          .translate('new_version_is_available'),
                      textAlign: TextAlign.center,
                      style: AppFonts.bold24),
                  const SizedBox(height: 20),
                  Text(
                    LocalizationsUtil.of(Storage.scaffoldKey.currentContext)
                        .translate(
                            'new_version_is_available_please_update_for_a_better_experience'),
                    textAlign: TextAlign.center,
                    style: AppFonts.medium16.copyWith(
                      color: Color(0xff838383),
                    ),
                  ),
                  const SizedBox(height: 30),
                  WidgetButton.pink(
                    LocalizationsUtil.of(Storage.scaffoldKey.currentContext)
                        .translate('update_houze_super'),
                    callback: () {
                      StoreRedirect.redirect(
                          androidAppId: version.citizenAndroidStore,
                          iOSAppId: version.citizenIosStore);
                    },
                  ),
                ],
              ),
            )
          ],
          barrierDismissible: false,
        );
      }
    });
  }

  bool compareVerion(String v1, String v2) {
    var a1 = v1.split('.');
    var a2 = v2.split('.');
    var sum1 = 0;
    var sum2 = 0;
    for (var i = 0; i < a1.length; i++) {
      sum1 += (int.parse(a1[i]) * pow(100, (a1.length - 1 - i)));
      sum2 += (int.parse(a2[i]) * pow(100, (a1.length - 1 - i)));
    }
    print("sum1: $sum1");
    print("sum2: $sum1");
    return (sum1 > sum2);
  }

  void processAfterGetBuildingSuccess(BuildingMessageModel model) {
    final bool _valid = _checkBuildingShownFirstTime(model.id);
    if (_valid) {
      saveWelcomeToStorage(model.id).then((value) {
        if (value) {
          showBrandWelcomePopup(model);
        }
      }).catchError((e) {
        print(e);
      });
    } else {
      checkVersion();
    }
  }

  void _navigateToNoBuildingPage() {
    AppRouter.pushReplacement(
      Storage.scaffoldKey.currentContext,
      AppRouter.building404,
      NoBuildingScreenArgument(
        bloc: _overlayBloc,
      ),
    );
  }
}
