import 'package:equatable/equatable.dart';
import 'package:houze_super/utils/index.dart';
import 'index.dart';

class JoinedModel extends Equatable {
  const JoinedModel({
    this.user,
    this.distance,
    this.totalTime,
  });

  final MemberModel user;
  final String distance;
  final String totalTime;

  factory JoinedModel.fromJson(Map<String, dynamic> json) => JoinedModel(
        user: json["user"] != null ? MemberModel.fromJson(json["user"]) : null,
        distance: json["distance"] == null ? null : json["distance"],
        totalTime: json["total_time"] == null ? null : json["total_time"],
      );

  Map<String, dynamic> toJson() => {
        "user": user != null ? user.toJson() : null,
        "distance": distance == null ? null : distance,
        "total_time": totalTime == null ? null : totalTime,
      };

  double get distanceKm => distance.toDouble().kilometers();

  @override
  List<Object> get props => [
        user,
        distance,
        totalTime,
      ];

  @override
  String toString() =>
      'JoinedModel {distance: $distance \t totalTime: $totalTime \t user: ${user.toJson()}}';
}
