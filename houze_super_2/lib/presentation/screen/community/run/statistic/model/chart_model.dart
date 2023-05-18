import 'package:equatable/equatable.dart';

class ChartModel extends Equatable {
  ChartModel({
    this.day,
    this.val,
    this.totalDistance,
  });

  final String? day;
  final String? val;
  final double? totalDistance;

  factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
        day: json["day"] == null ? null : json["day"],
        val: json["val"] == null ? null : json["val"],
        totalDistance: json["total_distance"] == null
            ? null
            : json["total_distance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "day": day == null ? null : day,
        "val": val == null ? null : val,
        "total_distance": totalDistance == null ? null : totalDistance,
      };

  double totalDistanceKm() => ((totalDistance ?? 0) / 1000.0);
  int valToMonth() {
    switch (val?.toLowerCase()) {
      case 'jan':
        return 1;

      case 'feb':
        return 2;

      case 'mar':
        return 3;

      case 'apr':
        return 4;

      case 'may':
        return 5;

      case 'jun':
        return 6;

      case 'jul':
        return 7;

      case 'aug':
        return 8;

      case 'sep':
        return 9;

      case 'oct':
        return 10;

      case 'nov':
        return 11;

      default:
        return 12;
    }
  }

  String valToWeekday() {
    switch (val?.toLowerCase()) {
      case 'mon':
        return 'monday';

      case 'tue':
        return 'tuesday';

      case 'wed':
        return 'wednesday';

      case 'thu':
        return 'thursday';

      case 'fri':
        return 'friday';

      case 'sat':
        return 'saturday';

      case 'sun':
        return 'sunday';
    }
    return 'monday';
  }

  @override
  List<Object> get props => [
        this.day!,
        this.val!,
        this.totalDistance!,
      ];

  @override
  String toString() =>
      'AchievementModel { day: $day \t val: $val \t totalDistance: $totalDistance }';
}
