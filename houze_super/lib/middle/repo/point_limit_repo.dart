import 'package:houze_super/middle/api/point_limit_api.dart';
import 'package:houze_super/middle/model/houze_point/point_limit_model.dart';

class PointLimitRepository {
  final pointEarnApi = PointLimitApi();

  PointLimitRepository();

  Future<List<PointLimitModel>> getXuEarnInfo() async {
    //Call Dio API
    final rs = await pointEarnApi.getXuLimit();

    return rs;
  }
}
