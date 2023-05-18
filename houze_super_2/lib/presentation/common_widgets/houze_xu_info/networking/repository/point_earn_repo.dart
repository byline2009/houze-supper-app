import 'package:houze_super/presentation/common_widgets/houze_xu_info/model/point_earn_model.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/networking/api/point_earn_api.dart';

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
