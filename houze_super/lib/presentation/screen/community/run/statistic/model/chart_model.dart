import 'package:equatable/equatable.dart';

class ChartModel extends Equatable {
  ChartModel({
    this.day,
    this.val,
    this.totalDistance,
  });

  final String day;
  final String val;
  final double totalDistance;

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

  double totalDistanceKm() => (totalDistance / 1000.0);
  int valToMonth() {
    switch (val.toLowerCase()) {
      case 'jan':
        return 1;
        break;
      case 'feb':
        return 2;
        break;
      case 'mar':
        return 3;
        break;
      case 'apr':
        return 4;
        break;
      case 'may':
        return 5;
        break;
      case 'jun':
        return 6;
        break;
      case 'jul':
        return 7;
        break;
      case 'aug':
        return 8;
        break;
      case 'sep':
        return 9;
        break;
      case 'oct':
        return 10;
        break;
      case 'nov':
        return 11;
        break;

      default:
        return 12;
        break;
    }
  }

  String valToWeekday() {
    switch (val.toLowerCase()) {
      case 'mon':
        return 'monday';
        break;
      case 'tue':
        return 'tuesday';
        break;
      case 'wed':
        return 'wednesday';
        break;
      case 'thu':
        return 'thursday';
        break;
      case 'fri':
        return 'friday';
        break;
      case 'sat':
        return 'saturday';
        break;
      case 'sun':
        return 'sunday';
        break;
    }
    return 'monday';
  }

  @override
  List<Object> get props => [
        this.day,
        this.val,
        this.totalDistance,
      ];

  @override
  String toString() =>
      'AchievementModel { day: $day \t val: $val \t totalDistance: $totalDistance }';
}
