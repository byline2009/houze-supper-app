// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:houze_super/middle/local/storage.dart';
// import 'package:houze_super/middle/repo/payme_repo.dart';
// import 'package:houze_super/presentation/index.dart';
// import 'package:houze_super/presentation/screen/payment/bloc/payme/index.dart';
// import 'package:houze_super/utils/constants/share_keys.dart';
// import 'package:houze_super/utils/index.dart';

// import 'bloc/payme/wallet/payme_wallet_bloc.dart';
// import 'widgets/payme_kyc_approved_header.dart';
// import 'widgets/payme_not_activated.dart';
// import 'widgets/payme_not_login_header.dart';

// class PayMEInitializer extends StatefulWidget {
//   final String token;
//   final Widget loading;
//   final ProgressHUD progressToolkit;
//   const PayMEInitializer({
//     @required this.token,
//     @required this.loading,
//     @required this.progressToolkit,
//     Key key,
//   }) : super(key: key);

//   @override
//   _PayMEState createState() => _PayMEState();
// }

// class _PayMEState extends State<PayMEInitializer> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//       future: PayMERepository().init(
//         token: widget.token,
//       ),
//       initialData: Storage.getStatePayME(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               LocalizationsUtil.of(context)
//                   .translate("there_is_an_issue_please_try_again_later_0"),
//               style: AppFonts.medium12.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//           );
//         }

//         if (snapshot.connectionState == ConnectionState.done &&
//             snapshot.hasData) {
//           print('PayMEInitializer: state ${snapshot.data}');
//           return buildBody(snapshot.data);
//         }
//         return widget.loading;
//       },
//     );
//   }

//   Widget buildBody(String state) {
//     switch (state) {
//       case ShareKeys.kExpired:
//       case ShareKeys.kAccountNotLogin:
//       case ShareKeys.kNotLogin:
//         return HeaderPayMENotLogin(
//           progressToolkit: widget.progressToolkit,
//         );
//         break;

//       case ShareKeys.kKycApproved:
//       case 'OPENED':
//         return buildPayMEKYCHeader();
//         break;

//       case ShareKeys.kUnkownError:
//         return HeaderPayMEUnkownError(
//           message: 'Dịch vụ đang gặp gián đoạn. Vui lòng quay lại sau',
//         );
//       default:
//         return HouzePayment();
//         break;
//     }
//   }

//   Widget buildPayMEKYCHeader() {
//     return BlocProvider<GetAccountInfoBloc>(
//       create: (BuildContext context) => GetAccountInfoBloc(
//         repo: PayMERepository(),
//       ),
//       child: BlocBuilder<GetAccountInfoBloc, GetAccountInfoState>(
//         builder: (context, GetAccountInfoState statePayme) {
//           if (statePayme.isInitial) {
//             context.read<GetAccountInfoBloc>().add(
//                   GetAccountInfoEvent(),
//                 );
//           }
//           if (statePayme.hasData && statePayme.state != null) {
//             return Builder(
//               builder: (
//                 context,
//               ) {
//                 return BlocProvider(
//                   create: (context) => PayMEGetWalletBloc(
//                     repo: PayMERepository(),
//                   ),
//                   child: HeaderPayMEKYCApproved(),
//                 );
//               },
//             );
//           }
//           if (statePayme.hasError) {
//             return Center(
//               child: Text(
//                 statePayme.error.message,
//                 style: AppFonts.semibold13.copyWith(
//                   color: Colors.white,
//                 ),
//               ),
//             );
//           }
//           if (statePayme.hasLoading) {
//             return const Center(
//               child: CupertinoActivityIndicator(),
//             );
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

// class HeaderPayMEUnkownError extends StatelessWidget {
//   const HeaderPayMEUnkownError({
//     Key key,
//     @required this.message,
//   }) : super(key: key);

//   final String message;
//   @override
//   Widget build(BuildContext context) {
//     return DecoratedBox(
//       decoration: BoxDecoration(
//         color: Color(0xff4500ae),
//         borderRadius: BorderRadius.circular(
//           12,
//         ),
//       ),
//       child: SizedBox(
//         height: 56,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 width: 40,
//                 height: 40,
//                 child: Center(
//                   child: Image(
//                     image: AssetImage(
//                       AppImages.icPayME,
//                     ),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 8,
//               ),
//               Expanded(
//                 child: SizedBox(
//                     child: Text(
//                   message,
//                   style: AppFonts.semibold13.copyWith(
//                     color: Colors.white,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 )),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
