// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:houze_super/middle/model/payment_gateway_model.dart';
// import 'package:houze_super/utils/constants/app_fonts.dart';
// import 'package:houze_super/utils/index.dart';
// import 'package:houze_super/utils/localizations_util.dart';

// class GatewayPayMeKYC extends StatelessWidget {
//   const GatewayPayMeKYC({
//     Key key,
//     @required this.model,
//   }) : super(key: key);

//   final PaymentGatewayModel model;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<PayMEGetWalletBloc, PayMEGetWalletState>(
//       builder: (context, PayMEGetWalletState state) {
//         if (state.isInitial) {
//           context.read<PayMEGetWalletBloc>().add(PayMEGetWalletEvent());
//         }
//         if (state.hasError) {
//           return Center(
//             child: Text(
//               state.error,
//               style: AppFonts.regular13.copyWith(
//                 color: Color(0xff838383),
//               ),
//             ),
//           );
//         }

//         Widget result = const CupertinoActivityIndicator();
//         if (state.hasData) {
//           result = RichText(
//             maxLines: 1,
//             text: TextSpan(
//               children: <TextSpan>[
//                 TextSpan(
//                   text: LocalizationsUtil.of(context)
//                           .translate(model.gatewayDesc) +
//                       ' ',
//                   style: AppFonts.regular13.copyWith(
//                     color: Color(0xff838383),
//                   ),
//                 ),
//                 TextSpan(
//                   text: StringUtil.numberFormat(
//                         double.parse(
//                           state.balance.toString(),
//                         ),
//                       ) +
//                       ' đ',
//                   style: AppFonts.semibold.copyWith(
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         return Expanded(
//           child: Row(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                       LocalizationsUtil.of(context)
//                           .translate(model.gatewayTitle),
//                       style: AppFonts.medium14.copyWith(color: Colors.black)),
//                   const SizedBox(height: 4),
//                   result,
//                 ],
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
