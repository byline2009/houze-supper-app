// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/indicators/apple_refresh_indicator.dart';
// import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/definitions.dart';
// import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/widget.dart';
// import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
// import 'package:houze_super/presentation/index.dart';
// import 'package:houze_super/presentation/screen/base/base_widget.dart';
// import 'package:houze_super/presentation/screen/payment/blocs/order/fee_v1_bloc.dart';
// import 'package:houze_super/presentation/screen/payment/blocs/order/fee_v1_event.dart';
// import 'package:houze_super/presentation/screen/payment/blocs/order/fee_v1_state.dart';
// import 'package:houze_super/presentation/screen/payment/blocs/payment/index.dart';
// import 'package:houze_super/presentation/screen/payment/order/widget_latest_order.dart';
// import 'package:houze_super/presentation/screen/payment/order/widget_properties.dart';

// typedef void CallBackHandler(dynamic value);

// //---TAB: Hóa đơn---//
// class OrderPayment extends StatefulWidget {
//   final TabController tabController;
//   final CallBackHandler? callback;
//   const OrderPayment({
//     this.callback,
//     required this.tabController,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _OrderPaymentState();
// }

// class _OrderPaymentState extends State<OrderPayment>
//     with AutomaticKeepAliveClientMixin<OrderPayment>, TickerProviderStateMixin {
//   late final StreamSubscription? subscriptionUpdateOrderPayment;

//   @override
//   void initState() {
//     super.initState();

//     subscriptionUpdateOrderPayment =
//         AppController().eventBus.on<EventPaymentPay>().listen(
//       (event) {
//         if (mounted) refreshData();
//       },
//     );
//   }

//   @override
//   void dispose() {
//     subscriptionUpdateOrderPayment?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);

//     return CustomRefreshIndicator(
//       leadingGlowVisible: false,
//       trailingGlowVisible: false,
//       indicatorBuilder: (BuildContext context, CustomRefreshIndicatorData d) {
//         if (d.isDraging) {
//           return Positioned(
//             top: 20,
//             right: 0,
//             left: 0,
//             child: Center(
//               child: DraggingActivityIndicator(
//                 percentageComplete: d.value,
//                 radius: 12,
//               ),
//             ),
//           );
//         }

//         if (d.isArmed) {
//           return Positioned(
//               top: 20,
//               right: 0,
//               left: 0,
//               child: CupertinoActivityIndicator(radius: 12));
//         }

//         return const SizedBox.shrink();
//       },
//       onRefresh: () async {
//         refreshData();
//       },
//       child: CustomScrollView(
//         key: PageStorageKey<String>('OrderPayment'),
//         physics: const BouncingScrollPhysics(),
//         slivers: <Widget>[
//           SliverToBoxAdapter(
//             child: BaseWidget.boderBottom(
//               WidgetLatestOrder(
//                 orderTabController: widget.tabController,
//                 // callback: () {
//                 //   refreshData();
//                 // },
//                 callBackHandler: (value) {
//                   if (value != null) {
//                     //get transaction with pending status
//                     widget.callback!(value);
//                   }
//                 },
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: BlocBuilder<FeeGroupApartmentBloc, FeeV1State>(
//                 buildWhen: (previous, current) =>
//                     previous.feeGroupByApartments !=
//                     current.feeGroupByApartments,
//                 builder: (BuildContext context, FeeV1State feeState) {
//                   if (feeState.status.isError) {
//                     return SomethingWentWrong(true);
//                   }
//                   if (feeState.status.isSuccess) {
//                     return WidgetProperties(
//                       callback: () {
//                         refreshData();
//                       },
//                       feeGroupByApartments: feeState.feeGroupByApartments,
//                     );
//                   }
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10, bottom: 20),
//                           child: ParkingCardSkeleton(width: 120, height: 20),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 20),
//                           child: Row(
//                             children: <Widget>[
//                               ClipRRect(
//                                 borderRadius: const BorderRadius.all(
//                                   Radius.circular(12.0),
//                                 ),
//                                 child: Stack(
//                                   clipBehavior: Clip.hardEdge,
//                                   children: <Widget>[
//                                     ParkingCardSkeleton(
//                                       width: 60,
//                                       height: 60,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(width: 15),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: <Widget>[
//                                     ParkingCardSkeleton(width: 120, height: 12),
//                                     const SizedBox(height: 8),
//                                     ParkingCardSkeleton(width: 120, height: 10),
//                                     const SizedBox(height: 8),
//                                     ParkingCardSkeleton(width: 120, height: 10),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => false;

//   void refreshData() async {
//     await Future.delayed(Duration.zero, () {
//       context.read<PaymentBloc>().add(PaymentLoadHistory(
//             limit: 5,
//             status: 0,
//           ));
//     });
//     await Future.delayed(Duration.zero, () {
//       context.read<FeeGroupApartmentBloc>().add(GetFeeGroupApartment());
//     });
//   }
// }
