import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/bloc/authentication/authentication_event.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/login/check_phone/sc_login_by_phone.dart';
import 'package:houze_super/utils/index.dart';

const IS_LOGOUT = "is_logout";

class ButtonLogoutSection extends StatelessWidget {
  const ButtonLogoutSection({
    Key key,
    @required this.progressHUD,
  }) : super(key: key);
  final ProgressHUD progressHUD;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        AppDialog.showContentDialog(
          context: context,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20,
            ),
            child: SizedBox(
              height: 210,
              child: Column(
                children: <Widget>[
                  Text(LocalizationsUtil.of(context).translate("sign_out"),
                      textAlign: TextAlign.center, style: AppFonts.bold16),
                  const SizedBox(height: 20),
                  Text(
                    LocalizationsUtil.of(context)
                        .translate("are_you_sure_to_sign_out_of_the_houze_app"),
                    textAlign: TextAlign.center,
                    style: AppFonts.regular15
                        .copyWith(color: Color(0xff808080))
                        .copyWith(
                          letterSpacing: 0.24,
                          fontFamily: AppFonts.font_family_display,
                        ),
                  ),
                  const SizedBox(height: 40),
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
                        const SizedBox(width: 15),
                        Expanded(
                          child: WidgetButton.outline(
                            LocalizationsUtil.of(context).translate('sign_out'),
                            callback: () async {
                              BlocProvider.of<LoginBloc>(context)
                                  .authenticationBloc
                                  .add(LoggedOut());
                              Navigator.of(context).pop();
                              progressHUD.state.show();
                              await Future.delayed(Duration(milliseconds: 300),
                                  () {
                                //reset default icon
                                final prefs = Storage.prefs;
                                if (prefs.getInt(currentAppIconKey) != null) {
                                  Future.wait([
                                    prefs.remove(currentAppIconKey),
                                    prefs.setBool(IS_LOGOUT, true),
                                  ]);
                                }
                              }).whenComplete(
                                () {
                                  progressHUD.state.dismiss();
                                  AppRouter.pushAndRemoveUntil(
                                    context,
                                    LoginPage.routeName,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          closeShow: false,
        );
      },
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Container(
        height: 48,
        margin: EdgeInsets.symmetric(vertical: 20),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(0xfffff0f0),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text(
          LocalizationsUtil.of(context).translate('sign_out'),
          textAlign: TextAlign.center,
          style: AppFonts.bold16.copyWith(color: Color(0xffC50000)),
        ),
      ),
    );
  }
}
