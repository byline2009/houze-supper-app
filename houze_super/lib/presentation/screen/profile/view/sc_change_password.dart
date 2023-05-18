import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateful/widget_btn_gradient.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/progresshub.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  UpdatePasswordScreenState createState() => UpdatePasswordScreenState();
}

class UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  TextEditingController _currentPasswordController;
  TextEditingController _newPasswordController;

  StreamController<ButtonSubmitEvent> _confirmButtonController;

  ProgressHUD progressToolkit;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _currentPasswordController = TextEditingController();

    _currentPasswordController.text = '';
    _newPasswordController.text = '';

    progressToolkit = Progress.instanceCreateWithNormal();
    _confirmButtonController = StreamController<ButtonSubmitEvent>.broadcast();
  }

  @override
  void dispose() {
    _confirmButtonController.close();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bool isKeyboardShowing = MediaQuery.of(context).viewInsets.bottom > 0;
        if (isKeyboardShowing) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        }
      },
      child: Stack(
        children: <Widget>[
          HomeScaffold(
            title: LocalizationsUtil.of(context).translate(
              'change_your_password',
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                children: <Widget>[
                  const SizedBox(height: 31),
                  _buildFormCurrentPsw(context),
                  const SizedBox(height: 30),
                  _buildFormNewPsw(context),
                  const SizedBox(height: 100),
                  _buildButtonLogin(context),
                ],
              ),
            ),
          ),
          progressToolkit,
        ],
      ),
    );
  }

  static final _formKey = GlobalKey<FormState>();

  Key _kPassword = GlobalKey();
  Key _kConfirmPsw = GlobalKey();

  bool _isVisibleNewPsw = false;
  bool _isVisibleConfirmPsw = false;

  _buildFormCurrentPsw(BuildContext context) {
    return WidgetInput(
      textInputAction: TextInputAction.next,
      controller: _currentPasswordController,
      fieldKey: _kPassword,
      label: Text(
          LocalizationsUtil.of(context)
              .translate('please_enter_current_password'),
          style: AppFonts.regular15.copyWith(
            color: Color(0xff808080),
          )),
      suffixIcon: IconButton(
        onPressed: () {
          if (mounted)
            setState(() {
              _isVisibleNewPsw = !_isVisibleNewPsw;
            });
        },
        icon: _isVisibleNewPsw
            ? SvgPicture.asset(AppVectors.ic_visibility)
            : SvgPicture.asset(AppVectors.ic_visibility_off),
      ),
      obscureText: !_isVisibleNewPsw,
      autoFocus: true,
      maxLines: 1,
      onChanged: (String phone) {
        this.checkConfirmButtonEnable(
          psw: phone.trim(),
          newPsw: _newPasswordController.text.trim(),
        );
      },
      onSaved: (value) {
        print('Current Pasword: onSaved: $value');
      },
      validator: (value) => generateErrorText(
        value,
        _currentPasswordController,
      ),
    );
  }

  _buildFormNewPsw(BuildContext context) {
    return WidgetInput(
      controller: _newPasswordController,
      textInputAction: TextInputAction.done,
      fieldKey: _kConfirmPsw,
      label: Text(
          LocalizationsUtil.of(context).translate('please_enter_new_password'),
          style: AppFonts.regular15.copyWith(
            color: Color(0xff808080),
          )),
      suffixIcon: IconButton(
        onPressed: () {
          if (mounted) {
            setState(() {
              _isVisibleConfirmPsw = !_isVisibleConfirmPsw;
            });
          }
        },
        icon: _isVisibleConfirmPsw
            ? SvgPicture.asset(AppVectors.ic_visibility)
            : SvgPicture.asset(AppVectors.ic_visibility_off),
      ),
      obscureText: !_isVisibleConfirmPsw,
      maxLines: 1,
      onChanged: (String value) {
        checkConfirmButtonEnable(
          psw: _currentPasswordController.text.trim(),
          newPsw: value.trim(),
        );
      },
      onSaved: (value) {
        print('New password: onSaved: $value');
      },
      validator: (value) => generateErrorText(
        value,
        _newPasswordController,
      ),
    );
  }

  final String whiteSpace = ' ';

  String generateErrorText(
    String value,
    TextEditingController controller,
  ) {
    if (controller.text.isEmpty) return null;

    if (controller.text.contains(whiteSpace)) {
      return LocalizationsUtil.of(context)
          .translate('k_password_must_not_contain_white_space');
    }
    if (controller.text.length < 6) {
      return LocalizationsUtil.of(context).translate(
        "password_must_be_at_least_six_characters",
      );
    }

    return null;
  }

  /*
   * Validate
   */
  void checkConfirmButtonEnable({
    String psw,
    String newPsw,
  }) {
    bool valid =
        Validators.isValidPassword(psw) && Validators.isValidPassword(newPsw);

    _confirmButtonController.sink.add(ButtonSubmitEvent(valid));
  }

  _buildButtonLogin(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 48,
        child: WidgetGradientButton(
          controller: _confirmButtonController,
          title: LocalizationsUtil.of(context)
              .translate('confirm_change_password'),
          callback: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save(); //onSaved is called!
              if (_currentPasswordController.text ==
                  _newPasswordController.text) {
                DialogCustom.showErrorDialog(
                  context: context,
                  title: 'announcement',
                  errMsg: 'old_password_match_new_password',
                  callback: () => Navigator.of(context).pop(),
                );

                return;
              }
              progressToolkit.state.show();

              try {
                await Future.delayed(Duration(milliseconds: 400), () async {
                  final _api = ProfileAPI();
                  await _api.changePassword(
                    context: context,
                    oldPassword: _currentPasswordController.text.trim(),
                    newPassword: _newPasswordController.text.trim(),
                  );
                });
              } finally {
                progressToolkit.state.dismiss();
              }
            }
          },
        ));
  }
}
