import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/app/my_app.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';
import 'package:houze_super/utils/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_manager/worker_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/blocs/app_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MyApp.initSystemDefault();

  // Environment variable
  // AppStrings.envProd ==> Production
  // AppStrings.envDev ==> Development
  await dotenv.load(
      fileName: const String.fromEnvironment('API_MODE') == "dev"
          ? AppStrings.envDev
          : AppStrings.envProd);
  //API init
  BasePath.init();
  Toolset.init();
  AuthPath.init();

  //local storage
  await Sqflite.init();
  await Storage.init();

  //Authentication
  await OauthAPI.init();

  // isolate library
  await Executor().warmUp();

  Storage.prefs = await SharedPreferences.getInstance();
  // Firebase Analytics
  GetIt.instance.registerLazySingleton(() => FBAnalytics());

  BlocOverrides.runZoned(
    () => runApp(MyApp.runWidget()),
    blocObserver: AppBlocObserver(),
  );
}
