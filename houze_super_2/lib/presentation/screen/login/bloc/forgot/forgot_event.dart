import 'package:equatable/equatable.dart';

abstract class ForgotEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotReCheckVerify extends ForgotEvent {
  ForgotReCheckVerify();

  @override
  String toString() => 'ForgotReCheckVerify';
  @override
  List<Object> get props => [];
}

class ResendOTP extends ForgotEvent {
  ResendOTP();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'ResendOTP';
}
