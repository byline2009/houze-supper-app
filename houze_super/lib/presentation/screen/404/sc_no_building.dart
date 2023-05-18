import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/bloc/authentication/authentication_bloc.dart';
import 'package:houze_super/app/bloc/authentication/authentication_event.dart';
import 'package:houze_super/app/bloc/authentication/authentication_state.dart';
import 'package:houze_super/app/bloc/overlay/index.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/login/check_phone/sc_login_by_phone.dart';

class NoBuildingScreenArgument {
  final OverlayBloc bloc;
  const NoBuildingScreenArgument({@required this.bloc});
}

class NoBuildingScreen extends StatefulWidget {
  final NoBuildingScreenArgument arg;
  const NoBuildingScreen({@required this.arg});

  @override
  NoBuildingScreenState createState() => new NoBuildingScreenState();
}

class NoBuildingScreenState extends State<NoBuildingScreen> {
  OverlayBloc _overlayBloc;
  ProgressHUD _progressToolkit;
  AuthenticationBloc _authenticationBloc;
  @override
  void initState() {
    super.initState();
    _overlayBloc = OverlayBloc();
    _progressToolkit = Progress.instanceCreateWithNormal();
  }

  @override
  Widget build(BuildContext context) {
    final sizeSys = MediaQuery.of(context).size;
    final padding = sizeSys.width * 5 / 100;

    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocProvider(
      create: (BuildContext context) => _overlayBloc,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Stack(
          children: <Widget>[
            MultiBlocListener(
              listeners: [
                BlocListener<OverlayBloc, OverlayBlocState>(
                  cubit: _overlayBloc,
                  listener: (context, overlayState) {
                    if (overlayState is PickBuildingSuccessful) {
                      _progressToolkit.state.dismiss();
                      if (overlayState.buildings.length > 0) {
                        AppRouter.pushReplacementNoParams(
                          context,
                          AppRouter.ROOT,
                        );
                      }
                    }
                  },
                ),
                BlocListener<AuthenticationBloc, AuthenticationState>(
                    listener: (context, authState) {
                  if (authState is AuthenticationUnauthenticated) {
                    AppRouter.pushAndRemoveUntil(
                      context,
                      LoginPage.routeName,
                    );
                  }
                }),
              ],
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 0),
                    shrinkWrap: true,
                    children: <Widget>[
                      const SizedBox(height: 100),
                      SvgPicture.asset('assets/svg/404/ic-empty-building.svg'),
                      const SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.only(
                            left: padding,
                            right: padding,
                            bottom: 20,
                          ),
                          child: Text(
                              LocalizationsUtil.of(context).translate(
                                  "sorry_we_couldn’t_find_your_building_please_contact_your_building's_pm"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: AppFonts.font_family_display,
                                  fontSize: 16.0,
                                  letterSpacing: 0.5,
                                  color: Color(0xff808080),
                                  fontWeight: FontWeight.w500))),
                      const SizedBox(height: 50),
                      Padding(
                        padding: EdgeInsets.only(
                            left: padding, right: padding, bottom: 20),
                        child: ButtonWidget(
                          defaultHintText:
                              LocalizationsUtil.of(context).translate('reload'),
                          isActive: true,
                          callback: () async {
                            _progressToolkit.state.show();
                            await Future.delayed(Duration(seconds: 1));
                            _overlayBloc.add(BuildingPicked());
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: padding, right: padding, bottom: 20),
                        child: Container(
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
                              right: 5.0,
                              left: 5.0,
                            ),
                            child: FlatButton(
                              splashColor: Colors.transparent,
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
                                    Duration(microseconds: 500));
                                _authenticationBloc..add(LoggedOut());
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _progressToolkit
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // _overlayBloc.closeBloc();
    print("NoBuildingScreen dispose!");
    super.dispose();
  }
}
