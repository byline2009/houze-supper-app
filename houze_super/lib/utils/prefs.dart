import 'package:houze_super/utils/constants/share_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<void> setLastDistance(double distance) async {
    final prefs = await _prefs;
    prefs.setDouble(ShareKeys.kLastDistance, distance);
  }

  static Future<double> getLastDistance() async {
    final prefs = await _prefs;
    return prefs.getDouble(ShareKeys.kLastDistance);
  }

  static Future<double> getLastLatitude() async {
    final prefs = await _prefs;

    return prefs.getDouble(ShareKeys.kLastLatitude);
  }

  static Future<void> setLastLatitude(double latitude) async {
    final prefs = await _prefs;

    prefs.setDouble(ShareKeys.kLastLatitude, latitude);
  }

  static Future<double> getLastLongitude() async {
    final prefs = await _prefs;

    return prefs.getDouble(ShareKeys.kLastLongitude);
  }

  static Future<void> setLastLongitude(double longitude) async {
    final prefs = await _prefs;

    prefs.setDouble(ShareKeys.kLastLongitude, longitude);
  }

  static Future<bool> removeLastDistance() async {
    final prefs = await _prefs;
    return prefs.remove(ShareKeys.kLastDistance);
  }

  static Future<bool> removeLastLongitude() async {
    final prefs = await _prefs;
    return prefs.remove(ShareKeys.kLastLongitude);
  }

  static Future<bool> removeLastLatitude() async {
    final prefs = await _prefs;
    return prefs.remove(ShareKeys.kLastLongitude);
  }

  static Future<void> dispose() async {
    await Future.wait([
      removeLastDistance(),
      removeLastLongitude(),
      removeLastLatitude(),
    ]);
  }
}
