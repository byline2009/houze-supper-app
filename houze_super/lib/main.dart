import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/app/my_app.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/sqflite.dart';

import 'common/blocs/chatty_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    MyApp.initSystemDefault(),
    Sqflite.init(),
    DotEnv().load(AppStrings.envDev,
    ),
  ]);

  //API init
  Toolset.init();
  BasePath.init();
  AuthPath.init();

  await Future.wait([
    OauthAPI.init(),
    Storage.init(),
  ]);
  Bloc.observer = ChattyBlocObserver();

  // New Firebase Analytics
  GetIt.instance.registerLazySingleton(() => FBAnalytics());

  //This point is recommended to those devices with more than 60HZ input frequency rate.
  GestureBinding.instance.resamplingEnabled = true;
  runApp(MyApp.runWidget());
}
