import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<void> setLastDistance(double distance) async {
    final prefs = await _prefs;

    prefs.setDouble('last_distance', distance);
  }

  static Future<double?> getLastDistance() async {
    final prefs = await _prefs;

    return prefs.getDouble('last_distance');
  }

  static Future<double?> getLastLatitude() async {
    final prefs = await _prefs;

    return prefs.getDouble('lat_latitude');
  }

  static Future<void> setLastLatitude(double latitude) async {
    final prefs = await _prefs;

    prefs.setDouble('lat_latitude', latitude);
  }

  static Future<double?> getLastLongitude() async {
    final prefs = await _prefs;

    return prefs.getDouble('lat_longitude');
  }

  static Future<void> setLastLongitude(double longitude) async {
    final prefs = await _prefs;

    prefs.setDouble('lat_longitude', longitude);
  }
}
