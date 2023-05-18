import 'package:equatable/equatable.dart';

import 'chart_model.dart';

class DistanceDateModel extends Equatable {
  DistanceDateModel({
    this.averageSecond,
    this.averageDistance,
    this.chart,
  });

  final double averageSecond;
  final double averageDistance;
  final List<ChartModel> chart;

  factory DistanceDateModel.fromJson(Map<String, dynamic> json) =>
      DistanceDateModel(
        averageSecond: json["average_second"] == null
            ? null
            : json["average_second"].toDouble(),
        averageDistance: json["average_distance"] == null
            ? null
            : json["average_distance"].toDouble(),
        chart: json["chart"] == null
            ? null
            : List<ChartModel>.from(
                json["chart"].map((x) => ChartModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "average_second": averageSecond == null ? null : averageSecond,
        "average_distance": averageDistance == null ? null : averageDistance,
        "chart": chart == null
            ? null
            : List<ChartModel>.from(chart.map((x) => x.toJson())),
      };
  String averageDistanceKm() => (averageDistance / 1000.0).toStringAsFixed(1);
  String averageHour() => (averageSecond / 3600.0).toStringAsFixed(1);
  @override
  List<Object> get props => [
        this.averageSecond,
        this.averageDistance,
        this.chart,
      ];

  @override
  String toString() =>
      'AchievementModel { averageSecond: $averageSecond \t averageDistance: $averageDistance \t chart: ${chart.toList()}}';
}
