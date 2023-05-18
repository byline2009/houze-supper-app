import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/blocs/statistic_chart_event.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/chart_model.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:intl/intl.dart';

DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

class BottomTimer extends StatelessWidget {
  final TypeDistanceDate type;
  final List<ChartModel> charts;
  const BottomTimer({
    @required this.type,
    @required this.charts,
  });

  @override
  Widget build(BuildContext context) {
    String result = '';
    if (type == TypeDistanceDate.days7) result = findFirstEndDateInAWeek();
    if (type == TypeDistanceDate.weeks12) result = findFirstEndDateIn12Weeks();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 20.0,
        child: Text(
          result,
          style: AppFonts.medium14.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String findFirstEndDateIn12Weeks() {
    String to = DateFormat('dd.MM').format(DateTime.parse(charts.last.day));
    String from = DateFormat('dd.MM').format(DateTime.parse(charts.first.day));
    return from + ' - ' + to;
  }

  String findFirstEndDateInAWeek() {
    final date = DateTime.now();

    DateTime end = getDate(date.add(Duration(days: 7 - date.weekday)));
    DateTime start = getDate(date.subtract(Duration(days: date.weekday - 1)));
    String to = DateFormat('dd.MM').format(end);
    String from = DateFormat('dd.MM').format(start);
    return from + ' - ' + to;
  }
}
