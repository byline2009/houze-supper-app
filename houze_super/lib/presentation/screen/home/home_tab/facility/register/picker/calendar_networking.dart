import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/utils/constants/api_constants.dart';

class AvailableDaysInMonthModel {
  AvailableDaysInMonthModel({
    @required this.days,
  });

  List<int> days;

  factory AvailableDaysInMonthModel.fromJson(Map<String, dynamic> json) =>
      AvailableDaysInMonthModel(
        days: List<int>.from(json["citizen_json"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "citizen_json": List<dynamic>.from(days.map((x) => x)),
      };
}

class CalendarAPI extends OauthAPI {
  CalendarAPI() : super('');
  Future<AvailableDaysInMonthModel> getData(
      {@required String id,
      @required String year,
      @required String month}) async {
    final response = await this.get(FacilityPath.getFacilities +
        "$id/" +
        "check-month/" +
        "$year/" +
        "$month/");
    var data = json.decode(json.encode(response.data));
    return AvailableDaysInMonthModel.fromJson(data);
  }
}

class CalendarRepo {
  final CalendarAPI _api = CalendarAPI();
  Future<AvailableDaysInMonthModel> getData(
      {@required String id,
      @required String year,
      @required String month}) async {
    final result = await _api.getData(id: id, year: year, month: month);
    if (result != null) {
      print(json.encode(result));
      return result;
    }
    return null;
  }
}
