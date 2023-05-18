import 'dart:convert';

import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/announcement_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

class AnnouncementAPI extends OauthAPI {
  AnnouncementAPI() : super(BasePath.citizen);

  Future<AnnouncementModel> getAnnouncement(String id) async {
    final url = this.baseUrl + 'announcement/' + id + '/';
    try {
      final response = await this.get(url);

      return AnnouncementModel.fromJson(response.data);
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return AnnouncementModel.fromJson(data);
      } else
        rethrow;
    }
  }
}
