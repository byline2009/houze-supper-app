import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  String toString() => 'AuthenticationInitial';
}

class AuthenticationAuthenticated extends AuthenticationState {
  final bool isLoginEvent;

  AuthenticationAuthenticated({this.isLoginEvent = false});

  @override
  String toString() =>
      'AuthenticationAuthenticated { isLoginEvent: $isLoginEvent }';

  @override
  List<Object> get props => [
        isLoginEvent,
      ];
}

class AuthenticationUnauthenticated extends AuthenticationState {
  @override
  String toString() => 'AuthenticationUnauthenticated';
}

class AuthenticationLoading extends AuthenticationState {
  @override
  String toString() => 'AuthenticationLoading';
}

class LogOutButtonTapLoading extends AuthenticationState {
  @override
  String toString() => 'LogOutButtonTapLoading';
}
