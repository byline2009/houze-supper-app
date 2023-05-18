import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';

import 'widget_total_point.dart';

class HouzePointSummary extends StatefulWidget {
  @override
  _HouzePointSummaryState createState() => _HouzePointSummaryState();
}

class _HouzePointSummaryState extends State<HouzePointSummary>
    with TickerProviderStateMixin {
  late TabController _nestedTabController;

  final _tabNameList = <String>['Tuần này', 'Tháng này', 'Năm nay'];
  var tabWidgets = <Widget>[];
  int totalPoint = 15000;
  @override
  void initState() {
    super.initState();

    _nestedTabController = TabController(
      length: _tabNameList.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _nestedTabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          SizedBox(height: 50),
          Text('Tổng Houze Xu đã tích luỹ được nhờ Đi bộ',
              style: AppFonts.semibold13.copyWith(
                color: Color(
                  0xff838383,
                ),
              )),

          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          //   decoration: MailboxStyle.issueTabbarDecor,
          //   padding: const EdgeInsets.all(5),
          //   child: TabBar(
          //       controller: _nestedTabController,
          //       labelPadding: const EdgeInsets.all(0),
          //       indicatorPadding: const EdgeInsets.all(0),
          //       indicatorColor: Colors.transparent,
          //       labelStyle: AppFont.SEMIBOLD_BLACK_13,
          //       indicator: MailboxStyle.indicatorDecor,
          //       labelColor: Colors.black,
          //       unselectedLabelStyle: AppFont.SEMIBOLD_GRAY_9c9c9c_13,
          //       unselectedLabelColor: AppColor.gray_9c9c9c,
          //       isScrollable: false,
          //       onTap: (index) {
          //         if (index == 0) totalPoint = 15000;
          //         if (index == 1) totalPoint = 87907;
          //         if (index == 2) totalPoint = 5900000;

          //         setState(() {
          //           totalPoint = totalPoint;
          //         });
          //       },
          //       tabs: _tabNameList.map((e) => _buildTabItem(title: e)).toList()),
          // ),
          SizedBox(height: 10),
          HouzePoint(point: 5204800),
          SizedBox(height: 27),
          WidgetButton.roundedRect(
              child: Center(
                  child: Text('Xem ưu đãi Houze Xu',
                      style: AppFont.BOLD_d68100.copyWith(fontSize: 16))),
              backgroundColor: Color(0xffffefc6),
              radius: 100,
              callback: () {
                print('Xem ưu đãi Houze Xu');
              }),
        ],
      ),
    );
  }

  // Widget _buildTabItem({String title}) {
  //   return Container(
  //     height: 34,
  //     decoration: BoxDecoration(
  //         color: Colors.transparent,
  //         border:
  //             Border.all(color: Colors.transparent, style: BorderStyle.solid),
  //         borderRadius: BorderRadius.all(Radius.circular(4.0))),
  //     child: Tab(iconMargin: EdgeInsets.zero, text: title),
  //   );
  // }
}
