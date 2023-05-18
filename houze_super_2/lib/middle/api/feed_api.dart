import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/model/token_model.dart';
import 'package:houze_super/utils/constant/index.dart';

import 'package:houze_super/utils/sqflite.dart';
import 'package:jose/jose.dart';

class FeedAPI extends OauthAPI {
  FeedAPI() : super(FeedPath.getNotifications);

  Future<List<FeedMessageModel>> getFeeds(
    int page, {
    String? tags,
    String? type,
    String? date,
    int? limit,
    int? ticketStatus,
    bool? isRead,
    String? buildingID,
  }) async {
    final TokenModel? token = Storage.getToken();
    final jwt = new JsonWebToken.unverified(token?.access ?? '');
    final json = jwt.claims.toJson();
    final buildingId = buildingID ?? Sqflite.currentBuildingID;
    final offset = page * (limit ?? 10);

    final response = await this.get(
      this.baseUrl,
      queryParameters: {
        "app_id": APIConstant.app_feed_id,
        "user_id": json["user_id"],
        "limit": limit,
        "offset": offset,
        'ticket_status': ticketStatus,
        "tags": tags,
        "type": type,
        "date": date,
        "building_id": buildingId,
        "is_read": isRead ?? null
      },
    );

    print({
      "app_id": APIConstant.app_feed_id,
      "user_id": json["user_id"],
      "limit": limit ?? 10,
      "offset": offset,
      'ticket_status': ticketStatus,
      "tags": tags,
      "type": type,
      "date": date,
      "building_id": buildingId,
      "is_read": isRead
    });

    if (response.statusCode == 200) {
      return (response.data['feed_json'] as List).map((i) {
        return FeedMessageModel.fromJson(i);
      }).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load feed');
    }
  }

  Future<List<FeedMessageModel>> fetchFeeds({
    String? type,
    String? date,
    int offset = 0,
  }) async {
    final TokenModel? token = Storage.getToken();
    final jwt = new JsonWebToken.unverified(token?.access ?? '');
    final json = jwt.claims.toJson();
    final buildingId = Sqflite.currentBuildingID;

    final response = await this.get(
      this.baseUrl,
      queryParameters: {
        "app_id": APIConstant.app_feed_id,
        "user_id": json["user_id"],
        "offset": offset,
        'ticket_status': '',
        "tags": '',
        "type": type,
        "date": date,
        "building_id": buildingId,
        "is_read": false
      },
    );

    if (response.statusCode == 200) {
      return (response.data['feed_json'] as List).map((i) {
        return FeedMessageModel.fromJson(i);
      }).toList();
    } else {
      throw Exception('Failed to load feed');
    }
  }

  Future<PlayerModel> registerDeviceToken(TokenModel token) async {
    try {
      var jwt = new JsonWebToken.unverified(token.access);
      var json = jwt.claims.toJson();
      String? deviceToken = await Storage.getDeviceToken();

      //print({"app_id": APIConstant.app_feed_id, "device_type": DEVICE_TYPE, "identifier": device_token, "external_user_id": json["user_id"]});

      if (deviceToken.isNotEmpty == true) {
        final response = await this.post(
          BasePath.feed + "v1/players",
          data: {
            "app_id": APIConstant.app_feed_id,
            "device_type": AppConstant.DEVICE_TYPE,
            "identifier": deviceToken,
            "external_user_id": json["user_id"]
          },
        );

        print("Đăng ký token thành công.");

        return response.statusCode == 200
            ? PlayerModel.fromJson(response.data)
            : throw Exception('Failed to load fee');
      } else {
        throw Exception("Đăng ký token không thành công. deviceToken is null");
      }
    } catch (e) {
      print("Đăng ký token không thành công. e: ${e.toString()}");
      rethrow;
    }
  }

  Future<bool> unRegisterDeviceToken() async {
    String? deviceToken = await Storage.getDeviceToken();

    if (deviceToken.isNotEmpty == true) {
      try {
        await this.delete(
          BasePath.feed + "v1/players/$deviceToken",
        );
        print("------------> Xóa device token thành công.");
        return true;
      } catch (e) {
        print(
            "------------> Xóa device token thất bại. error: ${e.toString()}");
      }
    }
    return false;
  }

  Future<bool> readFeed({String id = "", String userID = ""}) async {
    try {
      String url = FeedPath.feedRead + id;
      final response = await this.get(url);
      TokenModel? token = Storage.getToken();
      var jwt = new JsonWebToken.unverified(token?.access ?? '');
      var json = jwt.claims.toJson();

      this.get("${APIConstant.baseFeedUrlFeedBadge}", queryParameters: {
        "app_id": APIConstant.app_feed_id,
        "user_id": json["user_id"],
      }).then((ex) {
        FlutterAppBadger.updateBadgeCount(ex.data["count"]);
      });

      return response.data['message'] == 'ok';
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
