import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

import '../rounded_rect_indicator.dart';

typedef void CallBackHandler(int index);

class BaseScaffoldGradient extends StatefulWidget {
  final bool centerTitle;

  final bool isScrollableTab;
  final Widget title;
  final Widget child;
  final List<String> tabs;
  final TabController controller;
  final Widget? trailing;
  BaseScaffoldGradient(
      {required this.centerTitle,
      required this.isScrollableTab,
      required this.title,
      required this.child,
      required this.tabs,
      required this.controller,
      this.trailing});

  @override
  State<StatefulWidget> createState() => _BaseScaffoldGradientState();
}

class _BaseScaffoldGradientState extends State<BaseScaffoldGradient> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (
          BuildContext context,
          bool innerBoxIsScrolled,
        ) {
          return <Widget>[
            _buildAppBarGradient(
              context,
              innerBoxIsScrolled,
            ),
          ];
        },
        body: widget.child,
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
          actions: <Widget>[
            widget.trailing ?? Center(),
          ],
          leading: SizedBox.shrink(),
          floating: true,
          pinned: true,
          snap: true,
          flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.purple_725ef6,
                  AppColor.purple_6001d1,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: FlexibleSpaceBar(
              centerTitle: widget.centerTitle,
              background: widget.title,
              collapseMode: CollapseMode.pin,
            ),
          ),
          forceElevated: innerBoxIsScrolled,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: widget.isScrollableTab,
                controller: widget.controller,
                tabs: widget.tabs
                    .map((String name) => Tab(
                        text: LocalizationsUtil.of(context).translate(name)))
                    .toList(),
                labelColor: Colors.white,
                labelStyle: AppFont.BOLD_WHITE_15,
                unselectedLabelColor: AppColor.purple_dac0ff,
                unselectedLabelStyle: AppFont.BOLD_PURPLE_DAC0FF_15,
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
    );
  }
}
