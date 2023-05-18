import 'dart:math';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/fee/fee_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:intl/intl.dart';

extension DoubleExtension on double {
  double kilometers() => this / 1000.0;
  double hour() => this / 3600.0;

  double decimalPoint(int places) {
    double mod = pow(10.0, places);
    return ((this * mod).round().toDouble() / mod);
  }
}

extension StringExtension on String {
  int toInt() {
    return int.tryParse(this) != null ? int.tryParse(this) : 0;
  }

  double toDouble() {
    final value = double.tryParse(this) != null ? double.tryParse(this) : 0.0;

    return value;
  }

  num toNumber() {
    return num.tryParse(this);
  }
}

class StringUtil {
  static String kilometerDisplay(double meter) {
    return meter.kilometers().toStringAsFixed(2);
  }

  static String hourDisplay(double second) {
    return second.hour().toStringAsFixed(2);
  }

  static String removeLastCharacter(String str, {int total = 0}) {
    String result = str;
    if ((str != null) && (str.length > 0 && str.length > 6)) {
      result = str.substring(0, str.length - total);
    }
    return result;
  }

  /// Check string is empty
  static bool isEmpty(String value) {
    /// In the case value is null
    if (value == null) {
      return true;
    }

    /// In the case value is empty
    if (value.isEmpty || value.trim().isEmpty || value.length == 0) {
      return true;
    }
    return false;
  }

  static String numberFormat(dynamic number) {
    final formatter = NumberFormat("#,###");

    if (number is String) {
      return formatter.format(double.parse(number));
    }
    if (number is double) {
      return formatter.format(number);
    }

    return formatter.format(number);
  }

  static String getWeekDay(int weekday) {
    switch (weekday) {
      case 0:
        return 'monday';
      case 1:
        return 'tuesday';
      case 2:
        return 'wednesday';
      case 3:
        return 'thursday';
      case 4:
        return 'friday';
      case 5:
        return 'saturday';
      case 6:
        return 'sunday';
      default:
        return 'everyday';
    }
  }

  static String formatDays(BuildContext context, List<int> days) {
    if (days.length == 7)
      return LocalizationsUtil.of(context).translate("everyday");

    return days.map((f) {
      return LocalizationsUtil.of(context).translate(getWeekDay(f));
    }).join(" ");
  }

  static String formatWeekDay(BuildContext context, int weekday) {
    return LocalizationsUtil.of(context).translate(
      StringUtil.getWeekDay(weekday),
    );
  }

  static String feesTotal(List<Fees> fees, {@required List<int> allowFee}) {
    Decimal totalFee = Decimal.parse('0');
    fees.forEach((element) {
      if (allowFee.indexOf(element.type) > -1) {
        totalFee += Decimal.parse(element?.totalFee);
      }
    });
    return numberFormat(totalFee.toDouble());
  }

  static String getMonthStr(int month) {
    switch (month) {
      case 1:
        return 'january';
      case 2:
        return 'february';
      case 3:
        return 'march';
      case 4:
        return 'april';
      case 5:
        return 'may';
      case 6:
        return 'june';
      case 7:
        return 'july';
      case 8:
        return 'august';
      case 9:
        return 'september';
      case 10:
        return 'october';
      case 11:
        return 'november';
      case 12:
        return 'december';
      default:
        return null;
    }
  }
}
