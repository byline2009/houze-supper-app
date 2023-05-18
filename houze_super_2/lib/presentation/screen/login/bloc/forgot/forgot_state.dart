import 'package:equatable/equatable.dart';

abstract class ForgotState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotInitial extends ForgotState {
  @override
  String toString() => 'ForgotInitial';

}

class ForgotCheckedVerify extends ForgotState {
  final String? token;

  ForgotCheckedVerify({this.token});
  @override
  List<Object> get props => [token ?? ''];
  @override
  String toString() => 'ForgotCheckedVerify { token: $token }';
}

class ForgotReCheckedVerify extends ForgotState {
  @override
  String toString() => 'ForgotReCheckedVerify';
}

class ForgotSuccessful extends ForgotState {
  @override
  String toString() => 'ForgotSuccessful';
}

class ForgotLoading extends ForgotState {
  @override
  String toString() => 'ForgotLoading';
}

class ForgotFailure extends ForgotState {
  final String error;

  ForgotFailure({required this.error});
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ForgotFailure { error: $error }';
}
