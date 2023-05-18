import 'package:equatable/equatable.dart';

import 'building_model.dart';
import 'fee_model.dart';

class PaymentHistoryPageModel extends Equatable {
  final int total;
  final List<PaymentHistoryModel> transactions;
  final bool isNext;
  final bool isLoading;

  const PaymentHistoryPageModel(
      {this.total,
      this.transactions,
      this.isNext = true,
      this.isLoading = false});

  factory PaymentHistoryPageModel.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryPageModel(
          total: json['total'] == null ? null : json['total'],
          transactions:
              json['transactions'] == null ? null : json['transactions']);

  Map<String, dynamic> toJson() => {
        "total": total != null ? total : null,
        "transactions": transactions != null ? transactions : null,
      };
  @override
  List<Object> get props => [total, transactions, isNext, isLoading];
}

class PaymentHistoryModel {
  String id;
  Building building;
  Company company;
  String apartmentId;
  dynamic apartmentName;
  CreatedBy createdBy;
  String created;
  String amount;
  int status;
  String urlPayment;
  String gatewayName;
  String info;
  String orderCodeV2;
  bool isTestMode;
  List<FeeDetailMessageModel> fees;
  String service;

  PaymentHistoryModel(
      {this.id,
      this.building,
      this.apartmentId,
      this.apartmentName,
      this.createdBy,
      this.created,
      this.amount,
      this.status,
      this.urlPayment,
      this.gatewayName,
      this.info,
      this.company,
      this.orderCodeV2,
      this.isTestMode,
      this.fees,
      this.service});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    building = json['building'] != null
        ? new Building.fromJson(json['building'])
        : null;
    createdBy = json['created_by'] != null
        ? new CreatedBy.fromJson(json['created_by'])
        : null;
    created = json['created'];
    amount = json['amount'];
    status = json['status'];
    apartmentId = json['apartment_id'];
    apartmentName = json['apartment_name'];
    urlPayment = json['url_payment'];
    gatewayName = json['gateway_name'];
    orderCodeV2 = json['order_code_v2'];
    isTestMode = json['is_test_mode'];
    info = json['info'];
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
    if (json['fees'] != null) {
      fees = new List<FeeDetailMessageModel>();
      json['fees'].forEach((v) {
        fees.add(new FeeDetailMessageModel.fromJson(v));
      });
    }
    service = json['service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.building != null) {
      data['building'] = this.building.toJson();
    }
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy.toJson();
    }
    data['created'] = this.created;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['apartment_id'] = this.apartmentId;
    data['apartment_name'] = this.apartmentName;
    data['url_payment'] = this.urlPayment;
    data['gateway_name'] = this.gatewayName;
    if (this.isTestMode != null) {
      data['is_test_mode'] = this.isTestMode;
    }
    data['info'] = this.info;
    data['order_code_v2'] = this.orderCodeV2;
    if (this.company != null) {
      data['company'] = this.company.toJson();
    }
    if (this.fees != null) {
      data['fees'] = this.fees.map((v) => v.toJson()).toList();
    }
    data['service'] = this.service;
    return data;
  }
}

class Building {
  String id;
  String name;
  int type;

  Building({this.id, this.name});

  Building.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class CreatedBy {
  String id;
  bool isStaff;
  bool isSuperuser;
  String fullname;
  int phoneNumber;
  String gender;
  Null role;

  CreatedBy(
      {this.id,
      this.isStaff,
      this.isSuperuser,
      this.fullname,
      this.phoneNumber,
      this.gender,
      this.role});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isStaff = json['is_staff'];
    isSuperuser = json['is_superuser'];
    fullname = json['fullname'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_staff'] = this.isStaff;
    data['is_superuser'] = this.isSuperuser;
    data['fullname'] = this.fullname;
    data['phone_number'] = this.phoneNumber;
    data['gender'] = this.gender;
    data['role'] = this.role;
    return data;
  }
}

