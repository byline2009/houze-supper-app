import 'package:houze_super/middle/api/building_api.dart';
import 'package:houze_super/middle/model/building_model.dart';

class BuildingRepository {
  final api = BuildingAPI();

  Future<List<BuildingMessageModel>> getBuildings({int page = 1}) async {
    //Call Dio API
    final rs = await api.getBuildings(page: page);
    return rs;
  }
}
