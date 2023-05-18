import 'package:equatable/equatable.dart';

import 'achivement_model.dart';

class AchievementUserModel extends Equatable {
  final String? id;
  final AchievementModel? achievement;
  AchievementUserModel({
    this.id,
    this.achievement,
  });

  static AchievementUserModel fromJson(dynamic json) {
    return AchievementUserModel(
      id: json['id'],
      achievement: json['achievement'] != null
          ? AchievementModel.fromJson(json['achievement'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.achievement != null) {
      data['achievement'] = this.achievement?.toJson();
    }
    return data;
  }

  @override
  List<Object> get props => [];

  @override
  String toString() => 'AchievementUserModel { id: $id }';
}
