class FacilityRegistryModel {
  String id;
  String facilityId;
  String apartmentId;
  String residentId;

  String startTime;
  String endTime;

  String date;
  DateTime dateTime;

  String facilitySlotId;
  String facilityName;

  int adultsNum = 0;
  int childrenNum = 0;

  String description;

  FacilityRegistryModel(
      {this.id,
      this.facilityId,
      this.apartmentId,
      this.residentId,
      this.startTime,
      this.endTime,
      this.date,
      this.dateTime,
      this.facilitySlotId,
      this.facilityName,
      this.adultsNum = 0,
      this.childrenNum = 0,
      this.description});

  factory FacilityRegistryModel.fromJson(Map<String, dynamic> json) {
    return FacilityRegistryModel(
      id: json['id'],
      facilityId: json['facility_id'],
      apartmentId: json['apartment_id'],
      facilitySlotId: json['facility_slot_id'],
      residentId: json['resident_id'],
      adultsNum: json['adults_num'],
      childrenNum: json['children_num'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      date: json['date'],
    );
  }

  FacilityRegistryModel.map(dynamic obj) {
    this.id = obj['id'];
    this.description = obj['description'];
    this.facilityId = obj['facility_id'];
    this.apartmentId = obj['apartment_id'];
    this.facilitySlotId = obj['facility_slot_id'];
    this.residentId = obj['resident_id'];
    this.adultsNum = obj['adults_num'];
    this.childrenNum = obj['children_num'];
    this.startTime = obj['start_time'];
    this.endTime = obj['end_time'];
    this.date = obj['date'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'facility_id': facilityId,
        'apartment_id': apartmentId,
        'facility_slot_id': facilitySlotId,
        'resident_id': residentId,
        'adults_num': adultsNum,
        'children_num': childrenNum,
        'start_time': startTime,
        'end_time': endTime,
        'date': date,
      };
}
