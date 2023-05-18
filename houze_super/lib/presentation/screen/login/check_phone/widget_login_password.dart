import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateful/widget_btn_gradient.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_input.dart';

import 'package:houze_super/presentation/screen/login/bloc/index.dart';
import 'package:houze_super/presentation/screen/login/sc_check_password.dart';
import 'package:houze_super/presentation/screen/login/style/style_login.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/progresshub.dart';
import 'package:houze_super/utils/validators.dart';

import '../sc_verify_otp.dart';

/*
 * Build Widget form nơi user input password
 * ouput: validator 
 * action: navigator to forgot/home screen
 */
class WidgetLoginPasswordForm extends StatefulWidget {
  final LoginPasswordScreenArguments args;
  final ProgressHUD progress;
  const WidgetLoginPasswordForm({
    @required this.args,
    @required this.progress,
  });

  @override
  _WidgetLoginPasswordFormState createState() =>
      _WidgetLoginPasswordFormState();
}

class _WidgetLoginPasswordFormState extends State<WidgetLoginPasswordForm> {
  TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {'password': null};
  StreamController<ButtonSubmitEvent> loginBtnController;

  bool _isVisibleConfirmPw;
  ProgressHUD _progress;
  LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    loginBtnController = StreamController<ButtonSubmitEvent>.broadcast();
    _isVisibleConfirmPw = false;
    _passwordController.text = '';
    _progress = widget.progress;
  }

  @override
  void dispose() {
    if (loginBtnController != null) loginBtnController.close();
    if (_passwordController != null) _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocListener<LoginBloc, LoginState>(
      cubit: loginBloc,
      listener: (context, state) async {
        print("check password $state");
        if (state is LoginLoading) {
          _progress.state.show();
        }

        if (state is LoginSuccessful) {
          AppRouter.pushReplacementNoParams(context, AppRouter.ROOT);
        }

        if (state is LoginFailure) {
          _progress.state.dismiss();
          showErrorDialog(context, state.error.toString());
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildForm(context),
          const SizedBox(height: 40),
          WidgetButton.text(
              title: LocalizationsUtil.of(context)
                  .translate('forgot_password_with_question_mark'),
              callback: () {
                _forgotPassword();
              }),
          const SizedBox(height: 95),
          _buildButtonLogin(),
        ],
      ),
    );
  }

  /*
   *show dialog error 
   */
  void showErrorDialog(BuildContext context, String error) {
    WidgetDialog.show(
        context,
        8.0,
        [
          const SizedBox(height: 20),
          Image.asset(AppImages.icPhoneError),
          const SizedBox(height: 15),
          Text(
            LocalizationsUtil.of(context).translate('announcement'),
            style: AppFonts.bold18,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            LocalizationsUtil.of(context).translate(error),
            style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          WidgetButton.pink(
              LocalizationsUtil.of(context).translate('try_again'),
              callback: () {
            _passwordController.clear();
            this.isRegisterButtonEnabled('');
            Navigator.of(context).pop();
          })
        ],
        closeShow: false);
  }

  _buildForm(BuildContext context) {
    return WidgetInput(
      controller: _passwordController,
      fieldKey: _formKey,
      label: Text(
          LocalizationsUtil.of(context)
              .translate(StyleLogin.strPleaseEnterPassword),
          style: AppFonts.regular15.copyWith(
            color: Color(0xff808080),
          )),
      suffixIcon: IconButton(
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onPressed: () {
          setState(() {
            _isVisibleConfirmPw = !_isVisibleConfirmPw;
          });
        },
        icon: _isVisibleConfirmPw
            ? SvgPicture.asset(AppVectors.ic_visibility)
            : SvgPicture.asset(
                AppVectors.ic_visibility_off,
              ),
      ),
      obscureText: !_isVisibleConfirmPw,
      autoFocus: true,
      maxLines: 1,
      onChanged: (String phone) {
        this.isRegisterButtonEnabled(phone.trim());
      },
      onSaved: (value) {
        formData['password'] = value.trim();
      },
    );
  }

  _buildButtonLogin() {
    return SizedBox(
        width: double.infinity,
        height: 48,
        child: WidgetGradientButton(
          controller: loginBtnController,
          title: LocalizationsUtil.of(context).translate('login'),
          callback: () {
            _submitForm();
          },
        ));
  }

  void _submitForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      loginBloc.add(
        LoginSubmitPhonePasswordEvent(
          dial: widget.args.phoneDial,
          phone: widget.args.phoneNumber,
          password: formData['password'],
        ),
      );
    }
  }

  /*
   * Validate
   */
  void isRegisterButtonEnabled(String psw) {
    bool valid = psw.isNotEmpty && Validators.isValidPassword(psw);
    loginBtnController.sink.add(ButtonSubmitEvent(valid));
  }

  /*
   * Action
   */

  void _forgotPassword() {
    AppRouter.push(
      context,
      AppRouter.verifyOTP,
      VerifyOTPPageArgument(
        phoneDial: widget.args.phoneDial,
        phone: widget.args.phoneNumber,
        isFirstLogin: false,
      ),
    );
  }
}
