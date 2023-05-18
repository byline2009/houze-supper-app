import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/base_scaffold_no_focus.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/screen/login/bloc/forgot/index.dart';
import 'package:houze_super/presentation/screen/login/widget_pin_code_text_field.dart';
import 'package:houze_super/presentation/screen/login/widget_title.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../index.dart';

class VerifyOTPScreenArgument {
  final String? phone;
  final String? phoneDial;
  final bool? isFirstLogin;
  const VerifyOTPScreenArgument({
    this.phone,
    this.phoneDial,
    this.isFirstLogin,
  });
}

class VerifyOTPScreen extends StatefulWidget {
  final VerifyOTPScreenArgument? agr;

  const VerifyOTPScreen({this.agr});

  @override
  VerifyOTPScreenState createState() => VerifyOTPScreenState();
}

class VerifyOTPScreenState extends RouteAwareState<VerifyOTPScreen> {
  late String _phoneNumber;
  bool _isFirstLogin = false;
  bool _showWaiting = true;
  final _pinEditingController = TextEditingController();
  final FocusNode _pinFocus = FocusNode();
  var _seconds = 60;

  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();
  late ForgotBloc _authBloc;
  final api = LoginAPI();

  @override
  void initState() {
    super.initState();
    _authBloc = context.read<ForgotBloc>();
    _phoneNumber = widget.agr!.phone!;
    _isFirstLogin = widget.agr!.isFirstLogin!;

    _generateOTPToVerifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    double _padding = MediaQuery.of(context).size.width * 5 / 100;

    return Stack(children: [
      BaseScaffoldNoFocus(
        title: title(),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.only(
                    left: _padding, right: _padding, bottom: 0, top: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 50),
                    TitleWidget('enter_otp_with_upper_case'),
                    const SizedBox(height: 35),
                    WidgetRichText(
                        myString: LocalizationsUtil.of(context)
                                .translate('the_code_was_sent_to_with_colon') +
                            ' ' +
                            _phoneNumber,
                        style: AppFont.BOLD_BLACK_15,
                        wordToStyle: LocalizationsUtil.of(context)
                            .translate(_phoneNumber)),
                    WidgetPinCode(
                      context: context,
                      pinFocus: _pinFocus,
                      pinEditingController: _pinEditingController,
                      callback: (value) {
                        progressToolkit.state.show();
                        _verifyOTPWithPhoneNumber(value.trim());
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<ForgotBloc, ForgotState>(
                        bloc: _authBloc,
                        builder: (
                          BuildContext context,
                          ForgotState forgotState,
                        ) {
                          return _buildResendOTP();
                        }),
                    const SizedBox(height: 16),
                  ],
                )),
          ],
        ),
      ),
      progressToolkit
    ]);
  }

  Widget _buildResendOTP() {
    if (_showWaiting && _showWaiting == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(AppVectors.ic_autorenew),
          const SizedBox(width: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocalizationsUtil.of(context)
                    .translate("resend_the_code_after"),
                style: AppFont.BOLD_GRAY.copyWith(
                  color: AppColor.gray_838383,
                  fontSize: 15,
                  letterSpacing: 0.24,
                ),
              ),
              Countdown(
                  seconds: _seconds,
                  onFinished: () {
                    _showWaiting = false;
                    print('CountDown Finish');
                    _authBloc.add(ResendOTP());
                  },
                  build: (_, double time) =>
                      Text(time.toInt().toString(), style: AppFonts.regular15))
            ],
          ),
          Text(
            LocalizationsUtil.of(context)
                .translate("seconds_with_space_and_lower_case"),
            style: AppFonts.regular15,
          ),
          Text(
            LocalizationsUtil.of(context)
                .translate("again_with_space_and_lower_case"),
            style: AppFonts.regular15.copyWith(
              color: Color(0xff838383),
            ),
          ),
        ],
      );
    }
    return TextButton(
      onPressed: () {
        _generateOTPToVerifyPhone();
        _authBloc.add(ForgotReCheckVerify());
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(AppVectors.ic_autorenew,
                color: AppColor.purple_6001d1),
            SizedBox(width: 5),
            Text(LocalizationsUtil.of(context).translate("resend_otp"),
                style: AppFont.BOLD_PURPLE_6001d1_16.copyWith(fontSize: 15)
                    .copyWith(letterSpacing: 0.24))
          ]),
    );
  }

  String title() => _isFirstLogin && _isFirstLogin == true
      ? LocalizationsUtil.of(context).translate('verify_your_phone_number')
      : LocalizationsUtil.of(context).translate('forgot_password');

  onErrorGenerateOTP(String sms) {
    DialogCustom.showErrorDialog(
      context: context,
      title: 'announcement',
      errMsg: sms,
      buttonText: 'ok',
    );
  }

  /// Generate the code to verify phone number
  Future<bool> _generateOTPToVerifyPhone() async {
    final response = await api.generateOtp(
        phone: _phoneNumber, phoneDial: widget.agr!.phoneDial!);
    progressToolkit.state.dismiss();

    if (response == true) {
      _showWaiting = true;
    } else {
      String msg =
          "your_phone_number_has_exceeded_the_requirement_of_five_otp_codes_in_one_minute";
      onErrorGenerateOTP(msg);
    }
    return response;
  }

  onError() {
    progressToolkit.state.dismiss();
    _pinEditingController.clear();
    FocusScope.of(context).requestFocus(_pinFocus);

    DialogCustom.showErrorDialog(
      errMsg: 'otp_is_not_correct',
      context: context,
      title: 'announcement',
      buttonText: 'try_again',
      callback: () {
        Navigator.pop(context);
        _authBloc.add(ForgotReCheckVerify());
      },
    );
  }

  void _verifyOTPWithPhoneNumber(String smsCode) async {
    try {
      final response = await api.verityOtp(
          otpToken: smsCode,
          phone: _phoneNumber,
          phoneDial: widget.agr!.phoneDial!);
      progressToolkit.state.dismiss();
      if ((response.accessToken!).isNotEmpty) {
        AppRouter.replace(
            context,
            AppRouter.CREATE_PASSWORD_PAGE,
            CreatePasswordScreenArgument(
              otpModel: response,
              isFirstLogin: _isFirstLogin,
            ));
      } else {
        onError();
      }
    } catch (e) {
      onError();
    }
  }
}
