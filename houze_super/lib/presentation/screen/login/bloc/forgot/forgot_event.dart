import 'package:equatable/equatable.dart';

abstract class ForgotEvent extends Equatable {
  ForgotEvent([List props = const []]) : super();
}

class ForgotCheckVerify extends ForgotEvent {
  final String token;

  ForgotCheckVerify({this.token});

  @override
  String toString() => 'ForgotCheckVerify  { token: $token }';

  @override
  List<Object> get props => [token];
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
