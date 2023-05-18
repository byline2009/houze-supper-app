// import 'package:equatable/equatable.dart';
// import 'package:flutter/foundation.dart';
// import 'package:houze_super/middle/model/ekyc_model.dart';

// @immutable
// abstract class EKYCState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class EKYCInitial extends EKYCState {
//   @override
//   String toString() => 'EKYCInitial';

//   @override
//   List<Object> get props => [];
// }

// class EKYCGetting extends EKYCState {
//   @override
//   String toString() => 'EKYCGetting';
//   @override
//   List<Object> get props => [];
// }

// class EKYCGetSuccessful extends EKYCState {
//   final EKYCModel eKYC;

//   EKYCGetSuccessful({required this.eKYC});
//   @override
//   List<Object> get props => [eKYC];

//   @override
//   String toString() => 'EKYCGetSuccessful { eKYC: $eKYC }';
// }

// class EKYCGetFailure extends EKYCState {
//   final String error;

//   EKYCGetFailure({required this.error}) : super();
//   @override
//   List<Object> get props => [error];

//   @override
//   String toString() => 'EKYCGetFailure { error: $error }';
// }
