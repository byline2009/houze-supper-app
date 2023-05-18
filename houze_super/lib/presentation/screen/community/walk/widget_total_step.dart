// import 'package:flutter/material.dart';
// import 'package:health/health.dart';
// import 'package:houze_super/presentation/index.dart';
// import 'package:houze_super/presentation/screen/community/walk/widget_total_point.dart';

// import 'health_manager.dart';

// class TotalStepWidget extends StatelessWidget {
//   final List<HealthDataPoint> value;
//   const TotalStepWidget({@required this.value});
//   @override
//   Widget build(BuildContext context) {
//     int total = FlutterHealthManager.singleton.getStepCount(rs: value);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(total.toString(), style: AppFonts.bold27),
//             SizedBox(width: 6),
//             Text('bước', style: AppFonts.semibold13.copyWith(color: Color(0xff838383),)),
//             SizedBox(width: 30),
//             Text('=', style: AppFonts.bold27),
//             SizedBox(width: 30),
//             HouzePoint(point: 2000),
//           ]),
//     );
//   }
// }
