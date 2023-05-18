import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/api/payment_api.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';
import 'package:houze_super/presentation/custom_ui/appbar/widget_appbar_gradient.dart';
import 'package:houze_super/presentation/screen/payment/history/bloc/filter_bloc.dart';
import 'package:houze_super/presentation/screen/payment/history/view/tab_payment_histories.dart';
import 'package:houze_super/presentation/screen/payment/order/bloc/order_bloc.dart';
import 'package:houze_super/presentation/screen/payment/order/view/tab_order.dart';
import 'package:houze_super/utils/localizations_util.dart';

import 'enum_payment.dart';
import 'widgets/apartment_wallet_header.dart';

/* Payment page (Thanh toán)
- Tab: Invoice (Hoá đơn)
- Tab: Transaction history (Lịch sử giao dịch)
 */

class NavigationTab {
  final String title;
  final Widget screen;
  const NavigationTab({
    required this.title,
    required this.screen,
  });
}

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
        create: (context) => PaymentRepository(api: PaymentAPI()),
        child: MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => OrderBloc(
                paymentRepository: PaymentRepository(api: PaymentAPI())),
          ),
          BlocProvider(
              create: (context) => FilterBloc(
                  paymentRepository: context.read<PaymentRepository>())
              //  ),
              ),
        ], child: PaymentView()));
  }
}

class PaymentView extends StatefulWidget {
  PaymentView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView>
    with AutomaticKeepAliveClientMixin<PaymentView>, TickerProviderStateMixin {
  late TabController _tabController;
  late final List<NavigationTab> tabs;
  late ValueNotifier<dynamic> status;

  @override
  void initState() {
    super.initState();
    status = ValueNotifier<dynamic>(null);
    _tabController = TabController(length: EnumPaymentScreen.values.length, vsync: this);

    tabs = [
      // Tab: Invoice (Hoá đơn)
      NavigationTab(
        title: "invoice",
        screen: TabOrder(tabController: _tabController),
      ),
      // Tab: Transaction history (Lịch sử giao dịch)
      NavigationTab(
        title: "history_transactions",
        screen: TabPaymentHistories(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        this.status.value = null;
      }
    });

    return BaseScaffoldGradient(
      centerTitle: true,
      isScrollableTab: true,
      title: Center(
        child: ApartmentWallet(),
      ),
      child: _buildBodyTabbar(),
      controller: _tabController,
      tabs: tabs
          .map((f) => LocalizationsUtil.of(context).translate(f.title))
          .toList(),
    );
  }

  Widget _buildBodyTabbar() {
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
