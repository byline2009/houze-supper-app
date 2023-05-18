// import 'package:flutter/material.dart';
// import 'package:health/health.dart';

// class FlutterHealthManager {
//   static final FlutterHealthManager singleton =
//       FlutterHealthManager._internal();
//   FlutterHealthManager._internal();

//   final health = HealthFactory();
//   var isAuthorized = false;

//   int getStepCount({List<HealthDataPoint> rs}) {
//     int steps = 0;

//     rs.forEach((HealthDataPoint x) {
//       steps += x.value.toInt();
//     });
//     return steps;
//   }

//   Future<List<HealthDataPoint>> getHealthData(
//       {required DateTime start, required DateTime end}) async {
//     /// Define the types to get.
//     List<HealthDataType> types = [HealthDataType.STEPS];
//     List<HealthDataPoint> healthData = [];
//     if (isAuthorized == false) {
//       bool accessWasGranted = await health.requestAuthorization(types);

//       if (accessWasGranted) {
//         try {
//           /// Fetch new data
//           healthData = await health.getHealthDataFromTypes(start, end, types);
//           isAuthorized = true;

//           /// Save all the new data points
//         } catch (e) {
//           print("Caught exception in getHealthDataFromTypes: $e");
//         }

//         /// Filter out duplicates
//         healthData = HealthFactory.removeDuplicates(healthData);
//         return healthData;
//       } else {
//         print("Authorization not granted");
//         return null;
//       }
//     } else {
//       try {
//         /// Fetch new data
//         healthData = await health.getHealthDataFromTypes(start, end, types);
//         isAuthorized = true;

//         /// Save all the new data points
//       } catch (e) {
//         print("Caught exception in getHealthDataFromTypes: $e");
//       }

//       /// Filter out duplicates
//       healthData = HealthFactory.removeDuplicates(healthData);
//       return healthData;
//     }
//   }
// }
