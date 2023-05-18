// import 'package:flutter/material.dart';
// import 'package:houze_super/middle/local/storage.dart';
// import 'package:houze_super/middle/repo/payme_repo.dart';
// import 'package:houze_super/utils/index.dart';
// import 'package:houze_super/utils/localizations_util.dart';

// import 'houze_payme_popup.dart';

// class GatewayHouzePayment extends StatelessWidget {
//   const GatewayHouzePayment({
//     Key key,
//     @required this.gatewayTitle,
//   }) : super(key: key);
//   final String gatewayTitle;
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 LocalizationsUtil.of(context).translate(gatewayTitle),
//                 style: AppFonts.medium14.copyWith(
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               Text(
//                 LocalizationsUtil.of(context).translate('k_not_activated'),
//                 style: AppFonts.semibold13.copyWith(
//                   color: Color(
//                     0xffe3a500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           GestureDetector(
//             onTap: () async {
//               print('Tạo ví');
//               //await showHouzexPayMEPopup();
//             },
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 15,
//                 vertical: 8,
//               ),
//               decoration: const BoxDecoration(
//                 gradient: AppColors.gradient,
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(
//                     100.0,
//                   ),
//                 ),
//               ),
//               child: Text(
//                 LocalizationsUtil.of(context).translate('k_create_a_wallet'),
//                 style: AppFonts.semibold13.copyWith(color: Colors.white),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Future<void> showHouzexPayMEPopup() async => showDialog(
//   //       context: Storage.scaffoldKey.currentContext, //context,
//   //       barrierDismissible: false,
//   //       builder: (_) {
//   //         return HouzexPayMEPopup(
//   //           callback: () async {
//   //             await PayMERepository().openWallet();
//   //           },
//   //         );
//   //       },
//   //     );
// }
