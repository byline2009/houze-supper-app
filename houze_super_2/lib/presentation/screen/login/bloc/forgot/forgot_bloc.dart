import 'package:bloc/bloc.dart';

import 'index.dart';

class ForgotBloc extends Bloc<ForgotEvent, ForgotState> {
  ForgotBloc() : super(ForgotInitial()) {
    on<ForgotReCheckVerify>((event, emit) async {
      emit(ForgotLoading());
      emit(ForgotReCheckedVerify());
    });

    on<ResendOTP>((event, emit) async {
      emit(ForgotLoading());
    });
  }
}
