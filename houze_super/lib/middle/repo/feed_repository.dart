import 'dart:convert';

import 'package:houze_super/middle/api/feed_api.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/utils/index.dart';

class FeedRepository {
  final feedAPI = FeedAPI();

  Future<List<FeedMessageModel>> getFeeds(
    int page, {
    String tags = "",
    String isRead = "",
    String type = "",
    String date = "",
    int ticketStatus,
    int limit = AppConstant.limitDefault,
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
      );

      return rs;
    } catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        final List<FeedMessageModel> result = (data['feed_json'] as List)
            .map((e) => FeedMessageModel.fromJson(e))
            .toList();

        return result;
      } else
        rethrow;
    }
  }
}
