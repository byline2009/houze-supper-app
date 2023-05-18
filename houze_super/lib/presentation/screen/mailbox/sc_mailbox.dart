import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:houze_super/app/bloc/overlay/index.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/presentation/custom_ui/appbar/widget_appbar_gradient.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/widget_bottom_sheet_switch_building.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/index.dart';

import 'ticket/page_ticket.dart';

class NaviagationTab extends Equatable {
  final String title;
  final Widget screen;
  const NaviagationTab({
    this.title,
    this.screen,
  });

  @override
  List<Object> get props => [
        title,
        screen,
      ];
}

class MailboxScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MailboxScreenState();
}

class _MailboxScreenState extends State<MailboxScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  final listItems = <String>[];

  final tabs = <NaviagationTab>[];

  final OverlayBloc overlayBloc = OverlayBloc();
  final tabbarBloc = TabbarTitleBloc();

  final _tabviewFeed = TabViewFeed();
  final _tabviewTicket = TabViewTicket();

  bool _isTabviewFeed = true;
  bool isBuildingChanged = false;
  bool isCommingFromOtherPage = true;

  @override
  void initState() {
    super.initState();

    tabs.addAll([
      NaviagationTab(
        title: "announcement",
        screen: _tabviewFeed,
      ),
      NaviagationTab(
        title: "request_0",
        screen: _tabviewTicket,
      ),
    ]);

    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Widget _titleBox = SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Column(
          children: <Widget>[
            Text(
              LocalizationsUtil.of(context).translate('inbox'),
              style: AppFonts.bold18.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '',
                  style: AppFonts.semibold13.copyWith(color: Color(0xffdac0ff)),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Colors.white,
                )
              ],
            )
          ],
        ),
      ),
    );

    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<OverlayBloc>(create: (_) => overlayBloc),
        BlocProvider<TabbarTitleBloc>(create: (_) => tabbarBloc),
      ],
      child: BlocBuilder<OverlayBloc, OverlayBlocState>(
        builder: (context, overlayState) {
          if (overlayState is AppInitial) overlayBloc.add(BuildingPicked());

          if (overlayState is PickBuildingSuccessful) {
            _titleBox = _buildTitle(
              context,
              overlayState.currentBuilding,
              overlayState.buildings,
            );

            if (_isTabviewFeed == false) {
              _tabviewFeed.onRefresh();
            }

            _isTabviewFeed = false;

            if (isBuildingChanged == true || isCommingFromOtherPage) {
              _tabviewTicket.onRefresh();
              isBuildingChanged = false;
              isCommingFromOtherPage = false;
            }

            if (_tabviewTicket.getRefresh()) {
              overlayBloc.add(BuildingPicked());
              _tabviewTicket.setRefresh(false);
            }

            return BaseScaffoldGradient(
              centerTitle: true,
              isScrollableTab: true,
              title: _titleBox,
              child: _buildBodyTabbar(),
              controller: _tabController,
              tabs: tabs.map((f) => f.title).toList(),
            );
          }

          if (overlayState is BuildingFailure &&
              overlayState.error.error is! NoDataToLoadMoreException) {
            if (overlayState.error.error is NoDataException)
              return SomethingWentWrong(true);
            else
              return SomethingWentWrong();
          }

          return BaseScaffoldGradient(
            centerTitle: true,
            isScrollableTab: true,
            title: _titleBox,
            child: _buildBodyTabbar(),
            controller: _tabController,
            tabs: tabs.map((f) => f.title).toList(),
          );
        },
      ),
    );
  }

  _buildTitle(
    BuildContext context,
    BuildingMessageModel currentBuilding,
    List<BuildingMessageModel> buildings,
  ) {
    return SafeArea(
      top: true,
      child: GestureDetector(
        onTap: () {
          SwitchBuilding.showBottomSheet(
            buildings: buildings,
            currentBuildingID: currentBuilding.id,
            contextParent: context,
          );
          isBuildingChanged = true;
        },
        child: Container(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
          child: Column(
            children: <Widget>[
              Text(LocalizationsUtil.of(context).translate('inbox'),
                  style: AppFonts.bold18.copyWith(color: Colors.white)),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    currentBuilding.name,
                    style:
                        AppFonts.semibold13.copyWith(color: Color(0xffdac0ff)),
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

  _buildBodyTabbar() {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: tabs
          .map(
            (e) => SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return e.screen;
                },
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
