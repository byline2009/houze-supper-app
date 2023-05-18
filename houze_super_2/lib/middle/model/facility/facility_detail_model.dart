import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/utils/string_util.dart';

class FacilityDetailModel {
  String? id;
  String? title;
  int? typeCharge;
  String? priceMin;
  String? priceMax;
  int? typeFacility;
  int? typeRegistration;
  String? buildingId;
  int? status;
  String? description;
  String? regulation;
  List<WorkingDaysDetail>? workingDaysDetail;
  List<ImageModel>? images;

  FacilityDetailModel(
      {this.id,
      this.title,
      this.typeCharge,
      this.priceMin,
      this.priceMax,
      this.typeFacility,
      this.typeRegistration,
      this.buildingId,
      this.status,
      this.description,
      this.regulation,
      this.workingDaysDetail,
      this.images});

  FacilityDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    typeCharge = json['type_charge'];
    priceMin = json['price_min'];
    priceMax = json['price_max'];
    typeFacility = json['type_facility'];
    typeRegistration = json['type_registration'];
    buildingId = json['building_id'];
    status = json['status'];
    description = json['description'];
    regulation = json['regulation'];
    if (json['working_days_detail'] != null) {
      workingDaysDetail = <WorkingDaysDetail>[];
      json['working_days_detail'].forEach((v) {
        workingDaysDetail!.add(WorkingDaysDetail.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <ImageModel>[];
      json['images'].forEach((v) {
        images!.add(ImageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['type_charge'] = this.typeCharge;
    data['price_min'] = this.priceMin;
    data['price_max'] = this.priceMax;
    data['type_facility'] = this.typeFacility;
    data['type_registration'] = this.typeRegistration;
    data['building_id'] = this.buildingId;
    data['status'] = this.status;
    data['description'] = this.description;
    data['regulation'] = this.regulation;
    if (this.workingDaysDetail != null) {
      data['working_days_detail'] =
          this.workingDaysDetail!.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkingDaysDetail {
  int? weekday;
  String? startTime;
  String? endTime;

  WorkingDaysDetail({this.weekday, this.startTime, this.endTime});

  WorkingDaysDetail.fromJson(Map<String, dynamic> json) {
    weekday = json['weekday'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weekday'] = this.weekday;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }

  String getTime() =>
      StringUtil.removeLastCharacter(startTime!, total: 3) +
      ' - ' +
      StringUtil.removeLastCharacter(endTime!, total: 3);

  String formatWeekDay(BuildContext context) =>
      StringUtil.formatWeekDay(context, weekday!);
}
