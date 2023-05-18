import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/utils/string_util.dart';

class FacilityModel {
  final String id;
  final String title;
  final int typeFacility;
  final int typeRegistration;
  final String buildingId;
  final int status;
  final int typeCharge;
  final String priceMin;
  final String priceMax;
  final List<int> workingDays;

  ImageModel image;

  FacilityModel({
    this.id,
    this.title,
    this.typeFacility,
    this.typeRegistration,
    this.buildingId,
    this.status,
    this.typeCharge,
    this.priceMin,
    this.priceMax,
    this.workingDays,
    this.image,
  });

  factory FacilityModel.fromJson(Map<String, dynamic> json) => FacilityModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        typeFacility:
            json["type_facility"] == null ? null : json["type_facility"],
        typeRegistration: json["type_registration"] == null
            ? null
            : json["type_registration"],
        buildingId: json["building_id"] == null ? null : json["building_id"],
        status: json["status"] == null ? null : json["status"],
        typeCharge: json["type_charge"] == null ? null : json["type_charge"],
        priceMin: json["price_min"] == null ? null : json["price_min"],
        priceMax: json["price_max"] == null ? null : json["price_max"],
        workingDays: json["working_days"] == null
            ? null
            : List<int>.from(json["working_days"].map((x) => x)),
        image:
            json["image"] == null ? null : ImageModel.fromJson(json["image"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "type_facility": typeFacility == null ? null : typeFacility,
        "type_registration": typeRegistration == null ? null : typeRegistration,
        "building_id": buildingId == null ? null : buildingId,
        "status": status == null ? null : status,
        "type_charge": typeCharge == null ? null : typeCharge,
        "price_min": priceMin == null ? null : priceMin,
        "price_max": priceMax == null ? null : priceMax,
        "working_days": workingDays == null
            ? null
            : List<dynamic>.from(workingDays.map((x) => x)),
        "image": image == null ? null : image.toJson(),
      };

  String getTime(BuildContext context) =>
      StringUtil.formatDays(context, workingDays);
}
