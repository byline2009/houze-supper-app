import 'package:bloc/bloc.dart';
import 'package:houze_super/app/blocs/authentication/authentication_bloc.dart';
import 'package:houze_super/app/blocs/authentication/authentication_event.dart';
import 'package:houze_super/middle/model/token_model.dart';
import 'package:houze_super/middle/repo/user_repository.dart';
import 'package:houze_super/presentation/screen/login/bloc/index.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    required this.authenticationBloc,
  }) : super(LoginInitial()) {
    this.userRepository = authenticationBloc.userRepository;
    on<LoginSubmitPhonePasswordEvent>((event, emit) async {
      emit(LoginLoading());

      try {
        TokenModel rs = await userRepository.authenticate(
          phoneDial: event.dial,
          phone: event.phone,
          password: event.password,
        );

        authenticationBloc.add(LoggedIn(token: rs.access));

        emit(LoginSuccessful());
      } catch (error) {
        emit(LoginFailure(
            error: error == 'Sai tài khoản hoặc mật khẩu'
                ? 'wrong_account_or_password'
                : "Đăng ký token không thành công"));
      }
    });
  }
}
