import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/api/auth_api.dart';
import 'package:houze_super/middle/model/login/verify_otp_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_base_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateful/widget_btn_gradient.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/progresshub.dart';
import 'package:houze_super/utils/toast.dart';

import 'widget_title.dart';

class CreatePasswordPageArgument {
  final bool isFirstLogin;
  final VerifyOTPModel otpModel;

  const CreatePasswordPageArgument({
    this.otpModel,
    this.isFirstLogin,
  });
}

class CreatePasswordPage extends StatefulWidget {
  final CreatePasswordPageArgument agr;
  const CreatePasswordPage({
    this.agr,
  });

  @override
  CreatePasswordPageState createState() => CreatePasswordPageState();
}

class CreatePasswordPageState extends State<CreatePasswordPage> {
  bool _isFirstLogin;
  VerifyOTPModel _otpModel;

  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  StreamController<ButtonSubmitEvent> _nextButtonController;
  ProgressHUD progressToolkit;

  AuthApi authAPI;
  static final _formKey = GlobalKey<FormState>();

  Key _kPassword = GlobalKey();
  Key _kConfirmPsw = GlobalKey();

  bool _isVisibleNewPsw;
  bool _isVisibleConfirmPsw;

  @override
  void initState() {
    super.initState();

    _otpModel = widget.agr.otpModel;
    _isFirstLogin = widget.agr.isFirstLogin;

    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nextButtonController = StreamController<ButtonSubmitEvent>();
    progressToolkit = Progress.instanceCreateWithNormal();
    authAPI = AuthApi();

    _isVisibleNewPsw = false;
    _isVisibleConfirmPsw = false;
  }

  @override
  void dispose() {
    if (_nextButtonController != null) _nextButtonController.close();
    if (_passwordController != null) _passwordController.dispose();
    if (_confirmPasswordController != null)
      _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      BaseScaffold(title: '', child: initContentPassword(context)),
      progressToolkit
    ]);
  }

  Widget initContentPassword(BuildContext context) {
    final Size sizeSys = MediaQuery.of(context).size;

    final padding = sizeSys.width * 5 / 100;
    final paddingScreen = EdgeInsets.only(left: padding, right: padding);
    final _title = _isFirstLogin != null && _isFirstLogin
        ? LocalizationsUtil.of(context).translate('create_a_password')
        : LocalizationsUtil.of(context).translate('create_new_password');

    return Container(
      padding: paddingScreen,
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            const SizedBox(height: 55),
            TitleWidget(_title),
            const SizedBox(height: 35),
            _buildFormNewPsw(context),
            const SizedBox(height: 30),
            _buildFormConfirmPsw(context),
            const SizedBox(height: 45),
            _buildButtonLogin(),
          ],
        ),
      ),
    );
  }

  _buildFormNewPsw(BuildContext context) {
    return WidgetInput(
      style: AppFonts.bold18,
      textInputAction: TextInputAction.next,
      controller: _passwordController,
      fieldKey: _kPassword,
      label: Text(
          LocalizationsUtil.of(context).translate('please_enter_new_password'),
          style: AppFonts.regular15.copyWith(
            color: Color(0xff808080),
          )),
      suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isVisibleNewPsw = !_isVisibleNewPsw;
            });
          },
          icon: _isVisibleNewPsw
              ? SvgPicture.asset(AppVectors.ic_visibility)
              : SvgPicture.asset(AppVectors.ic_visibility_off)),
      obscureText: !_isVisibleNewPsw,
      autoFocus: true,
      maxLines: 1,
      onChanged: (String phone) {
        this.isRegisterButtonEnabled(
            psw: phone.trim(),
            confirmPsw: _confirmPasswordController.text.trim());
      },
      onSaved: (value) {},
    );
  }

  _buildFormConfirmPsw(BuildContext context) {
    return WidgetInput(
      style: AppFonts.bold18,
      controller: _confirmPasswordController,
      textInputAction: TextInputAction.done,
      fieldKey: _kConfirmPsw,
      label:
          Text(LocalizationsUtil.of(context).translate('confirm_new_password'),
              style: AppFonts.regular15.copyWith(
                color: Color(0xff808080),
              )),
      suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isVisibleConfirmPsw = !_isVisibleConfirmPsw;
            });
          },
          icon: _isVisibleConfirmPsw
              ? SvgPicture.asset(AppVectors.ic_visibility)
              : SvgPicture.asset(AppVectors.ic_visibility_off)),
      obscureText: !_isVisibleConfirmPsw,
      autoFocus: true,
      maxLines: 1,
      onChanged: (String value) {
        isRegisterButtonEnabled(
            psw: _passwordController.text.trim(), confirmPsw: value.trim());
      },
      onSaved: (value) {},
    );
  }

  /*
   * Validate
   */
  void isRegisterButtonEnabled({String psw, String confirmPsw}) {
    bool valid = Validators.isValidPassword(psw) &&
        Validators.isValidPassword(confirmPsw) &&
        psw.length == confirmPsw.length;

    _nextButtonController.sink.add(ButtonSubmitEvent(valid));
  }

  _buildButtonLogin() {
    return SizedBox(
        width: double.infinity,
        height: 48,
        child: WidgetGradientButton(
          controller: _nextButtonController,
          title: LocalizationsUtil.of(context).translate('create_a_password'),
          callback: () async {
            if (_passwordController.text != _confirmPasswordController.text) {
              ToastUtil.show(
                ToastDecorator(
                  widget: Text(
                      LocalizationsUtil.of(context)
                          .translate("your_passwords_don't_match"),
                      style: AppFonts.medium16.copyWith(color: Colors.white)),
                  backgroundColor: Colors.red[600],
                  borderRadius: BorderRadius.circular(5),
                  padding: const EdgeInsets.all(20),
                ),
                context,
                gravity: ToastPosition.center,
                duration: 5,
              );

              return;
            }

            if (_formKey.currentState.validate()) {
              _formKey.currentState.save(); //onSaved is called!

              progressToolkit.state.show();

              try {
                await authAPI
                    .resetPasswordV2(
                        password: _confirmPasswordController.text,
                        otpModel: _otpModel)
                    .then((value) {
                  if (value == true) {
                    DialogCustom.showSuccessDialog(
                        context: context,
                        title: 'announcement',
                        svgPath: AppVectors.graphicShield,
                        content: 'password_has_created_please_sign_in_again',
                        buttonText: 'login',
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context, rootNavigator: true).pop();
                        });
                  } else {
                    DialogCustom.showErrorDialog(
                      errMsg: 'there_is_an_issue_please_try_again_later_0',
                      context: context,
                      title: 'announcement',
                      buttonText: 'ok',
                      callback: () => Navigator.pop(context),
                    );
                  }
                });
              } catch (e) {
                print(e.toString());
                DialogCustom.showErrorDialog(
                  errMsg: 'there_is_an_issue_please_try_again_later_0',
                  context: context,
                  title: 'announcement',
                  buttonText: 'ok',
                  callback: () => Navigator.pop(context),
                );
              } finally {
                progressToolkit.state.dismiss();
              }
            }
          },
        ));
  }
}
