import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'localizations_util.dart';

class DateUtil {
  final ftime = DateFormat('MM/dd/yyyy - HH:mm');

  /// Token manager.
  static String format(String format, String iso) {
    if (iso.isEmpty) return "----";
    return DateFormat(format).format(DateTime.parse(iso).toLocal());
  }

  static String createAtMessage(String? dateString,
      {required BuildContext context}) {
    var now = DateTime.now().toLocal();
    var format = DateFormat(FormatUtils.time);
    var date = DateTime.parse(dateString ?? '').toLocal();
    var differenceDay = now.difference(date);
    if (differenceDay.inDays < 3) {
      var now1 = now.weekday;
      var date1 = date.weekday;
      var difference = (now1 <= 1 ? 8 : now1) - date1;
      if (difference == 0) {
        return LocalizationsUtil.of(context).translate('k_today') +
            ' - ' +
            format.format(date);
      } else if (difference == 1) {
        return LocalizationsUtil.of(context).translate('k_yesterday') +
            ' - ' +
            format.format(date);
      } else {
        return DateFormat(FormatUtils.dateAndTime).format(date);
      }
    } else {
      return DateFormat(FormatUtils.dateAndTime).format(date);
    }
  }

  static String convertLastMessageTime(String dateString,
      {required BuildContext context}) {
    var now = DateTime.now().toLocal();
    var format = DateFormat(FormatUtils.date);
    var date = DateTime.parse(dateString).toLocal();
    var difference = now.difference(date);

    if (difference.inDays >= 1 && difference.inDays < 3) {
      return '${difference.inDays} ' +
          LocalizationsUtil.of(context).translate('k_day');
    } else if (difference.inHours >= 1 && difference.inHours < 24) {
      return difference.inHours.toString() +
          ' ' +
          LocalizationsUtil.of(context).translate('k_hours');
    } else if (difference.inMinutes >= 1 && difference.inMinutes <= 59) {
      return difference.inMinutes.toString() +
          ' ' +
          LocalizationsUtil.of(context).translate('k_minute');
    } else if (difference.inSeconds >= 1 && difference.inSeconds <= 59) {
      return '${difference.inSeconds} ' +
          LocalizationsUtil.of(context).translate('k_seconds');
    } else if (difference.inSeconds == 0) {
      return LocalizationsUtil.of(context).translate('k_one_second');
    } else {
      return format.format(date);
    }
  }
}

class FormatUtils {
  static const String timeAndDate = 'HH:mm - dd/MM/yyyy';
  static const String dateAndTime = 'dd/MM/yyyy - HH:mm';
  static const String time = 'HH:mm';
  static const String date = 'dd/MM/yyyy';
  static const String number = '#,###';
}
