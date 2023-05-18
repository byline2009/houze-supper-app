import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/auth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateful/widget_btn_gradient.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/login/check_phone/widget_country_picker.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/progresshub.dart';
import 'package:houze_super/utils/validators.dart';

import '../sc_verify_otp.dart';

/*
 * Build idget form nơi user input account
 * ouput: validator 
 * action: navigator to password screen
 */
class WidgetLoginForm extends StatefulWidget {
  final ProgressHUD progressToolkit;

  const WidgetLoginForm({@required this.progressToolkit});

  @override
  _WidgetLoginFormState createState() => _WidgetLoginFormState();
}

class _WidgetLoginFormState extends State<WidgetLoginForm> {
  final _phoneController = TextEditingController();
  final authAPI = AuthApi();

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {};
  final StreamController<ButtonSubmitEvent> nextBtnController =
      StreamController<ButtonSubmitEvent>.broadcast();
  String _phoneDial = '';
  ProgressHUD _progressToolkit;

  /*
   * Build
   */
  @override
  Widget build(BuildContext context) {
    // String _boldLine = 'Điều khoản & Điều kiện';
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildForm(),
          const SizedBox(height: 10),
          const SizedBox(height: 129),
          _buildButtonLogin()
        ]);
  }

  @override
  void initState() {
    super.initState();

    _phoneController.text = '';
    _phoneDial = AppConstant.phoneDial;
    _progressToolkit = widget.progressToolkit;
  }

  @override
  void dispose() {
    nextBtnController.close();
    _phoneController.dispose();
    super.dispose();
  }

  /*
   * Form
   */
  _buildForm() {
    return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            WidgetCountryPicker(callback: (String value) {
              _phoneDial = value;
            }),
            _buildField(),
          ],
        ));
  }

  _buildField() {
    return Expanded(
        child: Form(
      key: _formKey,
      child: Container(
          margin: EdgeInsets.only(left: 15),
          child: TextFormField(
            key: Key('textField'),
            keyboardAppearance: Brightness.light,
            style: AppFonts.bold18,
            controller: _phoneController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            textAlign: TextAlign.left,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 13),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Color(0xff6001d1),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: _phoneController.text != ""
                      ? Colors.black
                      : Color(0xffd0d0d0),
                  width: 1,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
            ),
            onChanged: (String phone) {
              this.isRegisterButtonEnabled(phone.trim());
            },
            onSaved: (value) {
              formData['phone_number'] = value.trim();
            },
          )),
    ));
  }

  /*
   * Button
   * - call Check phone number api
   * - get response
   * success: is_first_login ? CheckOTP page : CheckPassword page.
   * 
   * faild: show dialog by statusCode
   */
  _buildButtonLogin() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: WidgetGradientButton(
        controller: nextBtnController,
        title: LocalizationsUtil.of(context).translate('continue'),
        callback: () {
          _submitForm();
        },
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _progressToolkit.state.show(); //onSaved is called!
      try {
        final rs = await authAPI.checkPhoneNumber(
          phoneDial: _phoneDial,
          phone: formData['phone_number'],
        );

        switch (rs.isFirstLogin) {
          case true:
            _navigatorToCheckOTPPage();
            break;

          case false:
            _navigatorToCheckPasswordPage();
            break;
        }
      } catch (e) {
        if (<DioErrorType>[
          DioErrorType.DEFAULT,
          DioErrorType.CONNECT_TIMEOUT,
          DioErrorType.SEND_TIMEOUT
        ].contains(e.type))
          return showLoginErrorDialog(
            context,
            title: 'there_is_no_network',
            subtitle: 'please_check_your_network_and_try_connect_again',
          );

        if (DioErrorType.RESPONSE == e.type && e.response.data.isEmpty)
          return showLoginErrorDialog(
            context,
            title: 'your_phone_number_not_found_on_the_system',
            subtitle: 'please_contact_your_property_manager_for_your_account',
          );

        WidgetDialog.showAlert(context, 'announcement',
            'there_is_an_issue_please_try_again_later_0');
      } finally {
        Storage.savePhoneDial(_phoneDial)
            .then((value) => _progressToolkit.state.dismiss());
      }
    }
  }

  /*
   * Navigator
   */
  void _navigatorToCheckPasswordPage() {
    AppRouter.push(
      context,
      AppRouter.enterPasswordPage,
      LoginPasswordScreenArguments(
        phoneDial: _phoneDial,
        isFirstLogin: false,
        phoneNumber: formData['phone_number'],
      ),
    );
  }

  void _navigatorToCheckOTPPage() {
    AppRouter.push(
        context,
        AppRouter.verifyOTP,
        VerifyOTPPageArgument(
            phone: formData['phone_number'],
            phoneDial: _phoneDial,
            isFirstLogin: true));
  }

  /*
   * Validate
   */
  void isRegisterButtonEnabled(String phone) {
    bool valid = phone.isNotEmpty && Validators.isValidPhoneNumber(phone);
    nextBtnController.sink.add(ButtonSubmitEvent(valid));
  }

  /*
   *show dialog error
   */
  void showLoginErrorDialog(
    BuildContext context, {
    @required String title,
    @required String subtitle,
  }) {
    WidgetDialog.show(context, 8.0, [
      Image.asset(AppImages.icPhoneError),
      const SizedBox(height: 15),
      Text(
        LocalizationsUtil.of(context).translate(title),
        style: AppFonts.bold18,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      Text(
        LocalizationsUtil.of(context).translate(subtitle),
        style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 40),
      WidgetButton.pink(LocalizationsUtil.of(context).translate('try_again'),
          callback: () {
        Navigator.of(context).pop();
      })
    ]);
  }
}
