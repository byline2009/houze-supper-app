class HouzeLocation {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
  final double? speed;
  final double? speedAccuracy;
  final double? heading;
  final double? time;
  final bool? isMocked;

  HouzeLocation({
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.accuracy,
    this.altitude,
    this.speed,
    this.speedAccuracy,
    this.heading,
    this.time,
    this.isMocked,
  });
}

class HouzeRoute {
  final List<HouzeLocation>? locations;
  final double distance;
  final double averageSpeed;

  HouzeRoute({
    this.locations,
    this.distance: 0.0,
    this.averageSpeed: 0.0,
  });
}
