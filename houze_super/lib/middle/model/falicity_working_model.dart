class FacilityWorkingModel {
  String startTime;
  String endTime;
  int freeSlot;

  FacilityWorkingModel({this.startTime, this.endTime});

  FacilityWorkingModel.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    freeSlot = json['free_slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['free_slot'] = this.freeSlot;
    return data;
  }
}
