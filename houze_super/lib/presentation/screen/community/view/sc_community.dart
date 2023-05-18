import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/bloc/index.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/repo/achievement_repo.dart';
import 'package:houze_super/middle/repo/challenge_repository.dart';
import 'package:houze_super/middle/repo/statistic_repo.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/chat/views/index.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/index.dart';
import 'package:houze_super/presentation/screen/community/run/blocs/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/blocs/dashboard/index.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import '../index.dart';
import '../conversation/index.dart';

import 'package:flutter/cupertino.dart';
import 'package:houze_super/utils/index.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<CommunityTabItem> tabs;

  @override
  void initState() {
    super.initState();
    tabs = [
      CommunityTabItem(
        title: 'k_conversation',
        icon: AppVectors.icChatLight,
      ),
      CommunityTabItem(
        title: 'k_run',
        icon: AppVectors.icRun,
      ),
    ];

    _tabController = getTabController();
  }

  TabController getTabController() => TabController(
        length: CommunityTab.values.length,
        vsync: this,
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<OverlayBloc>(create: (_) => OverlayBloc()),
        BlocProvider<TabbarTitleBloc>(create: (_) => TabbarTitleBloc()),
      ],
      child: BlocBuilder<OverlayBloc, OverlayBlocState>(
        builder: (context, overlayState) {
          if (overlayState is AppInitial) {
            context.read<OverlayBloc>().add(BuildingPicked());
          }

          final BuildingMessageModel currentBuilding = Sqflite.currentBuilding;
          Widget _titleWidget = const SizedBox.shrink();
          Widget _bodyWidget = const SizedBox.shrink();

          if (overlayState is OverlayLoading) {
            _titleWidget = _buildTitle(
              context,
              currentBuilding,
            );
            _bodyWidget = const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (overlayState is BuildingFailure) {
            _bodyWidget = const SomethingWentWrong();
            if (overlayState.error is NoDataException) {
              _bodyWidget = const SomethingWentWrong(true);
            }
          }
          if (overlayState is PickBuildingSuccessful) {
            _titleWidget = _buildTitle(
              context,
              overlayState.currentBuilding,
            );
            _bodyWidget = _buildBodyTabbar(
              overlayState.currentBuilding,
            );
          }
          return CommunityScaffold(
            centerTitle: true,
            isScrollableTab: true,
            controller: _tabController,
            tabs: tabs.toList(),
            title: _titleWidget,
            child: _bodyWidget,
          );
        },
      ),
    );
  }

  Widget _buildBodyTabbar(
    BuildingMessageModel model,
  ) {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (BuildContext context) {
              return TabViewConversation(
                buildingID: model.id,
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (BuildContext context) {
              return BlocProvider(
                create: (context) => RunLoadDataBloc(
                  dashboardBloc: DashboardBloc(
                    repo: StatisticRepository(),
                  ),
                  statisticChartBloc: StatisticChartBloc(
                    repo: StatisticRepository(),
                  ),
                  challengeBloc: ChallengeBloc(
                    repo: ChallengeRepository(),
                  ),
                  achievementBloc: AchievementBloc(
                    repo: AchievementRepository(),
                  ),
                ),
                child: TabViewRun(
                  building: model,
                ),
              );
            },
          ),
        ),
      ].toList(),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    BuildingMessageModel currentBuilding,
  ) {
    return SafeArea(
      top: true,
      child: GestureDetector(
        onTap: () async {
          await Sqflite.getBuildingList().then(
            (value) => SwitchBuilding.showBottomSheet(
              buildings: value,
              currentBuildingID: currentBuilding.id,
              contextParent: context,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: <Widget>[
              Text(
                LocalizationsUtil.of(context).translate('community'),
                style: AppFonts.bold18.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    currentBuilding.name,
                    style: AppFonts.semibold13.copyWith(
                      color: Color(
                        0xffdac0ff,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (mounted) {
      if (_tabController != null) _tabController.dispose();
    }
    super.dispose();
  }
}

enum CommunityTab { Conversation, Run }
