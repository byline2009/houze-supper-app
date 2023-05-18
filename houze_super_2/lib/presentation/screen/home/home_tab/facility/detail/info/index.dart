import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/detail/info/tab_introdution.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/detail/info/tab_terms.dart';

import 'package:houze_super/utils/index.dart';

class FacilityInfoScreen extends StatefulWidget {
  final FacilityDetailModel? args;

  FacilityInfoScreen({Key? key, this.args}) : super(key: key);

  @override
  _FacilityInfoScreenState createState() => _FacilityInfoScreenState();
}

class _FacilityInfoScreenState extends RouteAwareState<FacilityInfoScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  int onTab = -1;
  late FacilityDetailModel _model;

  @override
  void initState() {
    super.initState();

    _model = widget.args!;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              LocalizationsUtil.of(context).translate(_model.title),
              style: AppFonts.medium16,
            ),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: AppColor.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0.0,
            bottom: TabBar(
              labelStyle: AppFonts.medium14,
              labelColor: AppColor.black,
              unselectedLabelColor: AppColor.gray_808080,
              unselectedLabelStyle: AppFonts.medium14.copyWith(
                color: Color(
                  0xff5B00E4,
                ),
              ),
              onTap: (index) {
                onTab = index;
              },
              tabs: [
                Tab(
                    child: Text(
                  LocalizationsUtil.of(context).translate("introduction"),
                )),
                Tab(
                    child: Text(
                  LocalizationsUtil.of(context).translate("regulations"),
                )),
              ],
              indicatorColor: AppColor.black,
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
            )),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            TabIntroduction(
              content: _model.description!,
              images: _model.images!,
            ),
            TabTerms(
              regulation: _model.regulation!,
            ),
          ],
          controller: _tabController,
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
