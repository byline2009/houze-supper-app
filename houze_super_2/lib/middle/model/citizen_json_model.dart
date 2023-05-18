import 'package:houze_super/middle/model/falicity_working_model.dart';

class CitizenJsonModel {
  List<FacilityWorkingModel>? citizenJson;

  CitizenJsonModel({this.citizenJson});

  CitizenJsonModel.fromJson(Map<String, dynamic> json) {
    if (json['citizen_json'] != null) {
      citizenJson = [];
      json['citizen_json'].forEach((v) {
        citizenJson!.add(FacilityWorkingModel.fromJson(v));
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
