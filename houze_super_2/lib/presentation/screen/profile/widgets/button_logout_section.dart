import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/blocs/authentication/authentication_event.dart';
import 'package:houze_super/app/blocs/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';

const is_logout = "is_logout";

class ButtonLogoutSection extends StatelessWidget {
  final ProgressHUD progressHUD;
  const ButtonLogoutSection({Key? key, required this.progressHUD})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          AppDialog.showContentDialog(
            context: context,
            child: Container(
              height: 215,
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
              child: Column(
                children: <Widget>[
                  Text(LocalizationsUtil.of(context).translate("sign_out"),
                      textAlign: TextAlign.center,
                      style: AppFonts.bold16
                          .copyWith(fontFamily: AppFont.font_family_display)),
                  SizedBox(height: 20),
                  Text(
                    LocalizationsUtil.of(context)
                        .translate("are_you_sure_to_sign_out_of_the_houze_app"),
                    textAlign: TextAlign.center,
                    style: AppFonts.regular15
                        .copyWith(
                          color: Color(
                            0xff808080,
                          ),
                        )
                        .copyWith(
                          letterSpacing: 0.24,
                          fontFamily: AppFont.font_family_display,
                        ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    height: 44,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: WidgetButton.pink(
                            LocalizationsUtil.of(context).translate('back'),
                            callback: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: WidgetButton.outline(
                            LocalizationsUtil.of(context).translate('sign_out'),
                            callback: () async {
                              // FlutterAppBadger.removeBadge();
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(LogOutButtonTapped());
                              // BlocProvider.of<LoginBloc>(context)
                              //     .authenticationBloc
                              //     .add(LogOutButtonTapped());
                              Navigator.of(context).pop();
                              progressHUD.state.show();
                              await Future.delayed(Duration(milliseconds: 300),
                                  () {
                                //reset default icon
                                final prefs = Storage.prefs;
                                if (prefs?.getString(
                                        currentSelectedAppIconKey) !=
                                    null) {
                                  if (prefs?.getString(
                                          currentSelectedAppIconKey) !=
                                      "default") {
                                    prefs?.remove(currentSelectedAppIconKey);
                                  }
                                  prefs?.setBool(is_logout, true);
                                }
                              }).whenComplete(() {
                                progressHUD.state.dismiss();
                                AppRouter.pushAndRemoveUntil(
                                  context,
                                  AppRouter.LOGIN,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            closeShow: false,
          );
        },
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.transparent),
        ),
        child: Container(
          height: 48,
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xfffff0f0),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Text(
            LocalizationsUtil.of(context).translate('sign_out'),
            textAlign: TextAlign.center,
            style: AppFont.BOLD_RED_C50000_16,
          ),
        ));
  }
}
