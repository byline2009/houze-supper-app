import 'package:flutter/material.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/screen/home/home_tab/voucher/my_voucher/page_my_voucher.dart';
import 'package:houze_super/utils/index.dart';

class MyVoucherScreen extends StatefulWidget {
  MyVoucherScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyVoucherScreenState();
}

class _MyVoucherScreenState extends RouteAwareState<MyVoucherScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  Widget contentBody(Widget content) {
    return Container(
      color: AppColor.gray_f5f5f5,
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
            style: AppFonts.medium16,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          bottom: TabBar(
            unselectedLabelColor: AppColor.gray_838383,
            unselectedLabelStyle: AppFonts.regular15.copyWith(
                      color: Color(
                        0xff838383
                      ),
                    ),
            labelColor: AppColor.purple_6001d2,
            labelStyle: AppFont.BOLD_PURPLE_6001d2_15,
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
            indicatorColor: AppColor.purple_6001d2,
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
