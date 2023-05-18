// import 'dart:async';

//
// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
// import 'package:houze_super/utils/index.dart';

// import 'base_chart.dart';
// import 'health_manager.dart';

// class StepChart extends StatefulWidget {
//   const StepChart();

//   @override
//   _StepChartState createState() => _StepChartState();
// }

// class _StepChartState extends State<StepChart> {
//   Future<List<ChartData>> fetchDataThisWeek() async {
//     List<String> keyList = DateUtil.getDaysOfWeek();

//     List<ChartData> data = [];
//     DateTime today = DateTime.now();
//     DateTime first = DateUtil.findFirstDateOfTheWeek(today);
//     int _key = 0;

//     do {
//       List<HealthDataPoint> rs = await FlutterHealthManager.singleton
//           .getHealthData(
//               start: DateTime(first.year, first.month, first.day, 0, 0, 0),
//               end: DateTime(first.year, first.month, first.day, 23, 59, 59));
//       int step = FlutterHealthManager.singleton.getStepCount(rs: rs);

//       var _data = ChartData(
//           keyList[_key].toLowerCase(), step.toDouble(), WorkoutUnit.step);
//       data.add(_data);

//       first = first.add(Duration(days: 1));
//       _key++;
//     } while (data.length < 7);
//     return data;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: fetchDataThisWeek(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData &&
//               (snapshot.connectionState == ConnectionState.done ||
//                   snapshot.connectionState == ConnectionState.active)) {
//             return BaseHealthChart(datasources: snapshot.data.toList());
//           }
//           return const SizedBox.shrink();
//         });
//   }
// }
