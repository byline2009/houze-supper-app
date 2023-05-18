import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/blocs/overlay/index.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/ws/chat_controller.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/chat/index.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';

import '../index.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: <BlocProvider>[
      BlocProvider<OverlayBloc>(create: (_) => OverlayBloc()),
      BlocProvider<TabbarTitleBloc>(create: (_) => TabbarTitleBloc()),
    ], child: CommunityView());
  }
}

class CommunityView extends StatefulWidget {
  const CommunityView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommunityViewState();
}

class _CommunityViewState extends RouteAwareState<CommunityView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<CommunityTabItem> tabs;

  @override
  void initState() {
    super.initState();
    ChatController().connectToServer();

    tabs = [
      CommunityTabItem(
        title: 'k_conversation',
        icon: AppVectors.icChatLight,
      ),
      // CommunityTabItem(
      //   title: 'k_run',
      //   icon: AppVectors.icRun,
      // ),
    ];

    _tabController = getTabController();
  }

  TabController getTabController() => TabController(
        length: CommunityTab.values.length,
        vsync: this,
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverlayBloc, OverlayBlocState>(
      builder: (context, overlayState) {
        if (overlayState is AppInitial) {
          context.read<OverlayBloc>().add(BuildingPicked());
        }
        BuildingMessageModel _currentBuilding = Sqflite.currentBuilding!;

        if (overlayState is PickBuildingSuccessful) {
          _currentBuilding = overlayState.currentBuilding;
        }
        return CommunityScaffold(
          tabController: _tabController,
          tabs: tabs.toList(),
          title: _buildTitle(
            _currentBuilding,
          ),
          child: overlayState is BuildingFailure
              ? SomethingWentWrong()
              : overlayState is PickBuildingSuccessful
                  ? TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SafeArea(
                          top: false,
                          bottom: false,
                          child: Builder(
                            builder: (BuildContext context) {
                              return ConversationPage(
                                building: _currentBuilding,
                              );
                            },
                          ),
                        ),
                        // SafeArea(
                        //   top: false,
                        //   bottom: false,
                        //   child: Builder(
                        //     builder: (BuildContext context) {
                        //       return RunPage();
                        //     },
                        //   ),
                        // ),
                      ].toList(),
                    )
                  : CupertinoActivityIndicator(),
        );
      },
    );
  }

  Widget _buildTitle(
    BuildingMessageModel currentBuilding,
  ) {
    return SafeArea(
      top: true,
      child: GestureDetector(
        onTap: () async {
          await Sqflite.getBuildingList().then(
            (value) => SwitchBuilding.showBottomSheet(
              buildings: value,
              currentBuildingID: currentBuilding.id!,
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
                    currentBuilding.name!,
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
    _tabController.dispose();
    super.dispose();
  }
}

// enum CommunityTab { Conversation, Run }
enum CommunityTab { Conversation }
