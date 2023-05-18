import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/blocs/authentication/authentication_bloc.dart';
import 'package:houze_super/app/blocs/authentication/authentication_event.dart';
import 'package:houze_super/app/blocs/authentication/authentication_state.dart';
import 'package:houze_super/app/blocs/overlay/index.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/index.dart';

class NoBuildingScreen extends StatelessWidget {
  final ProgressHUD _progressToolkit = Progress.instanceCreateWithNormal();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Stack(children: <Widget>[
          MultiBlocListener(
              listeners: [
                BlocListener<OverlayBloc, OverlayBlocState>(
                  listener: (context, overlayState) {
                    if (overlayState is PickBuildingSuccessful) {
                      _progressToolkit.state.dismiss();
                      if (overlayState.buildings.length > 0) {
                        AppRouter.pushReplacementNoParams(
                            context, AppRouter.ROOT);
                      }
                    }
                  },
                ),
//        Pick language button
                BlocListener<AuthenticationBloc, AuthenticationState>(
                    listener: (context, authState) {
                  if (authState is AuthenticationUnauthenticated) {
                    AppRouter.pushAndRemoveUntil(context, AppRouter.LOGIN);
                  }
                }),
              ],
              child: Scaffold(
                  backgroundColor: Colors.white,
                  body: SafeArea(
                      child: ListView(
                    padding: EdgeInsets.only(top: 0),
                    shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(height: 100),
                      SvgPicture.asset('assets/svg/404/ic-empty-building.svg'),
                      SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                              LocalizationsUtil.of(context).translate(
                                  "sorry_we_couldn’t_find_your_building_please_contact_your_building's_pm"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFont.font_family_display,
                                  fontSize: 16.0,
                                  letterSpacing: 0.5,
                                  color: AppColor.gray_808080,
                                  fontWeight: FontWeight.w500))),
                      SizedBox(height: 50),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: ButtonWidget(
                              defaultHintText: LocalizationsUtil.of(context)
                                  .translate('reload'),
                              isActive: true,
                              callback: () async {
                                _progressToolkit.state.show();
                                await Future.delayed(
                                        Duration(milliseconds: 500))
                                    .then((value) =>
                                        context.read<OverlayBloc>().add(
                                              BuildingPicked(),
                                            ));
                              })),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Color(0xffd4d6d9),
                                      offset: new Offset(0, 2.0),
                                      blurRadius: 10.0,
                                    )
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(0xffebeef2),
                                      width: 0.7,
                                      style: BorderStyle.solid)),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 5.0, left: 5.0),
                                  child: TextButton(
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty
                                          .resolveWith<Color?>(
                                              (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed))
                                          return Colors.transparent;
                                        return null; // Defer to the widget's default.
                                      }),
                                    ),
                                    child: Text(
                                      LocalizationsUtil.of(context)
                                          .translate('sign_out'),
                                      style: TextStyle(
                                        color: Color(0xffff6666),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    onPressed: () async {
                                      await Future.delayed(
                                              Duration(microseconds: 500))
                                          .then((value) => context
                                              .read<AuthenticationBloc>()
                                              .add(LoggedOut()));
                                    },
                                  ))))
                    ],
                  )))),
          _progressToolkit
        ]));
  }
}
