import 'dart:math' as math;

import 'package:background_locator/location_dto.dart';

double getDistance(LocationDto a, LocationDto b) {
  final double r = 6378.137;
  final double dLat = (b.latitude - a.latitude) * (math.pi / 180);
  final double dLng = (b.longitude - a.longitude) * (math.pi / 180);
  final double latAToRad = a.latitude * (math.pi / 180);
  final double latBToRad = b.latitude * (math.pi / 180);
  final double z = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(latAToRad) *
          math.cos(latBToRad) *
          math.sin(dLng / 2) *
          math.sin(dLng / 2);
  final double c = 2 * math.atan2(math.sqrt(z), math.sqrt(1 - z));
  final double d = r * c;
  print(d.toString());
  // final double rs = math.sqrt(d * d + math.pow((b.altitude - a.altitude), 2));
  // print(rs.toString());
  return d;
}
