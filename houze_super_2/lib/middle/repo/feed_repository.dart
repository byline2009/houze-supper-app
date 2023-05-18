import 'package:houze_super/middle/api/feed_api.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/utils/index.dart';

class FeedRepository {
  final feedAPI = FeedAPI();

  Future<List<FeedMessageModel>> getFeeds(
    int page, {
    String tags = "",
    bool? isRead,
    String type = "",
    String date = "",
    int? ticketStatus,
    int limit = AppConstant.limitDefault,
    String? buildingID,
  }) async {
    try {
      final rs = await feedAPI.getFeeds(
        page,
        tags: tags,
        type: type,
        date: date,
        ticketStatus: ticketStatus,
        limit: limit,
        isRead: isRead,
        buildingID: buildingID,
      );

      return rs;
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
