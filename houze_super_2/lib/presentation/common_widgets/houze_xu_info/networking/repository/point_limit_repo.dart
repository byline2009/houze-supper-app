import 'package:houze_super/presentation/common_widgets/houze_xu_info/model/point_limit_model.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/networking/api/point_limit_api.dart';

class PointLimitRepository {
  final pointEarnApi = PointLimitApi();

  PointLimitRepository();

  Future<List<PointLimitModel>> getXuEarnInfo() async {
    //Call Dio API
    final rs = await pointEarnApi.getXuLimit();
    return rs;
  }
}
