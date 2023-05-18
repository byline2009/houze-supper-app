import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/auth/check_phone_model.dart';
import 'package:houze_super/middle/model/login/verify_otp_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

class AuthApi extends OauthAPI {
  AuthApi() : super('');

  Future<CheckPhoneModel> checkPhoneNumber(
      {String phoneDial, String phone}) async {
    try {
      final response = await Dio().post(AuthPath.checkPhoneNumber, data: {
        "intl_code": phoneDial,
        "phone_number": phone,
      });

      return CheckPhoneModel.fromJson(response.data);
    } catch (e) {
      print(e.toString());

      throw e;
    }
  }

  Future<bool> resetPasswordV2(
      {String password, VerifyOTPModel otpModel}) async {
    print(
        '------->setPasswordV2: \n- ${otpModel.phoneNumber} \n- ${otpModel.accessToken} \n- $password');
    try {
      final response = await Dio().post(
        OTPPath.setPasswordV2,
        data: {
          "intl_code": otpModel.intlCode,
          "phone_number": otpModel.phoneNumber,
          "password": password,
          "token": otpModel.accessToken,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<bool> resetPassword({String password, VerifyOTPModel otpModel}) async {
    //timeout date
    final response = await Dio().post(
      AuthPath.setPassword,
      data: {
        "intl_code": otpModel.intlCode,
        "phone_number": otpModel.phoneNumber,
        "password": password,
        "token": otpModel.accessToken,
      },
    );
    print(
        '------->resetPassword:  ${otpModel.intlCode} \n- ${otpModel.phoneNumber} \n- ${otpModel.accessToken} \n- $password');
    return response.statusCode == 200;
  }
}
