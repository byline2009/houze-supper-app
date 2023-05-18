import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/payment/history/bloc/filter_bloc.dart';

import 'bloc/order_bloc.dart';
import 'draft_item.dart';
import 'widget_loading_skeleton.dart';

const int TRANSACTION_HISTORY_TAB = 1;
const int TRANSACTION_HISTORY_PENDING_STATUS = 0;
typedef void CallBackHandler(dynamic value);

class WidgetLatestOrder extends StatefulWidget {
  final TabController? orderTabController;

  WidgetLatestOrder({
    this.orderTabController,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WidgetLatestOrderState();
}

class _WidgetLatestOrderState extends State<WidgetLatestOrder> {
  late Size _screenSize;
  var padding;
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._screenSize = MediaQuery.of(context).size;
    this.padding = this._screenSize.width * 5 / 100;

    return BlocBuilder<OrderBloc, OrderState>(
      buildWhen: (previous, current) =>
          previous.paymentHistories != current.paymentHistories ||
          previous.status != current.status,
      builder: (context, state) {
        if (state.status.isSuccess) {
          if (state.paymentHistories.length == 0) return SizedBox();
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 0,
                  top: 30,
                ),
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset("assets/svg/feed/ic-0.svg"),
                    const SizedBox(width: 10),
                    Text(
                        LocalizationsUtil.of(context)
                            .translate('transaction_lasted')
                            .replaceAll(
                                "{0}", state.totalPaymentHistory.toString()),
                        style: AppFonts.regular14)
                  ],
                ),
              ),
              SizedBox(
                height: 330,
                child: state.paymentHistories.length == 1
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 20),
                        child: DraftItem(
                          order: state.paymentHistories[0],
                          size: EnumDraftItemSize.full,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 15, bottom: 20),
                        shrinkWrap: true,
                        controller: _controller,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.paymentHistories.length,
                        itemBuilder: (BuildContext context, int index) {
                          //Padding left
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: DraftItem(
                                order: state.paymentHistories[0],
                              ),
                            );
                          }
                          if (index == state.paymentHistories.length - 1) {
                            return _directToTransactionHistoryTab();
                          }
                          return DraftItem(
                            order: state.paymentHistories[index],
                          );
                        },
                      ),
              ),
              Divider(
                color: Color(0xfff5f5f5),
                thickness: 5,
              ),
            ],
          );
        }

        // Loading
        if (state.status.isLoading) {
          return PaymentLoadingSkeleton(
            parentContext: context,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _directToTransactionHistoryTab() {
    return GestureDetector(
      onTap: () {
        context.read<FilterBloc>().add(FilterStatusSelected(
              idSelected: 0,
              page: 0,
            ));
        widget.orderTabController!.animateTo(TRANSACTION_HISTORY_TAB);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Color(0xfff5f7f8),
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: Color(0xfff5f7f8),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward,
                size: 22,
                color: Color(0xff000000),
              ),
              const SizedBox(height: 5.0),
              Text(
                LocalizationsUtil.of(context).translate('history_transactions'),
                style: AppFonts.semibold16.copyWith(fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
