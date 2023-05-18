import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginIitital extends LoginEvent {}

class LoginPhoneChanged extends LoginEvent {
  final String phone;

  LoginPhoneChanged({required this.phone});

  @override
  List<Object> get props => [phone];

  @override
  String toString() {
    return 'LoginPhoneChanged{phone: $phone}';
  }
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() {
    return 'LoginPasswordChanged{password: $password}';
  }
}

class LoginSubmitPhonePasswordEvent extends LoginEvent {
  final String dial;
  final String phone;
  final String password;

  LoginSubmitPhonePasswordEvent(
      {required this.dial, required this.phone, required this.password});

  @override
  List<Object> get props => [dial, phone, password];
}
