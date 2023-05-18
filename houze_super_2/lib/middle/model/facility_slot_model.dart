class FacilitySlotModel {
  String? id;
  String? name;
  bool? isFree;

  FacilitySlotModel({this.id, this.name, this.isFree});

  FacilitySlotModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isFree = json['is_free'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_free'] = this.isFree;
    return data;
  }
}
