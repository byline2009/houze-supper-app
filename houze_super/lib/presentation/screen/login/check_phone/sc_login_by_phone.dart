import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/bloc/language/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/language_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_logo_houze.dart';

import 'package:houze_super/presentation/screen/login/check_phone/widget_login_form.dart';
import 'package:houze_super/presentation/screen/login/style/style_login.dart';
import 'package:houze_super/presentation/screen/login/widget_bottom_sheet_pick_language.dart';
import 'package:houze_super/presentation/screen/login/widget_title.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/progresshub.dart';
/*
 * Màn hình đăng nhập bởi số điện thoại 
 */

class LoginPage extends StatefulWidget {
  const LoginPage() : super();
  static const routeName = 'app://login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();
  final StreamController<LanguageModel> controller =
      StreamController<LanguageModel>.broadcast();
  LanguageModel currentLanguage;

  @override
  void initState() {
    super.initState();

    LanguageModel _languageSelected = Storage.getLanguage();
    currentLanguage = AppConstant.languages.firstWhere(
      (language) =>
          language.locale.toLowerCase() ==
          _languageSelected.locale.toLowerCase(),
    );
  }

  @override
  void dispose() {
    if (controller != null) controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          GestureDetector(
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
              const SizedBox(height: 10),
              _buildTopChooseLanguage(),
              const SizedBox(height: 60),
              TitleWidget(StyleLogin.strWellcome),
              const SizedBox(height: 35),
              _buildPleaseEnterPhone(),
              _buildLoginForm(),
            ]),
          ),
          progressToolkit
        ]));
  }

  _buildLoginForm() => WidgetLoginForm(progressToolkit: progressToolkit);

  _buildPleaseEnterPhone() => Text(
        LocalizationsUtil.of(context).translate(StyleLogin.strPleaseEnterPhone),
        style: AppFonts.regular15.copyWith(
          color: Color(0xff808080),
        ),
      );

  double get heightBottomSheet =>
      (540 * MediaQuery.of(context).size.height) / 812;

  Widget _buildTopChooseLanguage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        WidgetLogoHouze(),
        pickLanguage(),
      ],
    );
  }

  Widget pickLanguage() => GestureDetector(
        onTap: () {
          PickLanguageBottomSheet.showBottomSheet(
              contextParent: context,
              height: heightBottomSheet,
              currentLanguage: currentLanguage,
              callback: (value) {
                if (value.locale.toLowerCase() !=
                    currentLanguage.locale.toLowerCase()) {
                  controller.sink.add(value);
                  currentLanguage = value;
                  context.read<ChangeLanguageBloc>().add(
                        ChangeLanguageEvent(
                          language: value,
                        ),
                      );
                }
              });
        },
        child: Container(
          padding:const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          height: 37,
          decoration: BoxDecoration(
              color: Color(0xfff5f5f5),
              border: Border.all(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: StreamBuilder<LanguageModel>(
              initialData: currentLanguage,
              stream: controller.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final LanguageModel item = snapshot.data;
                  return Row(children: [
                    Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            item.flag,
                            fit: BoxFit.contain,
                            width: 14,
                            height: 10,
                          ),
                        )),
                    const SizedBox(width: 5),
                    Text(
                      LocalizationsUtil.of(context).translate(item.name),
                      textAlign: TextAlign.left,
                      style: AppFonts.semibold13.copyWith(
                        letterSpacing: 0.26,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      AppVectors.icSwapHoriz,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      LocalizationsUtil.of(context)
                          .translate("change_a_language"),
                      textAlign: TextAlign.left,
                      style: AppFonts.medium14.copyWith(
                        color: Color(
                          0xff5b00e4,
                        ),
                      ),
                    ),
                  ]);
                }
                return Container(
                  width: 140,
                  height: 37,
                  color: Color(
                    0xfff5f5f5,
                  ),
                );
              }),
        ),
      );
}
