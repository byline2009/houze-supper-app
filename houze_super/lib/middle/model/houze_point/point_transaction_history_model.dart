import 'package:flutter/material.dart';

class PointTransationHistoryModel {
  PointTransationHistoryModel({
    @required this.action,
    @required this.amount,
    @required this.buildingId,
    @required this.created,
    @required this.id,
    @required this.refId,
    @required this.tranType,
    @required this.userId,
  });

  String action;
  int amount;
  String buildingId;
  String created;
  String id;
  String refId;
  int tranType;
  String userId;

  factory PointTransationHistoryModel.fromJson(Map<String, dynamic> json) =>
      PointTransationHistoryModel(
        action: json["action"],
        amount: json["amount"],
        buildingId: json["building_id"],
        created: json["created"],
        id: json["id"],
        refId: json["ref_id"],
        tranType: json["tran_type"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "action": action,
        "amount": amount,
        "building_id": buildingId,
        "created": created,
        "id": id,
        "ref_id": refId,
        "tran_type": tranType,
        "user_id": userId,
      };
}

class TotalPointModel {
  TotalPointModel({
    @required this.amount,
  });

  int amount;

  factory TotalPointModel.fromJson(Map<String, dynamic> json) =>
      TotalPointModel(
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
      };
}
