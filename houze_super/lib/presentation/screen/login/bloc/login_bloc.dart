import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:houze_super/app/bloc/authentication/authentication_bloc.dart';
import 'package:houze_super/app/bloc/authentication/authentication_event.dart';
import 'package:houze_super/middle/model/token_model.dart';
import 'package:houze_super/presentation/screen/login/bloc/index.dart';
import 'package:meta/meta.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.authenticationBloc,
  }) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginSubmitPhonePasswordEvent) {
      yield LoginLoading();

      try {
        final TokenModel rs = await authenticationBloc.userRepo.authenticate(
          phoneDial: event.dial,
          phone: event.phone,
          password: event.password,
        );
        authenticationBloc.add(LoggedIn(token: rs.access));

        yield LoginSuccessful();
      } on NoSuchMethodError catch (error) {
        print(error.toString());
        yield LoginFailure(error: 'there_is_an_issue_please_try_again_later_1');
      } catch (error) {
        yield LoginFailure(
            error: error == 'Sai tài khoản hoặc mật khẩu'
                ? 'wrong_account_or_password'
                : error.toString());
      }
    }
  }
}
