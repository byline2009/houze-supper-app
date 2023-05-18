import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:houze_super/app/blocs/index.dart';
import 'package:houze_super/app/common/app_event_bloc.dart';
import 'package:houze_super/middle/repo/achievement_repo.dart';
import 'package:houze_super/middle/repo/statistic_repo.dart';
import 'package:houze_super/middle/repo/challenge_repository.dart';
import 'package:houze_super/presentation/screen/community/run/blocs/index.dart';
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

class RunPage extends StatelessWidget {
  const RunPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentBuilding = context.select((OverlayBloc bloc) =>
        (bloc.state is PickBuildingSuccessful)
            ? (bloc.state as PickBuildingSuccessful).currentBuilding
            : Sqflite.currentBuilding);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => StatisticRepository()),
        RepositoryProvider(create: (_) => AchievementRepository()),
        RepositoryProvider(create: (_) => ChallengeRepository()),
      ],
      child: BlocProvider(
        create: (context) => RunBloc(
          statisticRepository:
              RepositoryProvider.of<StatisticRepository>(context),
          achievementRepository:
              RepositoryProvider.of<AchievementRepository>(context),
          challengeRepository:
              RepositoryProvider.of<ChallengeRepository>(context),
        ),
        child: _TabViewRun(
          building: currentBuilding!,
        ),
      ),
    );
  }
}

class _TabViewRun extends StatefulWidget {
  final BuildingMessageModel building;

  const _TabViewRun({
    required this.building,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabViewRunState();
}

class _TabViewRunState extends State<_TabViewRun> {
  final _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _checkNetworkStream;
  late StreamSubscription<BlocEvent> _subChallengeUpdateItem;
  late List<EventModel> events;
  final ProgressHUD progressToolkit = Progress.instanceCreateCirle();
  
  @override
  void initState() {
    super.initState();

    _initVariable();
    _initConnectivity();
    _initLisenter();
    context.read<RunBloc>().add(
          RunEvent(
            buildingID: widget.building.id!,
          ),
        );
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

  void _handleChallengeUpdateItem(dynamic evt) {
    final value = evt.value;

    if (mounted && value is EventModel) {
      final int index = events.indexWhere((element) => element.id == value.id);
      if (index >= 0)
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
    bool hasError = false;

    final file = await FileUtil.singleton.getFile('run_log');

    if (file == null) return;

    final _file = File(file.path);

    DialogCustom.showAlertDialog(
      context: context,
      title: "announcement",
      content: "would_you_like_to_send_your_last_run_activity_to_houze_server",
      buttonText: "ok",
      onPressed: () async {
        final activityUpdate = await RunRequest().sendActivity(
          _file,
          progressToolkit,
        );

        Navigator.of(context).pop();

        hasError = activityUpdate == null;
      },
    ).then(
      (value) {
        if (hasError)
          DialogCustom.showErrorDialog(
              context: context,
              title: 'network_connection_error',
              errMsg: 'there_is_an_issue_please_try_again_later_1',
              buttonText: 'back',
              callback: () {});
        else
          DialogCustom.showSuccessDialog(
            context: context,
            title: 'send_successfully',
            content: 'your_last_run_activity_is_posted_successfully',
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                context.read<RunBloc>().add(
                      RunEvent(
                        buildingID: widget.building.id!,
                      ),
                    );
              },
            );
          },
          child: CustomScrollView(
            key: const PageStorageKey<String>('TabViewRun'),
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                key: const Key('SummaryStatisticSection'),
                child: WidgetBoxesContainer(
                  child: SummaryStatisticSection(),
                ),
              ),
              SliverToBoxAdapter(
                key: const Key('AchievementListWidget'),
                child: WidgetBoxesContainer(
                  hasLine: true,
                  child: AchievementListWidget(),
                ),
              ),
              SliverToBoxAdapter(
                key: const Key('EventListWidget'),
                child: EventListWidget(),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 120,
                ),
              )
            ],
          ),
        ),
        buildButtonRunNow(),
        progressToolkit,
      ],
    );
  }

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

      case geo.LocationPermission.deniedForever:
        return false;
      case geo.LocationPermission.whileInUse:
      case geo.LocationPermission.always:
        return true;
      default:
        return false;
    }
  }

  void _onCallBack(dynamic value) async {
    await Future.delayed(Duration.zero, () {
      context.read<RunBloc>().add(
            RunEvent(
              buildingID: widget.building.id!,
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
    _checkNetworkStream.cancel();
    _subChallengeUpdateItem.cancel();
    super.dispose();
  }
}
