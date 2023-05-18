import 'package:flutter/material.dart';
import 'package:houze_super/presentation/custom_ui/rounded_rect_indicator.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler(int index);

class BaseScaffoldGradient extends StatefulWidget {
  final bool centerTitle;

  final bool isScrollableTab;
  final Widget title;
  final Widget child;
  final List<String> tabs;
  final TabController controller;
  final Widget trailing;
  BaseScaffoldGradient(
      {@required this.centerTitle,
      @required this.isScrollableTab,
      @required this.title,
      @required this.child,
      @required this.tabs,
      @required this.controller,
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
          floating: true,
          centerTitle: true,
          pinned: true,
          snap: true,
          actions: <Widget>[
            widget.trailing ?? const SizedBox.shrink(),
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
              ),
            ),
            child: FlexibleSpaceBar(
              centerTitle: widget.centerTitle ?? false,
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
                isScrollable: widget.isScrollableTab ?? false,
                controller: widget.controller,
                tabs: widget.tabs
                    .map((String name) => Tab(
                        text: LocalizationsUtil.of(context).translate(name)))
                    .toList(),
                labelColor: Colors.white,
                labelStyle: AppFonts.bold15.copyWith(color: Colors.white),
                unselectedLabelColor: Color(0xffdac0ff),
                unselectedLabelStyle:
                    AppFonts.bold15.copyWith(color: Color(0xffdac0ff)),
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
