import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/networking/poll_repo.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/view/tab_item_poll.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/view/tab_item_disscution.dart';
import 'package:houze_super/utils/index.dart';
import '../../index.dart';
import 'index.dart';
/*
 * Screen: Trò chuyện
 */

enum EnumConversationTab { chat, discussion, poll }

class TabViewConversation extends StatefulWidget {
  final String buildingID;
  const TabViewConversation({
    @required this.buildingID,
  });
  @override
  _TabViewConversationState createState() => _TabViewConversationState();
}

class _TabViewConversationState extends State<TabViewConversation>
    with TickerProviderStateMixin {
  TabController controllerTab;
  Future _future;
  final _repo = PollRepository();
  int _activeIndex = 0;

  Future<dynamic> _fetch() async {
    final _userPermission = await _repo.getUserPermission();
    final _currentBuilding = await Sqflite.getCurrentBuilding();
    return [_userPermission, _currentBuilding];
  }

  @override
  void initState() {
    _future = _fetch();
    controllerTab = getTabController();
    super.initState();
  }

  TabController getTabController() =>
      TabController(length: EnumConversationTab.values.length, vsync: this);

  @override
  void dispose() {
    controllerTab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return CupertinoActivityIndicator();
          }

          if (snap.hasError) {
            return Container(
              child: Center(
                  child: Text(LocalizationsUtil.of(context).translate(
                      "there_is_an_issue_please_try_again_later_0"))),
            );
          }
          List<Tab> _listTabBar;
          List<Widget> _listWidget;

          if (snap.data[1].service != "z") {
            //check permisstion to access discussion tab
            _listTabBar = snap.data[0].canAccess
                ? [
                    Tab(text: LocalizationsUtil.of(context).translate('k_sms')),
                    Tab(
                        text:
                            LocalizationsUtil.of(context).translate('voting')),
                    Tab(
                        text: LocalizationsUtil.of(context)
                            .translate('k_discuss')),
                  ]
                : [
                    Tab(text: LocalizationsUtil.of(context).translate('k_sms')),
                    Tab(
                        text:
                            LocalizationsUtil.of(context).translate('voting')),
                  ];

            _listWidget = snap.data[0].canAccess
                ? [
                    TabItemMessage(
                      key: Key('TabItemMessage'),
                      buildingID: widget.buildingID,
                    ),
                    TabItemPoll(),
                    TabItemDiscussion(),
                  ]
                : [
                    TabItemMessage(
                      key: Key('TabItemMessage'),
                      buildingID: widget.buildingID,
                    ),
                    TabItemPoll(),
                  ];

            if (!snap.data[0].canAccess) {
              this.controllerTab = TabController(
                  length: 2, vsync: this, initialIndex: _activeIndex);
            }
          } else {
            // if service is "z", disable houze forum
            _listTabBar = [
              Tab(text: LocalizationsUtil.of(context).translate('k_sms'))
            ];
            _listWidget = [
              TabItemMessage(
                key: Key('TabItemMessage'),
                buildingID: widget.buildingID,
              )
            ];
            this.controllerTab = TabController(
                length: 1, vsync: this, initialIndex: _activeIndex);
          }

          controllerTab.addListener(() {
            if (controllerTab.indexIsChanging) {
              setState(() {
                _activeIndex = controllerTab.index;
              });
            }
          });

          return Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  TabBar(
                    controller: controllerTab,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                    indicatorPadding: const EdgeInsets.all(2),
                    indicatorColor: RunConstant.participating,
                    labelStyle:
                        AppFonts.bold18.copyWith(color: Color(0xff6001d2)),
                    labelColor: RunConstant.participating,
                    unselectedLabelStyle: AppFonts.bold15
                        .copyWith(color: RunConstant.notCompleted),
                    unselectedLabelColor: Color(0xffb5b5b5),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: RoundedRectIndicator(
                        color: RunConstant.participating,
                        radius: 65,
                        padding: 25,
                        weight: 2.0),
                    isScrollable: true,
                    tabs: _listTabBar,
                  ),
                  Flexible(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: controllerTab,
                      children: _listWidget,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
