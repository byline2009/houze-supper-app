import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {
  LoginState([List props = const []]) : super();
}

class LoginInitial extends LoginState {
  @override
  String toString() => 'LoginInitial';

  @override
  List<Object> get props => [];
}

class LoginSuccessful extends LoginState {
  @override
  String toString() => 'LoginSuccessful';
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  String toString() => 'LoginLoading';
  @override
  List<Object> get props => [];
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({
    @required this.error,
  });

  @override
  String toString() => 'LoginFailure { error: $error }';
  @override
  List<Object> get props => [error];
}
