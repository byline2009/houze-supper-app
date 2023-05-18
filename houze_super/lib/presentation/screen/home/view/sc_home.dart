import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/point_transaction_repository.dart';
import 'package:houze_super/middle/repo/profile_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateless/empty_page.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';
import 'package:houze_super/presentation/screen/home/tabview/tabview_home.dart';
import 'package:houze_super/presentation/screen/home/widgets/widget_cover_profile.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_point_bloc/index.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

import 'package:flutter/material.dart';
/*--- Screen: Trang chủ
Màn hình hiển thị Trang chủ tab
Bao gồm 4 tab: Toà nhà, BDS, Đầu tư, Dịch vụ
 */

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  TabController _tabController;
  final List<String> nameTabs = <String>[
    "",
  ];
  final _bloc = TabbarTitleBloc();
  String _service;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: nameTabs.length,
      vsync: this,
    );

    Sqflite.getCurrentBuilding().then(
      (value) {
        if (value != null) {
          this._service = value.service + value.type.toString();
          _bloc.add(
              GetTabbarTitle(service: value.service + value.type.toString()));
        } else {
          _bloc.add(GetTabbarTitle(service: "building0"));
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabbarTitleBloc>(
      create: (_) => _bloc,
      child: BlocBuilder<TabbarTitleBloc, String>(
        builder: (BuildContext context, String tabName) {
          if (tabName == null) {
            return const EmptyPage(
              content: 'there_is_no_information',
            );
          }
          if (tabName.length > 0) {
            print("state: " + tabName);
            nameTabs[0] = tabName;
          }

          return NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    bottom: false,
                    sliver: SliverAppBar(
                      expandedHeight: AppConstant.appbarHeightExpanded,
                      centerTitle: true,
                      floating: true,
                      pinned: true,
                      snap: true,
                      actions: const <Widget>[
                        SizedBox.shrink(),
                      ],
                      leading: const SizedBox.shrink(),
                      flexibleSpace: DecoratedBox(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff725ef6),
                              Color(0xff6001d1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: FlexibleSpaceBar(
                          centerTitle: false,
                          background: BlocProvider(
                            create: (contex) => ProfileLoadPointBloc(
                              profileRepo: ProfileRepository(),
                              pointRepo: PointTransationRepository(),
                            ),
                            child: WidgetHeaderCoverProfile(),
                          ),
                          collapseMode: CollapseMode.pin,
                        ),
                      ),
                      forceElevated: innerBoxIsScrolled,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(48),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                            isScrollable: true,
                            controller: _tabController,
                            tabs: nameTabs
                                .map(
                                  (String name) => Tab(
                                    text:
                                        LocalizationsUtil.of(context).translate(
                                      name,
                                    ),
                                  ),
                                )
                                .toList(),
                            labelColor: Colors.white,
                            labelStyle:
                                AppFonts.bold15.copyWith(color: Colors.white),
                            unselectedLabelColor: Color(0xffdac0ff),
                            unselectedLabelStyle: AppFonts.bold15
                                .copyWith(color: Color(0xffdac0ff)),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicator: RoundedRectIndicator(
                              color: Colors.white,
                              radius: 65,
                              padding: 21,
                              weight: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: nameTabs.asMap().entries.map((entry) {
                return SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      if (entry.value.toLowerCase() ==
                          nameTabs[0].toLowerCase()) {
                        return TabViewHome(
                          callback: (service) {
                            if (this._service != service) {
                              _bloc.add(GetTabbarTitle(service: service));
                            }
                          },
                          tabKey: Key('Tab${entry.key}'),
                          tabName: entry.value,
                        );
                      }
                      return TabViewService(
                        tabKey: Key('Tab${entry.key}'),
                        tabName: entry.value,
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
