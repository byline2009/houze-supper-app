// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:houze_super/middle/repo/payme_repo.dart';
// import 'index.dart';

// class GetAccountInfoBloc
//     extends Bloc<GetAccountInfoEvent, GetAccountInfoState> {
//   final PayMERepository repo;
//   GetAccountInfoBloc({
//     @required this.repo,
//   }) : super(GetAccountInfoState.initial());

//   @override
//   Stream<GetAccountInfoState> mapEventToState(
//       GetAccountInfoEvent event) async* {
//     yield GetAccountInfoState.loading();

//     try {
//       final state = await repo.getAccountInfo();
//       yield GetAccountInfoState.success(state);
//     } on PlatformException catch (e) {
//       yield GetAccountInfoState.error(
//         e,
//       );
//     }
//   }
// }
