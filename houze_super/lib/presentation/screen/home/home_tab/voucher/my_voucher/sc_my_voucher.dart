import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/home/home_tab/voucher/my_voucher/page_my_voucher.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

class MyVoucherScreen extends StatefulWidget {
  MyVoucherScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyVoucherScreenState();
}

class _MyVoucherScreenState extends State<MyVoucherScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  Widget contentBody(Widget content) {
    return Container(
      color: Color(0xfff5f5f5),
      padding: const EdgeInsets.only(top: 5),
      child: Container(color: Colors.white, child: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            LocalizationsUtil.of(context).translate('my_voucher'),
            style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          bottom: TabBar(
            unselectedLabelColor: Color(0xff838383),
            unselectedLabelStyle: AppFonts.regular15.copyWith(
              color: Color(0xff838383),
            ),
            labelColor: Color(0xff6001d2),
            labelStyle: AppFonts.bold15.copyWith(color: Color(0xff6001d2)),
            tabs: [
              Tab(
                child: Text(
                  LocalizationsUtil.of(context)
                      .translate("voucher_is_available"),
                ),
              ),
              Tab(
                child: Text(
                  LocalizationsUtil.of(context).translate("voucher_is_expired"),
                ),
              )
            ],
            indicatorColor: Color(0xff6001d2),
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            this.contentBody(MyVoucherPage(status: 0)),
            this.contentBody(MyVoucherPage(status: 1))
          ],
          controller: _tabController,
        ));
  }
}
