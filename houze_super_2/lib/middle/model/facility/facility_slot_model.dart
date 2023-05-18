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

class FacilitySlotListModel {
  List<FacilitySlotModel>? citizenJson;

  FacilitySlotListModel({this.citizenJson});

  FacilitySlotListModel.fromJson(Map<String, dynamic> json) {
    if (json['citizen_json'] != null) {
      citizenJson = <FacilitySlotModel>[];
      json['citizen_json'].forEach((v) {
        citizenJson!.add(FacilitySlotModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.citizenJson != null) {
      data['citizen_json'] = this.citizenJson!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
