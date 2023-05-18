// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:houze_super/common/blocs/app_event_bloc.dart';
// import 'package:houze_super/middle/local/storage.dart';
// import 'package:houze_super/middle/repo/payme_repo.dart';
// import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
// import 'package:houze_super/presentation/index.dart';
// import 'package:houze_super/presentation/screen/payment/bloc/payme/wallet/index.dart';

// class HeaderPayMEKYCApproved extends StatefulWidget {
//   const HeaderPayMEKYCApproved({
//     Key key,
//   }) : super(key: key);
//   @override
//   _HeaderPayMEKYCApprovedState createState() => _HeaderPayMEKYCApprovedState();
// }

// class _HeaderPayMEKYCApprovedState extends State<HeaderPayMEKYCApproved> {
//   StreamSubscription<BlocEvent> _subPayMEUpdateBalance;

//   @override
//   void initState() {
//     super.initState();
//     _subPayMEUpdateBalance = AppEventBloc().listenEvent(
//       eventName: EventName.payMEUpdateBalance,
//       handler: _handlebalancePayME,
//     );
//   }

//   void _handlebalancePayME(BlocEvent evt) {
//     final value = evt.value;

//     if (mounted && value is bool) {
//       context.read<PayMEGetWalletBloc>().add(PayMEGetWalletEvent());
//     }
//   }

//   @override
//   void dispose() {
//     if (_subPayMEUpdateBalance != null) _subPayMEUpdateBalance.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PayMEGetWalletBloc, PayMEGetWalletState>(
//       builder: (context, state) {
//         if (state.isInitial) {
//           context.read<PayMEGetWalletBloc>().add(PayMEGetWalletEvent());
//         }
//         if (state.hasError) {
//           return Center(
//             child: Text(
//               state.error,
//               style: AppFonts.semibold13.copyWith(color: Colors.white),
//             ),
//           );
//         }
//         Widget result = SizedBox.shrink();
//         if (state.isLoading) {
//           result = SizedBox(
//             width: 100,
//             height: 10,
//             child: Opacity(
//               opacity: 0.7,
//               child: ParkingCardSkeleton(),
//             ),
//           );
//         }
//         if (state.hasData) {
//           result = Text(
//             StringUtil.numberFormat(double.parse(state.balance.toString())) +
//                 ' đ',
//             style: AppFonts.bold18.copyWith(color: Colors.white),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           );
//         }
//         return GestureDetector(
//           onTap: () async {
//             // await PayMERepository().openWallet();
//           },
//           child: Container(
//             height: 56,
//             padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
//             decoration: BoxDecoration(
//               color: Color(0xff4500ae),
//               borderRadius: BorderRadius.circular(
//                 12,
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: 40,
//                   height: 40,
//                   child: Center(
//                     child: Image(
//                       image: AssetImage(
//                         AppImages.icPayME,
//                       ),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               LocalizationsUtil.of(
//                                       Storage.scaffoldKey.currentContext)
//                                   .translate('k_service_wallet_balance'),
//                               style: AppFonts.semibold13.copyWith(
//                                 color: Color(0xffdcdcdc),
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           SvgPicture.asset(
//                             AppVectors.icOpenWalletPayme,
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           result,
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           Text(
//                             LocalizationsUtil.of(
//                                     Storage.scaffoldKey.currentContext)
//                                 .translate('k_manage_wallet'),
//                             style: AppFonts.semibold13.copyWith(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
