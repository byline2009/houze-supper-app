import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:houze_super/app/bloc/authentication/authentication_event.dart';
import 'package:houze_super/app/bloc/authentication/authentication_state.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/repo/user_repository.dart';
import 'package:houze_super/middle/ws/index.dart';

import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/prefs.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepo;

  AuthenticationBloc({
    @required this.userRepo,
  }) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool hasToken = await userRepo.hasToken();
      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      yield AuthenticationAuthenticated(isLoginEvent: true);
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();

      FlutterAppBadger.removeBadge();
      OauthAPI.token = null;

      await Future.wait([
        Storage.removeStatePayME(),
        Storage.removePayMEToken(),
        userRepo.deleteToken(),
        // PayMERepository().logout(),
        ChatController().dispose(),
        Sqflite.flush(),
        Storage.dispose(),
        Prefs.dispose(),
      ]);
      yield AuthenticationUnauthenticated();
    }
  }
}
