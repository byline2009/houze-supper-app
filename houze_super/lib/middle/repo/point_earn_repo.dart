import 'package:houze_super/middle/api/point_earn_api.dart';
import 'package:houze_super/middle/model/houze_point/point_earn_model.dart';

class PointEarnRepository {
  final pointEarnApi = PointEarnApi();

  PointEarnRepository();

  Future<PointEarnModel> getXuEarnInfo(String buildingId) async {
    //Call Dio API
    if (buildingId != '') {
      final rs = await pointEarnApi.getXuEarnInfo(buildingId);

      return rs;
    }
    return PointEarnModel();
  }
}
