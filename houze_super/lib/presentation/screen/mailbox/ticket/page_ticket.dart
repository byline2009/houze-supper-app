import 'package:flutter/material.dart';

import 'package:houze_super/presentation/common_widgets/stateless/widget_floating_button.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/tab_ticket_inprogress.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/tab_ticket_status_done.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/tab_ticket_status_receiver.dart';
import 'package:houze_super/presentation/screen/ticket/sc_ticket_create.dart';

import 'package:houze_super/utils/index.dart';

/*Tab: Phản ánh */
class TabViewTicket extends StatefulWidget {
  _TabViewTicketState state;

  @override
  State<StatefulWidget> createState() {
    state = _TabViewTicketState();
    return state;
  }

  void onRefresh() => state?.onRefresh();
  bool getRefresh() => state?.getRefresh() ?? false;
  void setRefresh(bool isRefresh) => state?.setRefresh(isRefresh);
}

class _TabViewTicketState extends State<TabViewTicket>
    with TickerProviderStateMixin {
  TabController _nestedTabController;

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

    tabWidgets.addAll(<Widget>[
      tabTicketStatusReceiver,
      tabTicketStatusInProgress,
      tabTicketStatusDone,
    ]);

    _nestedTabController = TabController(
      length: _tabNameList.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    if (_nestedTabController != null) _nestedTabController.dispose();

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

  Widget _buildTabItem({String title}) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.transparent, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(
          Radius.circular(
            4.0,
          ),
        ),
      ),
      child: Tab(
        iconMargin: EdgeInsets.zero,
        text: LocalizationsUtil.of(context).translate(title),
      ),
    );
  }

  void _onPressedFloatingBtn() => Navigator.push(
          context, MaterialPageRoute(builder: (context) => SendRequestPage()))
      .then(_onGoBack);

  _onGoBack(dynamic value) {
    onRefresh();
    setState(() {
      _isRefresh = true;
    });
  }

  bool getRefresh() => _isRefresh;

  setRefresh(bool isRefresh) => _isRefresh = isRefresh;
}
