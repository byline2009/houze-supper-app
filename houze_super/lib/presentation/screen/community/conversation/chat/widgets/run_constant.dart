import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/model/index.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/views/index.dart';

class RunConstant {
  static const String kGroupCreated = '__group_created__';
  static const String kUserJoined = '__user_joined__';
  static const String kChatTypeSystem = 'system';
  static const String kChatTypeImage = 'image';
  static const String kChatTypeText = 'text';
  static const Color participating = Color(0xff6001d2);
  static const Color completed = Color(0xff00aa7d);
  static const Color notCompleted = Color(0xffb5b5b5);

  static final List<MedalItem> medals = [
    MedalItem(
      active: false,
      model: AchievementModel(
        target: 1,
        name: 'k_run_the_first_1km', //'Chạy 1 km đầu tiên',
      ),
    ),
    MedalItem(
      active: false,
      model: AchievementModel(
        target: 10,
        name: 'k_running_10_km', //'Chạy tích luỹ 10 km',
      ),
    ),
    MedalItem(
      active: false,
      model: AchievementModel(
        target: 100,
        name: 'k_running_100_km', // 'Chạy tích luỹ 100 km',
      ),
    ),
    MedalItem(
      active: false,
      model: AchievementModel(
        target: 500,
        name: 'k_running_500_km', // 'Chạy tích luỹ 500 km',
      ),
    ),
    MedalItem(
      active: false,
      model: AchievementModel(
        target: 1000,
        name: 'k_running_1000_km', //'Chạy tích luỹ 1,000 km',
      ),
    ),
    MedalItem(
      active: false,
      model: AchievementModel(
        target: 10000,
        name: 'k_running_10000_km', //'Chạy tích luỹ 10,000 km',
      ),
    ),
  ];
}
