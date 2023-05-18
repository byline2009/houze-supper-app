import 'dart:async';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/bloc/authentication/authentication_bloc.dart';
import 'package:houze_super/app/bloc/authentication/authentication_event.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/token_model.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/sqflite.dart';
import 'package:houze_super/utils/toast.dart';
import 'package:synchronized/synchronized.dart' as lock;

class OauthAPI {
  static String tokenType = "Bearer";
  static Dio dioInstance;
  static Dio tokenDioInstance;

  static String token;
  static bool tokenValid = true;
  static String refreshToken;

  final String baseUrl;

  String refreshAPI;
  BaseOptions options;
  static lock.Lock synchronized;

  OauthAPI(this.baseUrl);

  static Future<void> init() async {
    if (OauthAPI.tokenDioInstance == null) {
      OauthAPI.synchronized = new lock.Lock();
      OauthAPI.tokenDioInstance = new Dio();

      //Refresh token failed
      //A refresh token only refresh 1 times.
      OauthAPI.tokenDioInstance.interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options) async {
            print('API Request $token');
            return options;
          },
          onResponse: (Response response) {
            return response;
          },
          onError: (DioError e) {}));
    }

    final refreshAPI = AuthPath.refreshToken;
//    print('API REFRESH ${refreshAPI}');

    if (OauthAPI.dioInstance == null) {
      //First declare
      OauthAPI.dioInstance = new Dio();
      OauthAPI.dioInstance.options.connectTimeout = 7000;
      OauthAPI.dioInstance.options.receiveTimeout = 15000;

      /// TODO: Fix hand shake OS error
      (dioInstance.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      //handler expire token
      OauthAPI.dioInstance.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
        print(
            "${DateTime.now()} BEGIN REQUEST: ${options.path} with  method: ${options.method}");
        final TokenModel tokens = Storage.getToken();

        OauthAPI.token = tokens?.access;

        final _language = Storage.getLanguage();

        options.headers["Authorization"] =
            "${OauthAPI.tokenType} ${OauthAPI.token}";
        options.headers["token"] = tokens?.access;
        options.headers["refresh"] = tokens?.refresh;
        options.headers["language"] = _language.locale;
        options.headers["Accept-Language"] = _language.locale;

        final building = Sqflite.currentBuilding;

        if (building != null && (building.isMicro ?? false)) {
          options.headers["api-version"] = 'v2';
        }
        print(options.headers.toString());

        print("Request with access token: ${options.headers["token"]}");

        return options;
      }, onResponse: (Response response) {
        if (response.request.method == "GET") Sqflite.insertResponse(response);

        return response;
      }, onError: (DioError e) async {
        print(
            '-------************[onError][url]: ${e.request.path} \n data: ${e.response.data}]');

        if (<DioErrorType>[
          DioErrorType.DEFAULT,
          DioErrorType.CONNECT_TIMEOUT,
          DioErrorType.RECEIVE_TIMEOUT,
        ].contains(e.type)) {
          if (e.request.method == "GET")
            return Sqflite.getCachingResponse(e);
          else
            throw e;
        }

        if (OauthAPI.token != null && e.response?.statusCode == 401) {
          //expire token
          await OauthAPI.synchronized.synchronized(() {
            OauthAPI.tokenValid = false;
          });

          RequestOptions options = e.response.request;

          //If the token has been updated, repeat directly.
          if (OauthAPI.token != options.headers["token"]) {
            options.headers["Authorization"] =
                "${OauthAPI.tokenType} ${OauthAPI.token}";
            options.headers["token"] = OauthAPI.token;
            return OauthAPI.dioInstance.request(options.path, options: options);
          }

          print("############################");
          print(
              "* ${e.response?.statusCode}: refresh token with path: ${e.request.path} and accessToken: ${OauthAPI.token}");
          print("############################");

          dioLock();

          return await OauthAPI.synchronized.synchronized(() {
            print(
                '${DateTime.now()} BEGIN synchronized lock ${OauthAPI.tokenValid}');

            TokenModel tokenModel = Storage.getToken();

            if (OauthAPI.tokenValid == true) {
              options.headers["Authorization"] =
                  "${OauthAPI.tokenType} ${OauthAPI.token}";
              options.headers["token"] = OauthAPI.token;
              return OauthAPI.dioInstance
                  .request(options.path, options: options);
            }
            print(refreshAPI);

            final building = Sqflite.currentBuilding;
            var headers = {
              "refresh": tokenModel.refresh,
            };
            if (building != null && (building.isMicro ?? false)) {
              headers["api-version"] = 'v2';
            }
            return OauthAPI.tokenDioInstance
                .post(refreshAPI,
                    data: {"refresh": tokenModel.refresh},
                    options: Options(headers: headers))
                .then((d) async {
              print(
                  "* New token refresh: ${d.data["refresh"]}, access: ${d.data["access"]} for path: ${e.request.path}");

              OauthAPI.token = d.data["access"];

              options.headers["Authorization"] =
                  "${OauthAPI.tokenType} ${OauthAPI.token}";
              options.headers["token"] = d.data["access"];

              Storage.saveToken(TokenModel(
                  access: d.data["access"], refresh: d.data["refresh"]));
              OauthAPI.tokenValid = true;
            }).whenComplete(() {
              dioUnlock();
            }).catchError((e) {
              if (e != null &&
                  e.response != null &&
                  e.response.statusCode >= 400) {
                ToastUtil.show(
                  ToastDecorator(
                    widget: Text(
                        LocalizationsUtil.of(Storage.scaffoldKey.currentContext)
                            .translate("your_session_was_expired"),
                        style: AppFonts.medium16.copyWith(color: Colors.white)),
                    backgroundColor: Colors.redAccent,
                    borderRadius: BorderRadius.circular(5),
                    padding:const EdgeInsets.all(20),
                  ),
                  Storage.scaffoldKey.currentContext,
                  gravity: ToastPosition.center,
                  duration: 5,
                );

                BlocProvider.of<AuthenticationBloc>(
                    Storage.scaffoldKey.currentContext)
                  ..add(LoggedOut());

                return e;
              }

              options.headers["Authorization"] =
                  "${OauthAPI.tokenType} ${OauthAPI.token}";
              options.headers["token"] = OauthAPI.token;
              return OauthAPI.dioInstance
                  .request(options.path, options: options);
            }).then((ex) {
              print('then refresh token ..... ${options.path}');
              return OauthAPI.dioInstance
                  .request(options.path, options: options);
            });
          });
        }

        return e;
      }));
    }
  }

  static void dioLock() {
    OauthAPI.dioInstance.interceptors.requestLock.lock();
    OauthAPI.dioInstance.interceptors.responseLock.lock();
  }

  static void dioUnlock() {
    OauthAPI.dioInstance.interceptors.requestLock.unlock();
    OauthAPI.dioInstance.interceptors.responseLock.unlock();
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    var response = dioInstance.get(
      path,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );

    return response;
  }

  Future<dynamic> post(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    var response = dioInstance.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );

    return response;
  }

  Future<dynamic> put(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    var response = dioInstance.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );

    return response;
  }

  Future<dynamic> patch(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    var response = dioInstance.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );

    return response;
  }

  Future<dynamic> delete(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  }) async {
    var response = dioInstance.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    return response;
  }
}
