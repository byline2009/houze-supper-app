import 'package:flutter/material.dart';
import 'package:houze_super/presentation/custom_ui/appbar/widget_appbar_gradient.dart';
import 'package:houze_super/presentation/screen/payment/order/order_payment.dart';
import 'package:houze_super/presentation/screen/payment/sc_payment_history.dart';
import 'package:houze_super/utils/localizations_util.dart';

import '../../index.dart';
import 'enum_payment.dart';
import 'widgets/payme_not_activated.dart';

class NavigationTab {
  final String title;
  final Widget screen;
  const NavigationTab({this.title, this.screen});
}

class PaymentScreen extends StatefulWidget {
  PaymentScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with
        AutomaticKeepAliveClientMixin<PaymentScreen>,
        TickerProviderStateMixin {
  TabController _tabController;
  List<NavigationTab> tabs;
  final ProgressHUD progressToolkit = Progress.instanceCreate();
  @override
  void initState() {
    super.initState();

    _tabController = getTabController();
    tabs = [
      NavigationTab(
        title: "invoice",
        screen: OrderPayment(
          tabController: _tabController,
        ),
      ),
      NavigationTab(
        title: "history_transactions",
        screen: PaymentHistoryScreen(),
      ),
    ];
  }

  TabController getTabController() {
    return TabController(length: EnumPaymentScreen.values.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        BaseScaffoldGradient(
          centerTitle: true,
          isScrollableTab: true,
          title: Container(
            alignment: Alignment.center,
            width: double.infinity,
            margin: EdgeInsets.all(
              20,
            ),
            child: HouzePay(),
          ),
          child: _buildBodyTabbar(),
          controller: _tabController,
          tabs: tabs
              .map((f) => LocalizationsUtil.of(context).translate(f.title))
              .toList(),
        ),
        progressToolkit,
      ],
    );
  }

  _buildBodyTabbar() {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: tabs
          .map(
            (f) => SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) => f.screen,
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
