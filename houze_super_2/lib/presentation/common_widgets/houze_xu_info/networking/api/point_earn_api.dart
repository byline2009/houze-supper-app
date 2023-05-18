import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/model/point_earn_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class PointEarnApi extends OauthAPI {
  PointEarnApi() : super(XuPath.getXuEarn);

  Future<PointEarnModel> getXuEarnInfo(String id) async {
    var response;
    try {
      response = await this.get(this.baseUrl! + "$id/");
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
