class ActivityModel {
  ActivityModel({
    this.id,
    this.name,
    this.type,
  });

  final String? id;
  final String? name;
  final int? type;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id: json["id"],
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
      };
}

class ActivityUpdate {
  ActivityUpdate({
    this.secondRunning,
    this.distance,
    this.startAt,
    this.createAt,
  });

  final int? secondRunning;
  final double? distance;
  final DateTime? startAt;
  final DateTime? createAt;

  factory ActivityUpdate.fromJson(Map<String, dynamic> json) => ActivityUpdate(
        secondRunning: json["second_running"],
        distance: json["distance"].toDouble(),
        startAt: DateTime.parse(json["start_at"]),
        createAt: DateTime.parse(json["create_at"]),
      );

  Map<String, dynamic> toJson() => {
        "second_running": secondRunning,
        "distance": distance,
        "start_at": startAt!.toIso8601String(),
        "create_at": createAt!.toIso8601String(),
      };
}
