// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:houze_super/utils/constants/app_constants.dart';
// import 'package:houze_super/utils/constants/app_fonts.dart';
// import 'package:houze_super/utils/localizations_util.dart';
// import 'package:houze_super/utils/progresshub.dart';

// class HeaderPayMENotLogin extends StatelessWidget {
//   const HeaderPayMENotLogin({
//     Key key,
//     @required this.progressToolkit,
//   }) : super(key: key);

//   final ProgressHUD progressToolkit;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         // progressToolkit.state.show();
//         // try {
//         //   await PayMERepository().login();
//         // } finally {
//         //   progressToolkit.state.dismiss();
//         // }
//       },
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           color: Color(0xff4500ae),
//           borderRadius: BorderRadius.circular(
//             12,
//           ),
//         ),
//         child: SizedBox(
//           height: 56,
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
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
//                   child: SizedBox(
//                     child: buildAccountNotLogin(
//                       context,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildAccountNotLogin(
//     BuildContext ctx,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 LocalizationsUtil.of(ctx).translate('k_service_wallet_balance'),
//                 style: AppFonts.semibold13.copyWith(color: Color(0xff808080)),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             Text('Chưa đăng nhập',
//                 style: AppFonts.semibold13.copyWith(color: Colors.white)),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Bấm vào đây để đăng nhập ví PayME',
//               style: AppFonts.semibold13.copyWith(color: Colors.white),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             SvgPicture.asset(
//               AppVectors.icOpenWalletPayme,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
