import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/widget_floating_button.dart';

import 'package:houze_super/presentation/index.dart';

import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';

/*Tab: Phản ánh */
class TabViewTicket extends StatefulWidget {
  _TabViewTicketState? state;

  @override
  State<StatefulWidget> createState() {
    state = _TabViewTicketState();
    return state!;
  }

  void onRefresh() => state?.onRefresh();
  bool getRefresh() => state?.getRefresh() ?? false;
  void setRefresh(bool isRefresh) => state?.setRefresh(isRefresh);
}

class _TabViewTicketState extends State<TabViewTicket>
    with TickerProviderStateMixin {
  late final TabController _nestedTabController;
  late final FeedBloc feedBloc;
  final _tabNameList = <String>[
    'received',
    'processing',
    'completed',
  ];

  final tabTicketStatusReceiver = TabTicketStatusReceiver(
    ticketStatus: 0,
  );

  final tabTicketStatusInProgress = TabTicketStatusInProgress(
    ticketStatus: 1,
  );

  final tabTicketStatusDone = TabTicketStatusDone(
    ticketStatus: 2,
  );

  bool _isRefresh = false;

  final tabWidgets = <Widget>[];

  void onRefresh() {
    if (tabWidgets.isNotEmpty) {
      tabTicketStatusReceiver.onRefresh();
      tabTicketStatusInProgress.onRefresh();
      tabTicketStatusDone.onRefresh();
    }
  }

  @override
  void initState() {
    super.initState();
    feedBloc = BlocProvider.of<FeedBloc>(context);
    tabWidgets.addAll(<Widget>[
      BlocProvider.value(
        child: tabTicketStatusReceiver,
        value: feedBloc,
      ),
      BlocProvider.value(
        child: tabTicketStatusInProgress,
        value: feedBloc,
      ),
      BlocProvider.value(
        child: tabTicketStatusDone,
        value: feedBloc,
      ),
    ]);

    _nestedTabController = TabController(
      length: _tabNameList.length,
      vsync: this,
    );
    // Firebase analytics
    GetIt.instance<FBAnalytics>()
        .sendEventViewAnnouncement(userID: Storage.getUserID() ?? "");
  }

  @override
  void dispose() {
    _nestedTabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                decoration: MailboxStyle.issueTabbarDecor,
                padding: const EdgeInsets.all(5),
                child: TabBar(
                    controller: _nestedTabController,
                    labelPadding: const EdgeInsets.all(0),
                    indicatorPadding: const EdgeInsets.all(0),
                    indicatorColor: Colors.transparent,
                    labelStyle: AppFonts.semibold.copyWith(
                      fontSize: 13,
                    ),
                    indicator: MailboxStyle.indicatorDecor,
                    labelColor: Colors.black,
                    unselectedLabelStyle:
                        AppFonts.semibold13.copyWith(color: Color(0xff9c9c9c)),
                    unselectedLabelColor: Color(0xff9c9c9c),
                    isScrollable: false,
                    tabs: _tabNameList
                        .map((e) => _buildTabItem(title: e))
                        .toList()),
              ),
              Flexible(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _nestedTabController,
                  children: tabWidgets,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 30,
          child: FloatingButtonWidget(
            callback: () {
              _onPressedFloatingBtn();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem({required String title}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.transparent, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(
          Radius.circular(
            4.0,
          ),
        ),
      ),
      child: SizedBox(
        height: 34,
        child: Tab(
          iconMargin: EdgeInsets.zero,
          text: LocalizationsUtil.of(context).translate(title),
        ),
      ),
    );
  }

  void _onPressedFloatingBtn() => AppRouter.pushNoParamsWithCallback(
      context, AppRouter.TICKET_CREATE, (p0) => _onGoBack);

  void _onGoBack(dynamic value) {
    onRefresh();
    setState(() {
      _isRefresh = true;
    });
  }

  bool getRefresh() => _isRefresh;

  setRefresh(bool isRefresh) => _isRefresh = isRefresh;
}
