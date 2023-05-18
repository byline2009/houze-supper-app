import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/utils/index.dart';

import '../../../common_widgets/custom_refresh_indicator/src/indicators/bubble_tab_indicator.dart';

typedef void CallBackHandler(int index);

class CommunityTabItem extends Equatable {
  final String title;
  final String icon;
  const CommunityTabItem({
    @required this.title,
    @required this.icon,
  });

  @override
  List<Object> get props => [
        title,
        icon,
      ];
}

class CommunityScaffold extends StatelessWidget {
  final bool centerTitle;
  final bool isScrollableTab;
  final Widget title;
  final Widget child;
  final List<CommunityTabItem> tabs;
  final TabController controller;
  final Widget trailing;
  CommunityScaffold(
      {@required this.centerTitle,
      @required this.isScrollableTab,
      @required this.title,
      @required this.child,
      @required this.tabs,
      @required this.controller,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            _buildAppBarGradient(context, innerBoxIsScrolled),
          ];
        },
        body: child,
      ),
    );
  }

  Widget _buildAppBarGradient(BuildContext context, bool innerBoxIsScrolled) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverSafeArea(
        top: false,
        bottom: false,
        sliver: SliverAppBar(
          expandedHeight: AppConstant.appbarHeightExpanded,
          floating: true,
          pinned: true,
          centerTitle: true,
          actions: <Widget>[
            trailing ?? const SizedBox.shrink(),
          ],
          leading: const SizedBox.shrink(),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color(0xff725ef6),
                Color(0xff6001d1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: FlexibleSpaceBar(
                centerTitle: centerTitle ?? false,
                background: title,
                collapseMode: CollapseMode.pin),
          ),
          forceElevated: innerBoxIsScrolled,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Align(
              alignment: Alignment.center,
              child: TabBar(
                isScrollable: isScrollableTab ?? false,
                controller: controller,
                labelColor: Colors.white,
                labelStyle: AppFonts.bold15.copyWith(color: Colors.white),
                unselectedLabelColor: Color(0xffdac0ff),
                unselectedLabelStyle:
                    AppFonts.bold15.copyWith(color: Color(0xffdac0ff)),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 36.0,
                  indicatorColor: Color(0xff3a0093),
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  indicatorRadius: 30,
                ),
                tabs: tabs
                    .map(
                      (CommunityTabItem item) => Tab(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                item.icon,
                                width: 16.0,
                                height: 16.0,
                              ),
                              const SizedBox(width: 5),
                              Text(LocalizationsUtil.of(context)
                                  .translate(item.title))
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
