import 'package:dio/dio.dart';

import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/middle/model/houze_point/point_earn_model.dart';

class PointEarnApi extends OauthAPI {
  PointEarnApi() : super(XuPath.getXuEarn);

  Future<PointEarnModel> getXuEarnInfo(String id) async {
    var response;
    try {
      response = await this.get(this.baseUrl + "$id/");
      if (response != null) {
        return PointEarnModel.fromJson(response.data);
      }
      return PointEarnModel();
    } on DioError catch (e) {
      print(e.toString());
      throw ("Dữ liệu không hợp lệ");
    }
  }
}
