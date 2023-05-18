import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/utils/constant/index.dart';

import 'oauth_api.dart';

class AchievementApi extends OauthAPI {
  AchievementApi() : super(RunPath.getAllAchievementUser);

  Future<PageModel> getAllAchieventUser({
    required int page,
  }) async {
    try {
      Map<String, dynamic> query = {
        "limit": AppConstant.limitDefault,
        "offset": page * AppConstant.limitDefault
      };
      final response = await this.get(this.baseUrl, queryParameters: query);
      return PageModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);
        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }
}
