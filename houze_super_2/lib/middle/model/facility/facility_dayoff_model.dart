class FacilityDayoffModel {
  String? description;

  FacilityDayoffModel({this.description});

  FacilityDayoffModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = this.description;
    return data;
  }
}
