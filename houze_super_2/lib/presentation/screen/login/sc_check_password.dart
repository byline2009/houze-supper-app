import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/login/widget_title.dart';

class LoginPasswordScreenArguments {
  final String phoneDial;
  final String phoneNumber;
  final bool isFirstLogin;

  LoginPasswordScreenArguments({
    required this.phoneDial,
    required this.phoneNumber,
    required this.isFirstLogin,
  });
}

class LoginPasswordScreen extends StatelessWidget {
  final LoginPasswordScreenArguments args;
  LoginPasswordScreen({
    required this.args,
  });
  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HomeScaffold(
          title: '',
          child: GestureDetector(
            onTap: () {
              bool isKeyboardShowing =
                  MediaQuery.of(context).viewInsets.bottom > 0;
              if (isKeyboardShowing) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              }
            },
            child: ListView(padding: StyleLogin.margin_20, children: <Widget>[
              TitleWidget(StyleLogin.strTitleEnterPsw),
              const SizedBox(height: 35),
              WidgetLoginPasswordForm(args: args, progress: progressToolkit)
            ]),
          ),
        ),
        progressToolkit
      ],
    );
  }
}
