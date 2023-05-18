import 'package:equatable/equatable.dart';
import 'package:houze_super/utils/index.dart';

class AchievementModel extends Equatable {
  final String? id;
  final String name;
  final int target;
  AchievementModel({
    this.id,
    required this.name,
    required this.target,
  });

  static AchievementModel fromJson(dynamic json) {
    return AchievementModel(
      id: json['id'],
      name: json['name'],
      target: json['target'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['target'] = this.target;
    return data;
  }

  @override
  List<Object> get props => [id ?? '', name, target];

  @override
  String toString() =>
      'AchievementModel { id: $id \t name: $name \t target: $target}';

  String medalIcon({bool active = false}) {
    switch (this.target) {
      case 1:
        return active ? AppVectors.icMedal1 : AppVectors.icMedal1Disabled;

      case 10:
        return active ? AppVectors.icMedal10 : AppVectors.icMedal10Disabled;

      case 100:
        return active ? AppVectors.icMedal100 : AppVectors.icMedal100Disabled;

      case 500:
        return active ? AppVectors.icMedal500 : AppVectors.icMedal500Disabled;

      case 1000:
        return active ? AppVectors.icMedal1K : AppVectors.icMedal1KDisabled;

      default:
        return active ? AppVectors.icMedal10K : AppVectors.icMedal10KDisabled;
    }
  }
}
