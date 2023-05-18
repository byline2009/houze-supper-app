import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/achievement_api.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/model/achievement_user_model.dart';

class AchievementRepository {
  AchievementRepository();

  final groupAPI = AchievementApi();

  Future<List<AchievementUserModel>> getAllAchievementUser({
    @required int page,
  }) async {
    final result = await groupAPI.getAllAchieventUser(page: page);

    if (result != null) {
      return (result.results as List).map((i) {
        return AchievementUserModel.fromJson(i);
      }).toList();
    }
    return null;
  }
}
