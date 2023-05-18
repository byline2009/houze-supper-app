import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/poll_repo.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/chat/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/view/tab_item_discussion.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/user_permission_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/view/tab_item_poll.dart';

/*
 Tab: Conversation (Trò chuyện)
 */

//enum EnumConversationTab { chat, discussion, poll }
enum EnumConversationTab { discussion, poll }

class ConversationPage extends StatefulWidget {
  final BuildingMessageModel building;
  const ConversationPage({
    required this.building,
  });
  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends RouteAwareState<ConversationPage>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ConversationPage> {
  late TabController controllerTab;
  Future? _future;
  final _repo = PollRepository();
  int _activeIndex = 0;

  Future<List> _fetchPermissionAndCurrentBuilding() async {
    UserPermission? _userPermission = await _repo.getUserPermission(
      currentBuilding: widget.building,
    );
    return [_userPermission, widget.building];
  }

  @override
  void initState() {
    _future = _fetchPermissionAndCurrentBuilding();
    controllerTab = getTabController();
    super.initState();
  }

  TabController getTabController() =>
      TabController(length: EnumConversationTab.values.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CupertinoActivityIndicator();
          }

          if (snapshot.hasError) {
            print('****** tabview_conversation.class ERROR: ' +
                snapshot.error.toString());
            return SomethingWentWrong();
          }
          List<Tab> _listTab = [];
          List<Widget> _listWidget = [];

          final _building = snapshot.data[1] as BuildingMessageModel;
          final _permission = snapshot.data[0] as UserPermission;

          if (_building.service != "z") {
            //check permission to access discussion tab
            _listTab = _permission.canAccess
                ? [
                    // Tab(text: LocalizationsUtil.of(context).translate('k_sms')),
                    Tab(
                        text:
                            LocalizationsUtil.of(context).translate('voting')),
                    Tab(
                        text: LocalizationsUtil.of(context)
                            .translate('k_discuss'))
                  ]
                : [
                    // Tab(text: LocalizationsUtil.of(context).translate('k_sms')),
                    Tab(
                        text:
                            LocalizationsUtil.of(context).translate('voting')),
                  ];

            _listWidget = _permission.canAccess
                ? [
                    // MessageTabItem(
                    //   key: Key('MessageTabItem'),
                    // ),
                    TabItemPoll(),
                    TabItemDiscussion(widget.building),
                  ]
                : [
                    // MessageTabItem(
                    //   key: Key('MessageTabItem'),
                    // ),
                    TabItemPoll(),
                  ];

            if (!_permission.canAccess) {
              this.controllerTab = TabController(
                  length: 2, vsync: this, initialIndex: _activeIndex);
            }
          } else {
            // if service is "z", disable houze forum
            _listTab = [
              Tab(
                  text:
                      LocalizationsUtil.of(context).translate('k_conversation'))
            ];
            _listWidget = [
              Center(
                child: Text("Chức năng này hiện không khả dụng"),
              ),
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              TabBar(
                controller: controllerTab,
                labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                indicatorPadding: const EdgeInsets.all(1.5),
                indicatorColor: RunConstant.participating,
                labelStyle: AppFonts.bold18.copyWith(color: Color(0xff6001d2)),
                labelColor: RunConstant.participating,
                unselectedLabelStyle:
                    AppFonts.bold15.copyWith(color: RunConstant.notCompleted),
                unselectedLabelColor: Color(0xffb5b5b5),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: RoundedRectIndicator(
                    color: RunConstant.participating,
                    radius: 65,
                    padding: 40,
                    weight: 2.0),
                isScrollable: true,
                tabs: _listTab,
              ),
              Flexible(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controllerTab,
                  children: _listWidget,
                ),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    controllerTab.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;
}
