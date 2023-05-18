import 'package:equatable/equatable.dart';

class StatisticOverviewModel extends Equatable {
  const StatisticOverviewModel(
      {this.accumulationTime,
      this.distance,
      this.daysRunInYear,
      this.consecutiveDays});

  final dynamic accumulationTime;
  final dynamic distance;
  final int daysRunInYear;
  final int consecutiveDays;

  static StatisticOverviewModel fromJson(dynamic json) {
    return StatisticOverviewModel(
      accumulationTime:
          json["accumulation_time"] == null ? null : json["accumulation_time"],
      distance: json["distance"] == null ? null : json["distance"],
      daysRunInYear:
          json["days_run_in_year"] == null ? null : json["days_run_in_year"],
      consecutiveDays:
          json["consecutive_days"] == null ? null : json["consecutive_days"],
    );
  }

  Map<String, dynamic> toJson() => {
        "accumulation_time": accumulationTime == null ? null : accumulationTime,
        "distance": distance == null ? null : distance,
        "days_run_in_year": daysRunInYear == null ? null : daysRunInYear,
        "consecutive_days": consecutiveDays == null ? null : consecutiveDays,
      };

  @override
  List<Object> get props => [
        accumulationTime,
        distance,
        daysRunInYear,
        consecutiveDays,
      ];

  @override
  String toString() =>
      'StatisticOverviewModel { accumulationTime: $accumulationTime \t distance: $distance  \t consecutiveDays: $consecutiveDays}';
}
