// import 'package:equatable/equatable.dart';

// class PayMEGetWalletState extends Equatable {
//   final bool isLoading;
//   final int balance;
//   final String error;

//   const PayMEGetWalletState({
//     this.isLoading,
//     this.balance,
//     this.error,
//   });
//   @override
//   List<Object> get props => [
//         isLoading,
//         balance,
//         error,
//       ];

//   factory PayMEGetWalletState.initial() {
//     return PayMEGetWalletState(
//       balance: null,
//       isLoading: false,
//       error: null,
//     );
//   }

//   factory PayMEGetWalletState.loading() {
//     return PayMEGetWalletState(
//       balance: null,
//       isLoading: true,
//       error: null,
//     );
//   }

//   factory PayMEGetWalletState.success(int balance) {
//     return PayMEGetWalletState(
//       balance: balance,
//       isLoading: false,
//       error: null,
//     );
//   }

//   factory PayMEGetWalletState.error(String code) {
//     return PayMEGetWalletState(
//       balance: null,
//       isLoading: false,
//       error: code,
//     );
//   }

//   bool get hasLoading => isLoading && error == null && balance == null;
//   bool get hasData => !isLoading && error == null && balance != null;
//   bool get isInitial => !isLoading && error == null && balance == null;
//   bool get hasError => !isLoading && error != null;
//   @override
//   String toString() {
//     if (isInitial) {
//       return 'PayMEGetWalletState initial';
//     }
//     if (hasData) {
//       return 'PayMEGetWalletState {balance: ${balance.toString()}}';
//     }
//     if (hasLoading) {
//       return 'PayMEGetWalletState is loading';
//     }

//     if (hasError) {
//       return 'PayMEGetWalletState has error $error';
//     }

//     return '';
//   }
// }
