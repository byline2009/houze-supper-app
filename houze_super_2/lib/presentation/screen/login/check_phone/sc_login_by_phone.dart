import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/blocs/language/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/language_model.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/widget_logo_houze.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';

import 'package:houze_super/presentation/screen/login/check_phone/widget_login_form.dart';
import 'package:houze_super/presentation/screen/login/style/style_login.dart';
import 'package:houze_super/presentation/screen/login/widget_title.dart';

import 'package:houze_super/utils/index.dart';
/*
 * Màn hình đăng nhập bởi số điện thoại
 */

class LoginPhoneScreen extends StatefulWidget {
  LoginPhoneScreen() : super();

  @override
  _LoginPhoneScreenState createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends RouteAwareState<LoginPhoneScreen> {
  late LanguageBloc languageBloc;
  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();
  final StreamController<LanguageModel> controller =
      StreamController<LanguageModel>.broadcast();
  late LanguageModel currentLanguage;

  @override
  void initState() {
    languageBloc = BlocProvider.of<LanguageBloc>(context);
    super.initState();
    LanguageModel _languageSelected = Storage.getLanguage();
    currentLanguage = AppConstant.languages.firstWhere((language) =>
        language.locale!.toLowerCase() ==
        _languageSelected.locale!.toLowerCase());
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
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
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: StyleLogin.margin_20,
              children: <Widget>[
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      WidgetLogoHouze(),
                      pickLanguage(),
                    ]),
                const SizedBox(height: 50),
                TitleWidget(StyleLogin.strWellcome),
                const SizedBox(height: 35),
                _buildPleaseEnterPhone(),
                _buildLoginForm(),
              ],
            ),
          ),
          progressToolkit,
        ],
      ),
    );
  }

  Widget _buildLoginForm() => WidgetLoginForm(progressToolkit: progressToolkit);

  Widget _buildPleaseEnterPhone() => Text(
        LocalizationsUtil.of(context).translate(StyleLogin.strPleaseEnterPhone),
        style: AppFonts.regular15.copyWith(
          color: Color(
            0xff838383,
          ),
        ),
      );

  Widget pickLanguage() => GestureDetector(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
            ),
            backgroundColor: Colors.white,
            context: context,
            builder: (context) => SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    AppConstant.languages.length,
                    (index) {
                      final LanguageModel item = AppConstant.languages[index];
                      return GestureDetector(
                        child: DecoratedBox(
                          key: Key(item.locale!),
                          decoration: BaseWidget.dividerBottom(
                            height: 1,
                            color: AppColor.gray_f5f5f5,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Radio(
                                    value: item.locale,
                                    activeColor: AppColor.purple_6001d2,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    groupValue: currentLanguage.locale,
                                    hoverColor: AppColor.purple_6001d2,
                                    focusColor: AppColor.purple_6001d2,
                                    onChanged: (dynamic value) async {
                                      Navigator.pop(context);
                                      if (item.locale!.toLowerCase() !=
                                          currentLanguage.locale!
                                              .toLowerCase()) {
                                        progressToolkit.state.show();
                                        await Future.delayed(
                                            Duration(milliseconds: 300));
                                        controller.sink.add(item);
                                        currentLanguage = item;
                                        // pick language event
                                        languageBloc.add(
                                          LanguageButtonPressed(
                                            language: item,
                                          ),
                                        );

                                        progressToolkit.state.dismiss();
                                      }
                                    }),
                                const SizedBox(width: 10),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColor.gray_f5f5f5,
                                    border: Border.all(
                                        width: 0, color: Colors.transparent),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        12.0,
                                      ),
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        item.flag!,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  item.name!,
                                  style: AppFonts.medium14,
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          if (item.locale!.toLowerCase() !=
                              currentLanguage.locale!.toLowerCase()) {
                            progressToolkit.state.show();
                            await Future.delayed(Duration(milliseconds: 300));

                            controller.sink.add(item);
                            currentLanguage = item;
                            // pick language event
                            languageBloc.add(
                              LanguageButtonPressed(
                                language: item,
                              ),
                            );
                            progressToolkit.state.dismiss();
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColor.gray_f5f5f5,
            border: Border.all(width: 0, style: BorderStyle.none),
            borderRadius: BorderRadius.all(
              Radius.circular(
                8.0,
              ),
            ),
          ),
          child: SizedBox(
            height: 37,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: StreamBuilder<LanguageModel>(
                  initialData: currentLanguage,
                  stream: controller.stream,
                  builder: (context, snapshot) {
                    final LanguageModel item =
                        snapshot.hasData ? snapshot.data! : currentLanguage;
                    return Row(
                      children: [
                        DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0, color: Colors.transparent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: Center(
                                child: SvgPicture.asset(
                                  item.flag!,
                                  fit: BoxFit.contain,
                                  width: 14,
                                  height: 10,
                                ),
                              ),
                            )),
                        const SizedBox(width: 5),
                        Text(LocalizationsUtil.of(context).translate(item.name),
                            textAlign: TextAlign.left,
                            style: AppFonts.semibold13
                                .copyWith(letterSpacing: 0.26)),
                        const SizedBox(width: 10),
                        SvgPicture.asset(AppVectors.icSwapHoriz),
                        const SizedBox(width: 5),
                        Text(
                          LocalizationsUtil.of(context)
                              .translate("change_a_language"),
                          textAlign: TextAlign.left,
                          style: AppFonts.medium14
                              .copyWith(color: Color(0xff5B00E4)),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      );
}
