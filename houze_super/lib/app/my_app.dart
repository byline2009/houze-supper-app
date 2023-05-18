import 'dart:io';

import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:houze_super/app/bloc/authentication/authentication_bloc.dart';
import 'package:houze_super/app/bloc/authentication/authentication_event.dart';
import 'package:houze_super/app/bloc/language/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/repo/user_repository.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/login/bloc/index.dart';
import 'package:houze_super/presentation/screen/login/check_phone/sc_login_by_phone.dart';
import 'package:houze_super/presentation/screen/sc_main.dart';
import 'package:houze_super/utils/cupertino_localizations_vi.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_delegate_util.dart';

import 'bloc/authentication/authentication_state.dart';

Widget buildError(BuildContext context, FlutterErrorDetails error) {
  print('[Error] ${error.exceptionAsString()}');
  return Scaffold(body: SomethingWentWrong());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>().restartApp();
  }

  static Future<void> initSystemDefault() async {
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  static Widget runWidget() {
    return BlocProvider(
      create: (BuildContext context) =>
          AuthenticationBloc(userRepo: UserRepository())
            ..add(
              AppStarted(),
            ),
      child: MyApp(),
    );
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  FirebaseAnalytics analytics = FirebaseAnalytics();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  LoginBloc _loginBloc;
  final countryCode = {
    "en": "US",
    "vi": "VN",
    "zh": "CN",
    "ko": "KR",
    "ja": "JP",
  };
  Locale _locale;
  @override
  void initState() {
    super.initState();

    final String currentLocale = Storage.getLanguage().locale;

    _locale = Locale(currentLocale, countryCode[currentLocale]);
    _loginBloc = LoginBloc(
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ChangeLanguageBloc>(
            create: (BuildContext context) => ChangeLanguageBloc(),
          ),
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => _loginBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ChangeLanguageBloc, ChangeLanguageState>(
                listener: (context, state) {
              if (state.hasData)
                _locale = Locale(
                  state.language.locale,
                  countryCode[state.language.locale],
                );
            }),
          ],
          child: BlocBuilder<ChangeLanguageBloc, ChangeLanguageState>(
            builder: (
              BuildContext context,
              ChangeLanguageState currentState,
            ) {
              return MaterialApp(
                showPerformanceOverlay: false,
                debugShowCheckedModeBanner: false,
                navigatorObservers: [
                  FirebaseAnalyticsObserver(analytics: analytics),
                ],
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  primaryColor: Color(0xff6001d2),
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                  bottomAppBarColor: Color(0xff7A1DFF),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  primaryColorBrightness: Brightness.light,
                  appBarTheme: AppBarTheme(
                      color: Colors.white,
                      brightness: Brightness.light,
                      elevation: 0.0),
                ),
                builder: (BuildContext context, Widget child) {
                  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                    return buildError(context, errorDetails);
                  };
                  final MediaQueryData data = MediaQuery.of(context);
                  return MediaQuery(
                      data: data.copyWith(textScaleFactor: 1.0), child: child);
                },
                locale: _locale,
                supportedLocales: [
                  const Locale('en', 'US'),
                  const Locale('vi', 'VN'),
                  const Locale('zh', 'CN'),
                  const Locale('ko', 'KR'),
                  const Locale('ja', 'JP'),
                ],
                localizationsDelegates: [
                  LocalizationsDelegateUtil(),
                  CupertinoLocalizationsVi.delegate,
                  DefaultCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: Stack(
                  children: [
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      cubit: _loginBloc.authenticationBloc,
                      builder: (context, state) {
                        if (state is AuthenticationAuthenticated &&
                            !state.isLoginEvent) {
                          return Builder(builder: (
                            context,
                          ) {
                            return MainScreen();
                          });
                        }
                        return LoginPage();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
