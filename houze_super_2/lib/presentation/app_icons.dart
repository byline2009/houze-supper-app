/// To use this font, place it in your fonts/ directory and include the
/// following in your pubspec.yaml
///
/// flutter:
///   fonts:
///    - family:  AppIcons
///      fonts:
///       - asset: fonts/AppIcons.ttf
///

/*
Step 1: drop SVG (remove fill & color) to fluttericon.com
        or import config.json
Step 2: class name: AppIcons -> download
Step 3: app_icons.dart //class generator => don't modify
Step 4: AppIcons.tff //drag a font file containing all your necessary icons
*/

import 'package:flutter/widgets.dart';

class AppIcons {
  AppIcons._();

  static const _kFontFam = 'AppIcons';
  static const String? _kFontPkg = null;

  static const IconData icon_chat =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData icon_run =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData icon_walk =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
