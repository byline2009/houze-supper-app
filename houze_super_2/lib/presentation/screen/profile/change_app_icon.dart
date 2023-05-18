import 'dart:io';
import 'package:flutter/services.dart';

class AppIconIOS {
  static const MethodChannel _platform = MethodChannel('changeAppIcon');

  static Future<void> setLauncherIcon(String iconName) async {
    if (!Platform.isIOS) return null;

    return await _platform.invokeMethod('changeIcon', iconName);
  }
}

class AppIconAndroid {
  static const MethodChannel _platform =
      MethodChannel('flutter.native/channelChangeAppIcon');

  static Future<void> setLauncherIcon(Map name) async {
    if (!Platform.isAndroid) return null;

    return await _platform.invokeMethod('updateIcon', name);
  }
}
