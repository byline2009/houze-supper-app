import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/index.dart';
import 'package:houze_super/presentation/common_widgets/empty_page.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/widget_something_went_wrong.dart';
import 'package:houze_super/presentation/screen/payment/history/bloc/filter_bloc.dart';
import 'package:houze_super/presentation/screen/payment/order/bloc/order_bloc.dart';
import 'package:houze_super/utils/constant/app_constant.dart';
import 'package:houze_super/utils/controller/app_controller.dart';
import 'package:houze_super/utils/controller/app_event_bus.dart';

import '../widget_latest_order.dart';
import '../widget_properties.dart';

class TabOrder extends StatefulWidget {
  const TabOrder({
    Key? key,
    required this.tabController,
  }) : super(key: key);
  final TabController tabController;

  @override
  State<TabOrder> createState() => _TabOrderState();
}

class _TabOrderState extends State<TabOrder> {
  late final StreamSubscription? subscriptionUpdateOrderPayment;

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(OrderFetched());
    subscriptionUpdateOrderPayment =
        AppController().eventBus.on<EventPaymentPay>().listen(
      (event) {
        if (mounted) {
          context.read<OrderBloc>().add(OrderFetched());
          context.read<FilterBloc>().add(FilterLoadAllStatus());
        }
      },
    );
  }

  @override
  void dispose() {
    subscriptionUpdateOrderPayment?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              ),
            ),
          );
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
        context.read<OrderBloc>().add(OrderFetched());
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status.isError) {
            return SomethingWentWrong();
          }

          if (state.status.isSuccess &&
              state.paymentHistories.length == 0 &&
              state.feeGroupByApartments.length == 0) {
            return EmptyPage(
              content: 'Chưa có hoá đơn nào',
              svgPath: AppVectors.ic_404_invoice,
            );
          }

          return CustomScrollView(
            key: PageStorageKey<String>('OrderPayment'),
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: WidgetLatestOrder(
                  orderTabController: widget.tabController,
                ),
              ),
              SliverToBoxAdapter(
                child: BlocBuilder<OrderBloc, OrderState>(
                  buildWhen: (previous, current) =>
                      previous.feeGroupByApartments !=
                          current.feeGroupByApartments ||
                      previous.status != current.status,
                  builder: (BuildContext context, OrderState feeState) {
                    if (feeState.status.isSuccess) {
                      return WidgetProperties(
                        callback: () {},
                        feeGroupByApartments: feeState.feeGroupByApartments,
                      );
                    }
                    if (feeState.status.isLoading) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child:
                                  ParkingCardSkeleton(width: 120, height: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: <Widget>[
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                    child: Stack(
                                      clipBehavior: Clip.hardEdge,
                                      children: <Widget>[
                                        ParkingCardSkeleton(
                                          width: 60,
                                          height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        ParkingCardSkeleton(
                                            width: 120, height: 12),
                                        const SizedBox(height: 8),
                                        ParkingCardSkeleton(
                                            width: 120, height: 10),
                                        const SizedBox(height: 8),
                                        ParkingCardSkeleton(
                                            width: 120, height: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
