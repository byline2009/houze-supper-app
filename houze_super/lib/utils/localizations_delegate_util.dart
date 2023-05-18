import 'dart:async';

import 'localizations_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class LocalizationsDelegateUtil
    extends LocalizationsDelegate<LocalizationsUtil> {
  const LocalizationsDelegateUtil();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'vi', 'zh', 'ko', 'ja'].contains(locale.languageCode);

  @override
  Future<LocalizationsUtil> load(Locale locale) {
    return SynchronousFuture<LocalizationsUtil>(LocalizationsUtil(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<LocalizationsUtil> old) => false;
}
