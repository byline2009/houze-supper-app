import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/app/blocs/authentication/authentication_bloc.dart';
import 'package:houze_super/app/blocs/authentication/authentication_event.dart';
import 'package:houze_super/app/blocs/language/language_bloc.dart';
import 'package:houze_super/app/blocs/language/language_state.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/widget_something_went_wrong.dart';
import 'package:houze_super/presentation/custom_ui/banner/banner.dart';
import 'package:houze_super/presentation/screen/login/check_phone/sc_login_by_phone.dart';
import 'package:houze_super/presentation/screen/login/index.dart';
import 'package:houze_super/presentation/screen/sc_main.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:houze_super/utils/constant/app_color.dart';
import 'package:houze_super/utils/constant/app_constant.dart';
import 'package:houze_super/utils/cupertino_localizations_vi.dart';
import 'package:houze_super/utils/localizations_delegate_util.dart';

import 'blocs/authentication/authentication_state.dart';

Widget buildError(BuildContext context, FlutterErrorDetails error) {
  print('[Error] ${error.exceptionAsString()}');
  return Scaffold(body: SomethingWentWrong());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver();

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
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
            AuthenticationBloc()..add(AppStarted()),
        child: MyApp());
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  late Locale locale;
  late final LoginBloc loginBloc;
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  // support multiple languages
  final countryCode = {
    "en": "US",
    "vi": "VN",
    "zh": "CN",
    "ko": "KR",
    "ja": "JP",
  };

  @override
  void initState() {
    super.initState();

    final _currentLang = Storage.getLanguage();

    locale = Locale(
      _currentLang.locale!,
      countryCode[_currentLang.locale],
    );

    loginBloc = LoginBloc(
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context));
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
          BlocProvider<LanguageBloc>(
            create: (BuildContext context) => LanguageBloc(),
          ),
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => loginBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<LanguageBloc, LanguageState>(
                listener: (context, state) {
              if (state is LanguagePicked) {
                locale = Locale(
                  state.language.locale!,
                  countryCode[state.language.locale],
                );
              }
            }),
          ],
          child: BlocBuilder<LanguageBloc, LanguageState>(
            builder: (
              BuildContext context,
              LanguageState currentState,
            ) {
              return ScreenUtilInit(
                  designSize: Size(DesignUtil.width, DesignUtil.height),
                  minTextAdapt: true,
                  builder: () {
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      navigatorObservers: [routeObserver],
                      theme: ThemeData(
                        scaffoldBackgroundColor: Colors.white,
                        primaryColor: AppColor.purple_6001d2,
                        bottomAppBarColor: AppColor.purple_7a1dff,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        textTheme: TextTheme(
                          button: TextStyle(
                            fontSize: 45.sp,
                          ),
                        ),
                        appBarTheme: AppBarTheme(
                            color: Colors.white,
                            elevation: 0.0,
                            systemOverlayStyle: SystemUiOverlayStyle.dark),
                      ),
                      builder: (BuildContext context, Widget? child) {
                        ScreenUtil.setContext(context);
                        ErrorWidget.builder =
                            (FlutterErrorDetails errorDetails) {
                          return buildError(context, errorDetails);
                        };
                        return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: HouzeModeBanner(
                              title: const String.fromEnvironment('API_MODE'),
                              child: child!,
                            ));
                      },
                      locale: locale,
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
                        CountryLocalizations.delegate,
                      ],
                      home: Stack(
                        children: [
                          BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            bloc: loginBloc.authenticationBloc,
                            builder: (context, state) {
                              if (state is AuthenticationAuthenticated &&
                                  !state.isLoginEvent) {
                                return MainScreen();
                              }

                              return LoginPhoneScreen();
                            },
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
