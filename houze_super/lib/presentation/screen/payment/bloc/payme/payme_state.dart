// import 'package:equatable/equatable.dart';
// import 'package:flutter/services.dart';

// class GetAccountInfoState extends Equatable {
//   final bool isLoading;
//   final String state;
//   final PlatformException error;

//   const GetAccountInfoState({
//     this.isLoading,
//     this.state,
//     this.error,
//   });

//   factory GetAccountInfoState.initial() {
//     return GetAccountInfoState(
//       state: null,
//       isLoading: false,
//       error: null,
//     );
//   }

//   factory GetAccountInfoState.loading() {
//     return GetAccountInfoState(
//       state: null,
//       isLoading: true,
//       error: null,
//     );
//   }

//   factory GetAccountInfoState.success(
//     String newState,
//   ) {
//     return GetAccountInfoState(
//       state: newState,
//       isLoading: false,
//       error: null,
//     );
//   }

//   factory GetAccountInfoState.error(PlatformException error) {
//     return GetAccountInfoState(
//       state: null,
//       isLoading: false,
//       error: error,
//     );
//   }

//   @override
//   String toString() {
//     if (isInitial) {
//       return 'GetAccountInfoState isInitial';
//     }

//     if (hasData) {
//       return 'GetAccountInfoState hasData state: ${state.toString()}';
//     }

//     if (hasLoading) {
//       return 'GetAccountInfoState isLoading';
//     }

//     if (hasError) {
//       return 'GetAccountInfoState hasError: $error';
//     }
//     return 'GetAccountInfoState unknown';
//   }

//   bool get isInitial => state == null && !isLoading && error == null;
//   bool get hasData => !isLoading && error == null && state != null;
//   bool get hasLoading => isLoading && error == null && state == null;
//   bool get hasError => !isLoading && error != null && state == null;
//   @override
//   List<Object> get props => [
//         isLoading,
//         state,
//         error,
//       ];
// }
