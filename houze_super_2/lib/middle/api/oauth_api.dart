import 'dart:async';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/blocs/authentication/authentication_event.dart';
import 'package:houze_super/app/blocs/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/token_model.dart';
import 'package:houze_super/providers/log_provider.dart';
import 'package:houze_super/utils/index.dart';

import 'package:synchronized/synchronized.dart' as lock;
import 'package:houze_super/middle/api/monitor_log.dart';
import 'error_response.dart';

/* 
About:
- All API class must extend this class (for authenticated request)
- This class also takes care of the refresh token work
 */

class OauthAPI {
  static const String tokenType = "Bearer";
  static Dio? dioInstance;
  static Dio? tokenDioInstance;

  static String? token;
  static bool tokenValid = true;
  static Client client = Client();
  static var monitorLog = MonitorLog(client.init());

  final String? baseUrl;

  static late lock.Lock synchronized;

  OauthAPI(this.baseUrl);
  static LogProvider get logger => const LogProvider('✅ OauthAPI');

  static Future<void> init() async {
    if (OauthAPI.tokenDioInstance == null) {
      OauthAPI.synchronized = lock.Lock();
      OauthAPI.tokenDioInstance = Dio();

      //Refresh token failed
      //A refresh token only refresh 1 times.
      OauthAPI.tokenDioInstance!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options, handler) {
            logger.log('[${options.method}] - ${options.uri}');
            return handler.next(options);
          },
          onResponse: (Response response, handler) {
            return handler.next(response);
          },
          onError: (DioError e, handler) {
            logger.log(e.response.toString());

            return handler.next(e);
          },
        ),
      );
    }

    final refreshAPI = AuthPath.refreshToken;
