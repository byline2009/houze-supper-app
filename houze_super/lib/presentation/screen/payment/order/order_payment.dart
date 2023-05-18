import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/indicators/apple_refresh_indicator.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/definitions.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/widget.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/payment/bloc/order/fee_v1_bloc.dart';
import 'package:houze_super/presentation/screen/payment/bloc/order/fee_v1_event.dart';
import 'package:houze_super/presentation/screen/payment/bloc/payment/index.dart';
import 'package:houze_super/presentation/screen/payment/order/widget_latest_order.dart';
import 'package:houze_super/presentation/screen/payment/order/widget_properties.dart';

//---TAB: Hóa đơn---//
class OrderPayment extends StatefulWidget {
  final TabController tabController;

  const OrderPayment({@required this.tabController, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderPaymentState();
}

class _OrderPaymentState extends State<OrderPayment>
    with AutomaticKeepAliveClientMixin<OrderPayment>, TickerProviderStateMixin {
  final _feeGroupApartmentBloc = FeeGroupApartmentBloc();
  final _paymentBloc = PaymentBloc();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CustomRefreshIndicator(
      leadingGlowVisible: false,
      trailingGlowVisible: false,
      indicatorBuilder: (BuildContext context, CustomRefreshIndicatorData d) {
        if (d.isDraging) {
          return Positioned(
              top: 20,
              right: 0,
              left: 0,
              child: Center(
                  child: DraggingActivityIndicator(
                percentageComplete: d.value,
                radius: 12,
              )));
        }

        if (d.isArmed) {
          return Positioned(
              top: 20,
              right: 0,
              left: 0,
              child: CupertinoActivityIndicator(radius: 12));
        }

        return const SizedBox.shrink();
      },
      onRefresh: () async {
        _paymentBloc.add(PaymentLoadHistory(limit: 5, status: 0));
        _feeGroupApartmentBloc.add(GetFeeGroupApartment());
      },
      child: CustomScrollView(
        key: PageStorageKey<String>('OrderPayment'),
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: BaseWidget.boderBottom(
              WidgetLatestOrder(
                  paymentBloc: _paymentBloc,
                  orderTabController: widget.tabController,
                  callback: () {
                    refreshData();
                  }),
            ),
          ),
          SliverToBoxAdapter(
            child: WidgetProperties(
              feeGroupApartmentBloc: _feeGroupApartmentBloc,
              callback: () {
                refreshData();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;

  void refreshData() {
    _paymentBloc.add(PaymentLoadHistory(limit: 5, status: 0));
    _feeGroupApartmentBloc.add(GetFeeGroupApartment());
  }
}
