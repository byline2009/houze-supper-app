// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:houze_super/middle/repo/payme_repo.dart';
// import 'package:houze_super/presentation/screen/payment/bloc/payme/wallet/index.dart';

// class PayMEGetWalletBloc
//     extends Bloc<PayMEGetWalletEvent, PayMEGetWalletState> {
//   PayMEGetWalletBloc({
//     @required this.repo,
//   }) : super(PayMEGetWalletState.initial());
//   final PayMERepository repo;
//   @override
//   Stream<PayMEGetWalletState> mapEventToState(
//       PayMEGetWalletEvent event) async* {
//     yield PayMEGetWalletState.loading();

//     try {
//       final int result = await repo.getWalletInfo();
//       yield PayMEGetWalletState.success(result);
//     } on PlatformException catch (e) {
//       yield PayMEGetWalletState.error(e.code);
//     }
//   }
// }