//    logger.log('API REFRESH ${refreshAPI}');

    if (OauthAPI.dioInstance == null) {
      //First declare
      OauthAPI.dioInstance = Dio();
      OauthAPI.dioInstance!.options.connectTimeout = 7000;
      OauthAPI.dioInstance!.options.receiveTimeout = 15000;

      /// Fix hand shake OS error
      (dioInstance!.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      //handler expire token
      OauthAPI.dioInstance!.interceptors.add(InterceptorsWrapper(
          onRequest: (RequestOptions options, handler) async {
        logger.log(
            "${DateTime.now()} BEGIN REQUEST: ${options.path} with  method: ${options.method}");

        final TokenModel? tokens = Storage.getToken();

        OauthAPI.token = tokens?.access;

        final _language = Storage.getLanguage();

        options.headers["Authorization"] =
            "${OauthAPI.tokenType} ${OauthAPI.token}";
        options.headers["token"] = tokens?.access;
        options.headers["refresh"] = tokens?.refresh;
        options.headers["language"] = _language.locale;
        options.headers["Accept-Language"] = _language.locale;
        // logger.log(Sqflite.currentBuilding);
        final building = Sqflite.currentBuilding;

        if ((building?.isMicro ?? false)) {
          options.headers["api-version"] = 'v2';
        }
        // logger.log(options.headers.toString());

        logger.log("Request with access token: ${options.headers["token"]}");

        return handler.next(options);
      }, onResponse: (Response response, handler) {
        if (response.requestOptions.method == "GET")
          Sqflite.insertResponse(response);
        logger.log(response.toString());
        return handler.next(response);
      }, onError: (DioError e, handler) async {
        if (<DioErrorType>[
          DioErrorType.other,
          DioErrorType.connectTimeout,
          DioErrorType.receiveTimeout,
        ].contains(e.type)) {
          if (e.requestOptions.method == "GET")
            Sqflite.getCachingResponse(e);
          else
            throw e;
        }

        // push message monitorLog
        if (OauthAPI.token != null && e.response?.statusCode != 401) {
          try {
            var data = monitorLog.toJson(
                path: e.requestOptions.path,
                data: e.requestOptions.data,
                headers: e.requestOptions.headers,
                method: e.requestOptions.method,
                status: e.response?.statusCode,
                queryParameters: e.requestOptions.queryParameters,
                reponse: e.response?.data,
                error: e.error);

            monitorLog.post(data);
          } catch (e) {
            logger.log(e.toString());
            throw e;
          }
        }

        if (OauthAPI.token != null && e.response?.statusCode == 401) {
          //expire token
          await OauthAPI.synchronized.synchronized(() {
            OauthAPI.tokenValid = false;
          });

          RequestOptions requestOptions = e.response!.requestOptions;
          Options options = Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
          );

          //If the token has been updated, repeat directly.
          if (OauthAPI.token != options.headers?["token"]) {
            requestOptions.headers["Authorization"] =
                "${OauthAPI.tokenType} ${OauthAPI.token}";
            requestOptions.headers["token"] = OauthAPI.token;
            return handler
                .resolve(await OauthAPI.dioInstance!.fetch(requestOptions));
          }

          logger.log("############################");
          logger.log(
              "statusCode: ${e.response?.statusCode}: refresh token with path: ${e.requestOptions.path} \n and accessToken: ${OauthAPI.token}");
          logger.log("############################");

          //dioLock();
          OauthAPI.dioInstance!.lock();

          return await OauthAPI.synchronized.synchronized(() {
            logger.log(
                '${DateTime.now()} BEGIN synchronized lock ${OauthAPI.tokenValid}');

            TokenModel? tokenModel = Storage.getToken();

            if (OauthAPI.tokenValid) {
              requestOptions.headers["Authorization"] =
                  "${OauthAPI.tokenType} ${OauthAPI.token}";
              requestOptions.headers["token"] = OauthAPI.token;
              return OauthAPI.dioInstance!.fetch(requestOptions);
            }

            final building = Sqflite.currentBuilding;
            var headers = {
              "refresh": tokenModel!.refresh,
            };
            if ((building?.isMicro ?? false)) {
              headers["api-version"] = 'v2';
            }
            return OauthAPI.tokenDioInstance!
                .post(refreshAPI,
                    data: {"refresh": tokenModel.refresh},
                    options: Options(headers: headers))
                .then((d) async {
              logger.log(
                  "* token refresh: ${d.data["refresh"]}, access: ${d.data["access"]} for path: ${e.requestOptions.path}");

              OauthAPI.token = d.data["access"];

              requestOptions.headers["Authorization"] =
                  "${OauthAPI.tokenType} ${OauthAPI.token}";
              requestOptions.headers["token"] = d.data["access"];

              Storage.saveToken(TokenModel(
                  access: d.data["access"], refresh: d.data["refresh"]));
              OauthAPI.tokenValid = true;
            }).whenComplete(() {
              //dioUnlock();
              OauthAPI.dioInstance!.unlock();
            }).catchError((e) async {
              if (e != null &&
                  e.response != null &&
                  e.response.statusCode >= 400) {
                if (Storage.scaffoldKey.currentContext != null) {
                  ScaffoldMessenger.of(Storage.scaffoldKey.currentContext!)
                      .hideCurrentSnackBar();
                  ScaffoldMessenger.of(Storage.scaffoldKey.currentContext!)
                      .showSnackBar(
                    SnackBar(
                      padding: const EdgeInsets.all(20),
                      duration: const Duration(seconds: 5),
                      content: Text(
                        LocalizationsUtil.of(Storage.scaffoldKey.currentContext)
                            .translate("your_session_was_expired"),
                        style: AppFonts.regular15.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                  );

                  BlocProvider.of<AuthenticationBloc>(
                      Storage.scaffoldKey.currentContext!)
                    ..add(LoggedOut());
                }
                return await Future.delayed(
                    Duration(
                      milliseconds: 100,
                    ), () {
                  return e;
                });
              }

              requestOptions.headers["Authorization"] =
                  "${OauthAPI.tokenType} ${OauthAPI.token}";
              requestOptions.headers["token"] = OauthAPI.token;

              final request =
                  await OauthAPI.dioInstance!.request(requestOptions.path,
                      options: Options(
                        method: requestOptions.method,
                        headers: requestOptions.headers,
                      ),
                      data: requestOptions.data,
                      queryParameters: requestOptions.queryParameters);

              handler.resolve(request);
              return await Future.delayed(
                  Duration(
                    milliseconds: 100,
                  ), () {
                return e;
              });
            }).then((ex) async {
              logger.log('then refresh token ..... ${requestOptions.path}');
              try {
                final request =
                    await OauthAPI.dioInstance!.request(requestOptions.path,
                        options: Options(
                          method: requestOptions.method,
                          headers: requestOptions.headers,
                        ),
                        data: requestOptions.data,
                        queryParameters: requestOptions.queryParameters);
                return handler.resolve(request);
              } on DioError catch (error) {
                return handler.next(error); // or handler.reject(error);
              }
            });
          });
        }

        return handler.next(e);
      }));
    }
  }

  // static void dioLock() async {
  //   OauthAPI.dioInstance!.interceptors.requestLock.lock();
  //   OauthAPI.dioInstance!.interceptors.responseLock.lock();
  //   OauthAPI.dioInstance!.interceptors.errorLock.lock();
  // }

  // static void dioUnlock() {
  //   OauthAPI.dioInstance!.interceptors.requestLock.unlock();
  //   OauthAPI.dioInstance!.interceptors.responseLock.unlock();
  //   OauthAPI.dioInstance!.interceptors.errorLock.unlock();
  // }

  Future<Response> get(
    String? path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response;
    try {
      response = dioInstance!.get(
        path ?? "",
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      // {logger.log('Error: $error \t stackTrace: $stackTrace')});

    } on DioError catch (e) {
      logger.log(e.toString());
      throw e.response!;
    }
    if (response is! ErrorResponse) {
      return response;
    }
    throw response;
  }

  Future<Response> post(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response = dioInstance!.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );

    if (response is! ErrorResponse) {
      return response;
    }
    throw response;
  }

  Future<Response> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response = dioInstance!.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );

    if (response is! ErrorResponse) {
      return response;
    }
    throw response;
  }

  Future<Response> patch(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response = dioInstance!.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );

    if (response is! ErrorResponse) {
      return response;
    }
    throw response;
  }

  Future<Response> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = dioInstance!.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    if (response is! ErrorResponse) {
      return response;
    }
    throw response;
  }
}
