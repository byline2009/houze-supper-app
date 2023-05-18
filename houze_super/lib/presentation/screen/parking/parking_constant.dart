import 'package:flutter/material.dart';

import '../../index.dart';

class ParkingConstant {
  static final List<String> vehicleImages = const [
    AppVectors.motor,
    AppVectors.car,
    AppVectors.bicycle,
    AppVectors.electric_bike,
  ];

  static final List<String> vehicleNames = const [
    'motor_bike',
    'car',
    'bicycle',
    'electric_bike',
  ];
  static final List<String> bookingStatusList = const [
    'register_pending',
    'active',
    'rejected_1',
    'canceled',
  ];
  static final List<Color> bookingStatusColors = const [
    Color(0xffd68100),
    Color(0xff38d6ac),
    Color(0xffc50000),
    Color(0xffff6666),
  ];
}
