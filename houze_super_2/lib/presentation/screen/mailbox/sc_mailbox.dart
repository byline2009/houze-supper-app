import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/blocs/index.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/repo/feed_repository.dart';
import 'package:houze_super/presentation/custom_ui/appbar/widget_appbar_gradient.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';

import 'package:houze_super/utils/custom_exceptions.dart';

import 'announcement/bloc/announcement_bloc.dart';

class MailboxPage extends StatelessWidget {
  const MailboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc(),
      child: MailboxView(),
    );
  }
}

class MailboxView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MailboxViewState();
}

class _MailboxViewState extends State<MailboxView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final listItems = <String>[];

  // final tabs = <NaviagationTab>[];

  late final OverlayBloc overlayBloc;

  late final TabViewFeed _tabviewFeed;
  final _tabviewTicket = TabViewTicket();

  bool isBuildingChanged = false;
  bool isCommingFromOtherPage = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    overlayBloc = OverlayBloc();
    _tabviewFeed = TabViewFeed();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider>[
        BlocProvider<OverlayBloc>.value(value: overlayBloc),
        BlocProvider<TabbarTitleBloc>.value(value: TabbarTitleBloc()),
        BlocProvider(
          create: (_) => FeedBloc(),
        )
      ],
      child: BlocBuilder<OverlayBloc, OverlayBlocState>(
        bloc: overlayBloc,
        builder: (context, overlayState) {
          if (overlayState is AppInitial) overlayBloc.add(BuildingPicked());

          if (overlayState is PickBuildingSuccessful) {
            if (isBuildingChanged == true && _tabController.index == 0) {
              _tabviewFeed.onRefresh();
              isBuildingChanged = false;
            }

            if ((isBuildingChanged == true && _tabController.index == 1) ||
                isCommingFromOtherPage) {
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
              title: _buildTitle(
                context,
                overlayState.currentBuilding,
                overlayState.buildings,
              ),
              child: _buildBodyTabbar(),
              controller: _tabController,
              tabs: <String>[
                'announcement',
                'request_0',
              ].map((f) => f).toList(),
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
            title: _buildTitle(
              context,
              null,
              null,
            ),
            child: _buildBodyTabbar(),
            controller: _tabController,
            tabs: <String>[
              'announcement',
              'request_0',
            ].map((f) => f).toList(),
          );
        },
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    BuildingMessageModel? currentBuilding,
    List<BuildingMessageModel>? buildings,
  ) {
    return SafeArea(
      top: true,
      child: GestureDetector(
        onTap: () {
          if (currentBuilding != null &&
              currentBuilding.id?.isNotEmpty == true &&
              buildings != null) {
            SwitchBuilding.showBottomSheet(
              buildings: buildings,
              currentBuildingID: currentBuilding.id!,
              contextParent: context,
            );
            isBuildingChanged = true;
          }
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
                LocalizationsUtil.of(context).translate('inbox'),
                style: AppFonts.bold18.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 3),
              if (currentBuilding != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      currentBuilding.name ?? '',
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
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyTabbar() {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        BlocProvider(
            create: (_) => AnnouncementBloc(feedAPI: FeedRepository()),
            child: _tabviewFeed),
        _tabviewTicket,
      ]
          .map(
            (e) => SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) => e,
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
