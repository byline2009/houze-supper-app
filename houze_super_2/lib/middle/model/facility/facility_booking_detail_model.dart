import 'package:houze_super/middle/model/facility_slot_model.dart';

class FacilityBookingDetailModel {
  String? id;
  Resident? resident;
  Apartment? apartment;
  Facility? facility;
  FacilitySlotModel? facilitySlot;
  String? date;
  String? startTime;
  String? endTime;
  String? created;
  int? adultsNum;
  int? childrenNum;
  String? description;
  int? status;
  String? note;

  FacilityBookingDetailModel(
      {this.id,
      this.resident,
      this.apartment,
      this.facility,
      this.facilitySlot,
      this.date,
      this.startTime,
      this.endTime,
      this.created,
      this.adultsNum,
      this.childrenNum,
      this.description,
      this.status,
      this.note});

  FacilityBookingDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resident =
        json['resident'] != null ? Resident.fromJson(json['resident']) : null;
    apartment = json['apartment'] != null
        ? Apartment.fromJson(json['apartment'])
        : null;
    facility =
        json['facility'] != null ? Facility.fromJson(json['facility']) : null;
    facilitySlot = json['facility_slot'] != null
        ? FacilitySlotModel.fromJson(json['facility_slot'])
        : null;
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    created = json['created'];
    adultsNum = json['adults_num'];
    childrenNum = json['children_num'];
    description = json['description'];
    status = json['status'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    if (this.resident != null) {
      data['resident'] = this.resident!.toJson();
    }
    if (this.apartment != null) {
      data['apartment'] = this.apartment!.toJson();
    }
    if (this.facility != null) {
      data['facility'] = this.facility!.toJson();
    }
    if (this.facilitySlot != null) {
      data['facility_slot'] = this.facilitySlot!.toJson();
    }
    data['date'] = this.date;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['created'] = this.created;
    data['adults_num'] = this.adultsNum;
    data['children_num'] = this.childrenNum;
    data['description'] = this.description;
    data['status'] = this.status;
    data['note'] = this.note;
    return data;
  }
}

class Resident {
  String? id;
  String? fullname;
  int? phoneNumber;
  int? intlCode;
  String? gender;

  Resident(
      {this.id, this.fullname, this.phoneNumber, this.intlCode, this.gender});

  Resident.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    phoneNumber = json['phone_number'];
    intlCode = json['intl_code'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['phone_number'] = this.phoneNumber;
    data['intl_code'] = this.intlCode;
    data['gender'] = this.gender;
    return data;
  }
}

class Apartment {
  String? id;
  String? name;

  Apartment({this.id, this.name});

  Apartment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Facility {
  String? id;
  String? title;

  Facility({this.id, this.title});

  Facility.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}
