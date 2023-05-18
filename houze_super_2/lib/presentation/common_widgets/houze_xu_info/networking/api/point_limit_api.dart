import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/model/point_limit_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class PointLimitApi extends OauthAPI {
  PointLimitApi() : super(XuPath.getXuLimit);

  Future<List<PointLimitModel>> getXuLimit() async {
    var response;
    try {
      response = await this.get(this.baseUrl);

      if (response != null) {
        return (response.data['citizen_json'] as List).map((i) {
          return PointLimitModel.fromJson(i);
        }).toList();
      }
      return <PointLimitModel>[];
    } on DioError catch (e) {
      print(e.toString());
      throw ("Dữ liệu không hợp lệ");
    }
  }
}
