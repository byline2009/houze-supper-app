import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/base_api.dart';
import 'package:houze_super/middle/model/login/verify_otp_model.dart';
import 'package:houze_super/middle/model/token_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class LoginAPI extends BaseApi {
  Dio? dio;

  LoginAPI() : super(BasePath.identity);

  Future<TokenModel> login(
      {String? phoneDial,
      required String phone,
      required String password}) async {
    try {
      final response = await dio!.post(
        AuthPath.signIn,
        data: {
          "intl_code": phoneDial,
          "phone_number": phone,
          "password": password
        },
      );
      return TokenModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode != 200)
        throw ("Sai tài khoản hoặc mật khẩu");
      else {
        throw ("Lỗi kết nối máy chủ");
      }
    }
  }

  Future<bool> generateOtp({
    required String phone,
    required String phoneDial,
  }) async {
    try {
      final response = await dio!.post(
        OTPPath.generateOtp,
        data: {
          "intl_code": phoneDial,
          "phone_number": phone,
        },
      );
      return response.statusCode == 200;
    } on DioError catch (e) {
      debugPrint("${e.error.toString()}");
    }
    return false;
  }

  Future<VerifyOTPModel> verityOtp({
    required String phone,
    required String phoneDial,
    required String otpToken,
  }) async {
    try {
      final response = await dio!.post(
        OTPPath.verifyOtp,
        data: {
          "intl_code": phoneDial,
          "phone_number": phone,
          "otp_token": otpToken
        },
      );
      return response.statusCode!=200? throw('verityOtp failure'): VerifyOTPModel.fromJson(response.data);
    } on DioError catch (e) {
      debugPrint("${e.error.toString()}");
      rethrow;
    }
  }
}
