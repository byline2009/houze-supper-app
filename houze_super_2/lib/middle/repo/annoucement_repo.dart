import 'package:houze_super/middle/api/announcement_api.dart';

class AnnouncementRepository {
  final api = AnnouncementAPI();

  AnnouncementRepository() {
    print('AnnouncementRepository init');
  }

  Future<dynamic> getAnnouncement(String id) async {
    final rs = await api.getAnnouncement(id);
    return rs;
  }
}
