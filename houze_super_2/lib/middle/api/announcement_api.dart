import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/announcement_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class AnnouncementAPI extends OauthAPI {
  AnnouncementAPI() : super(BasePath.citizen);

  Future<AnnouncementModel> getAnnouncement(String id) async {
    final url = this.baseUrl! + 'announcement/' + id + '/';
    try {
      final response = await this.get(url);

      return AnnouncementModel.fromJson(response.data);
    } catch (err) {
      rethrow;
    }
  }
}
