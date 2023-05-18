class FacilityHistoryModel {
  String? id;
  String? date;
  int? status;
  String? startTime;
  String? endTime;
  String? facilityTitle;
  String? facilitySlotName;

  FacilityHistoryModel(
      {this.id, this.date, this.status, this.startTime, this.endTime});

  FacilityHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    status = json['status'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    facilityTitle = json['facility_title'];
    facilitySlotName = json['facility_slot_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['date'] = this.date;
    data['status'] = this.status;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['facility_title'] = this.facilityTitle;
    data['facility_slot_name'] = this.facilitySlotName;
    return data;
  }
}
