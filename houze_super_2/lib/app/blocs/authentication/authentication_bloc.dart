import 'package:bloc/bloc.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:houze_super/app/blocs/authentication/authentication_event.dart';
import 'package:houze_super/app/blocs/authentication/authentication_state.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/repo/user_repository.dart';
import 'package:houze_super/middle/ws/index.dart';
import 'package:houze_super/utils/index.dart';

/* Handling authentication */
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final userRepository = new UserRepository();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    // when user open app, check if access token has already existed
    on<AppStarted>((event, emit) async {
      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        emit(AuthenticationAuthenticated());
      } else {
        emit(AuthenticationUnauthenticated());
      }
    });
    // event: user login
    on<LoggedIn>((event, emit) {
      emit(AuthenticationLoading());
      //await userRepository.persistToken(event.token);
      emit(AuthenticationAuthenticated(isLoginEvent: true));
    });
    // event: user log out
    on<LoggedOut>((event, emit) async {
      emit(AuthenticationLoading());
      FlutterAppBadger.removeBadge();
      await ChatController().dispose();
      await userRepository.deleteToken();
      OauthAPI.token = null;
      await Sqflite.flush();
      await Storage.clear();
      emit(AuthenticationUnauthenticated());
    });
    // event: user tap log out button
    on<LogOutButtonTapped>((event, emit) async {
      emit(LogOutButtonTapLoading());
      FlutterAppBadger.removeBadge();
      await ChatController().dispose();
      await userRepository.deleteToken();
      OauthAPI.token = null;
      await Sqflite.flush();
      await Storage.clear();
      emit(AuthenticationUnauthenticated());
    });
  }
}
