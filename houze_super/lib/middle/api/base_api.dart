import 'package:dio/dio.dart';
import 'package:houze_super/utils/sqflite.dart';

class BaseApi {
  final String baseUrl;
  Dio dio;
  BaseApi(this.baseUrl) {
    this.dio = new Dio();
    dio.options.baseUrl = this.baseUrl;
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 10000;
    this.dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (RequestOptions options) {
              return options;
            },
            onResponse: (Response response) {
              if (response.request.method == "GET")
                Sqflite.insertResponse(response);

              return response;
            },
            onError: (DioError e) {
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

              return e;
            },
          ),
        );
  }
}
