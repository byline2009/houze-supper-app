import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class BuildingAPI extends OauthAPI {
  BuildingAPI() : super(PropertyPath.getBuildings);

  Future<List<BuildingMessageModel>> getBuildings({int page = 0}) async {
    try {
      final response = await this.get(this.baseUrl);
      return (response.data['citizen_json'] as List).map((i) {
        return BuildingMessageModel.fromJson(i);
      }).toList();
    } catch (e) {
      print("Get building không thành công. ${e.toString()}");
      rethrow;
    }
  }
}
