import 'dart:async';
import 'package:bloc/bloc.dart';

import 'index.dart';

class ForgotBloc extends Bloc<ForgotEvent, ForgotState> {
  ForgotBloc() : super(ForgotInitial());

  ForgotState get initialState => ForgotInitial();

  @override
  Stream<ForgotState> mapEventToState(ForgotEvent event) async* {
    if (event is ForgotCheckVerify) {
      yield ForgotLoading();
      await Future.delayed(Duration(seconds: 1));
      yield ForgotCheckedVerify(token: event.token);
    }

    if (event is ForgotReCheckVerify) {
      yield ForgotLoading();
      yield ForgotReCheckedVerify();
    }
    if (event is ResendOTP) {
      yield ForgotLoading();
    }
  }
}
