import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/ekyc_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

class EKYCAPI extends OauthAPI {
  EKYCAPI() : super(BasePath.identity);

  Future<EKYCModel> getEKYC() async {
    final response = await this.get(APIConstant.getEKYC);

    return EKYCModel.fromJson(response.data);
  }

  Future<EKYCModel> postEKYC({@required FormData formData}) async {
    try {
      final options =
          Options(sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);

      final response = await this
          .post(APIConstant.postEKYC, data: formData, options: options);

      return EKYCModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response != null && e.response.statusCode != 200)
        throw ("${e.response}");
      else {
        throw ("Lỗi kết nối máy chủ");
      }
    }
  }
}
