import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ForgotState extends Equatable {
  ForgotState([List props = const []]) : super();
}

class ForgotInitial extends ForgotState {
  @override
  String toString() => 'ForgotInitial';

  @override
  List<Object> get props => [];
}

class ForgotCheckedVerify extends ForgotState {
  final String token;

  ForgotCheckedVerify({this.token});
  @override
  List<Object> get props => [token];
  @override
  String toString() => 'ForgotCheckedVerify { token: $token }';
}

class ForgotReCheckedVerify extends ForgotState {
  @override
  String toString() => 'ForgotReCheckedVerify';
  @override
  List<Object> get props => [];
}

class ForgotSuccessful extends ForgotState {
  @override
  String toString() => 'ForgotSuccessful';
  @override
  List<Object> get props => [];
}

class ForgotLoading extends ForgotState {
  @override
  String toString() => 'ForgotLoading';
  @override
  List<Object> get props => [];
}

class ForgotFailure extends ForgotState {
  final String error;

  ForgotFailure({@required this.error}) : super([error]);
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ForgotFailure { error: $error }';
}
