import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/api/auth_api.dart';
import 'package:houze_super/middle/model/login/verify_otp_model.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/widget_btn_gradient.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/index.dart';

import '../../base/route_aware_state.dart';
import 'widget_title.dart';

class CreatePasswordScreenArgument {
  final bool? isFirstLogin;
  final VerifyOTPModel? otpModel;

  const CreatePasswordScreenArgument({this.otpModel, this.isFirstLogin});
}

class CreatePasswordScreen extends StatefulWidget {
  final CreatePasswordScreenArgument? agr;

  const CreatePasswordScreen({this.agr});

  @override
  CreatePasswordScreenState createState() => CreatePasswordScreenState();
}

class CreatePasswordScreenState extends RouteAwareState<CreatePasswordScreen> {
  late Size _screenSize;
  var hasError = false;
  late bool _isFirstLogin;
  late VerifyOTPModel _otpModel;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  StreamController<ButtonSubmitEvent> _nextButtonController =
      StreamController<ButtonSubmitEvent>();

  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();

  var authAPI = AuthApi();

  @override
  void initState() {
    super.initState();

    _otpModel = widget.agr!.otpModel!;
    _isFirstLogin = widget.agr!.isFirstLogin!;
  }

  @override
  void dispose() {
    _nextButtonController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._screenSize = MediaQuery.of(context).size;

    return Stack(children: <Widget>[
      BaseScaffold(title: '', child: initContentPassword(context)),
      progressToolkit
    ]);
  }

  Widget initContentPassword(BuildContext context) {
    final padding = this._screenSize.width * 5 / 100;
    final paddingScreen = EdgeInsets.only(left: padding, right: padding);
    final _title = _isFirstLogin && _isFirstLogin == true
        ? LocalizationsUtil.of(context).translate('create_a_password')
        : LocalizationsUtil.of(context).translate('create_new_password');

    return Container(
        padding: paddingScreen,
        width: double.infinity,
        child: Form(
            key: _formKey,
            child:
                ListView(padding: const EdgeInsets.all(0), children: <Widget>[
              SizedBox(height: 55),
              TitleWidget(_title),
              SizedBox(height: 35),
              _buildFormNewPsw(context),
              SizedBox(height: 30),
              _buildFormConfirmPsw(context),
              SizedBox(height: 45),
              _buildButtonLogin(),
            ])));
  }

  static final _formKey = GlobalKey<FormState>();

  Key _kPassword = GlobalKey();
  Key _kConfirmPsw = GlobalKey();

  bool _isVisibleNewPsw = false;
  bool _isVisibleConfirmPsw = false;

  _buildFormNewPsw(BuildContext context) {
    return WidgetInput(
      style: AppFonts.bold18,
      textInputAction: TextInputAction.next,
      controller: _passwordController,
      fieldKey: _kPassword,
      label: Text(
          LocalizationsUtil.of(context).translate('please_enter_new_password'),
          style: AppFonts.regular15.copyWith(
            color: Color(0xff838383),
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
      onChanged: (dynamic phone) {
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
                color: Color(0xff838383),
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
      onChanged: (dynamic value) {
        isRegisterButtonEnabled(
            psw: _passwordController.text.trim(), confirmPsw: value.trim());
      },
      onSaved: (value) {},
    );
  }

  /*
   * Validate
   */
  void isRegisterButtonEnabled(
      {required String psw, required String confirmPsw}) {
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  padding: EdgeInsets.all(20),
                  duration: Duration(seconds: 5),
                  content: Text(
                    LocalizationsUtil.of(context)
                        .translate("your_passwords_don't_match"),
                    style: AppFonts.regular16.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.red[600]!,
                ),
              );

              return;
            }

            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save(); //onSaved is called!

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
                );
              } finally {
                progressToolkit.state.dismiss();
              }
            }
          },
        ));
  }
}
