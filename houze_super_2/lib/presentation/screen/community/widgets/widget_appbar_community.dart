import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/indicators/bubble_tab_indicator.dart';

import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler(int index);

class CommunityTabItem extends Equatable {
  final String title;
  final String icon;
  const CommunityTabItem({
    required this.title,
    required this.icon,
  });

  @override
  List<Object> get props => [
        title,
        icon,
      ];
}

class CommunityScaffold extends StatelessWidget {
  final Widget title;
  final Widget child;
  final List<CommunityTabItem> tabs;
  final TabController tabController;
  final double? headerSize;
  const CommunityScaffold({
    required this.title,
    required this.child,
    required this.tabs,
    required this.tabController,
    this.headerSize,
  });

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
        sliver: SliverAppBar(
          expandedHeight: headerSize ?? AppConstant.appbarHeightExpanded,
          floating: true,
          pinned: true,
          snap: true,
          centerTitle: true,
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
              centerTitle: true,
              background: title,
              collapseMode: CollapseMode.pin,
            ),
          ),
          forceElevated: innerBoxIsScrolled,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(51),
            child: Align(
              alignment: Alignment.topLeft,
              child: TabBar(
                padding: const EdgeInsets.only(left: 10, bottom: 3),
                isScrollable: true,
                controller: tabController,
                indicatorPadding: EdgeInsets.zero,
                labelColor: Colors.white,
                labelStyle: AppFonts.bold15.copyWith(
                  color: Colors.white,
                ),
                unselectedLabelColor: Color(0xffdac0ff),
                unselectedLabelStyle: AppFonts.bold15.copyWith(
                  color: Color(
                    0xffdac0ff,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const BubbleTabIndicator(
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
                            horizontal: 5,
                            vertical: 8,
                          ),
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
