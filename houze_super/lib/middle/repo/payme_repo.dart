// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:houze_payme_sdk/houze_payme_sdk.dart';
// import 'package:houze_super/common/blocs/app_event_bloc.dart';
// import 'package:houze_super/middle/local/storage.dart';
// import 'package:houze_super/middle/model/language_model.dart';
// import 'package:houze_super/utils/constants/share_keys.dart';
// import 'package:houze_super/utils/index.dart';

// class PayMERepository {
//   PayMERepository();

//   Future<String> init({
//     @required String token,
//   }) async {
//     if (!StringUtil.isEmpty(token)) {
//       try {
//         final LanguageModel _lang = Storage.getLanguage();
//         final HPayMEEnv env = !StringUtil.isEmpty(APIConstant.isProduction) &&
//                 APIConstant.isProduction == 'true'
//             ? HPayMEEnv.PRODUCTION
//             : HPayMEEnv.SANDBOX;

//         String state = await HouzePaymeSdk.initPayME(
//           connectToken: token,
//           config: HPayMEConfig(
//             env: env,
//             language: _lang.locale == AppConstant.locateVI
//                 ? HPayMELanguage.VN
//                 : HPayMELanguage.EN,
//           ),
//         );
//         await Storage.saveStatePayME(state);
//         return state;
//       } on PlatformException catch (e) {
//         handleErrorCode(e);
//         print("[PayME][init][Error] code:${e.code} message:${e.message}");
//         return e.code;
//       }
//     }
//     return ShareKeys.kUnkownError;
//   }

//   Future<String> getAccountInfo() async {
//     try {
//       final info = await HouzePaymeSdk.getAccountInfo();
//       return info['Account']['state'] ?? '';
//     } on PlatformException catch (e) {
//       handleErrorCode(e);
//       return null;
//     }
//   }

//   Future<void> logout() async {
//     print("[PayME][Logout] function is running now");
//     Future.delayed(Duration.zero).whenComplete(() async {
//       try {
//         await Future.wait([
//           Storage.removeStatePayME(),
//           HouzePaymeSdk.logout(),
//         ]);
//       } catch (e) {
//         print("[PayME][Logout][Error] Code: ${e.code}");
//       } finally {
//         AppEventBloc().emitEvent(
//           BlocEvent(
//             EventName.payMEChangeState,
//             ShareKeys.kExpired,
//           ),
//         );
//         print("[PayME][Logout] finished");
//       }
//     });
//   }

//   Future<String> login() async {
//     try {
//       final rs = await HouzePaymeSdk.login();
//       await Storage.saveStatePayME(rs);

//       print("[PayME][Login][Succesful] state: $rs");
//       return rs;
//     } on PlatformException catch (e) {
//       print("[PayME][Login][Error]: ${e.code}");
//       handleErrorCode(e);

//       return e.code;
//     }
//   }

//   Future<int> getWalletInfo() async {
//     try {
//       final rs = await HouzePaymeSdk.getWalletInfo();
//       if (rs != null) {
//         print(
//             "[PayME][getWalletInfo][Result] balance: ${rs['Wallet']['balance']}");
//         return rs['Wallet']['balance'];
//       }
//     } on PlatformException catch (e) {
//       handleErrorCode(e);
//       print("[PayME][getWalletInfo][Error] Code: ${e.code}");
//     }
//     return 0;
//   }

//   Future<void> openWallet() async {
//     try {
//       final rs = await HouzePaymeSdk.openWallet();
//       print("[PayME][openWallet][Error] Code: $rs");
//     } on PlatformException catch (e) {
//       print("[PayME][openWallet][Error] Code: ${e.code}");
//       handleErrorCode(e);
//     }
//   }

//   Future<void> handleErrorCode(PlatformException e) async {
//     await Storage.saveStatePayME(e.code);
//     AppEventBloc().emitEvent(
//       BlocEvent(
//         EventName.payMEChangeState,
//         e,
//       ),
//     );
//   }
// }
