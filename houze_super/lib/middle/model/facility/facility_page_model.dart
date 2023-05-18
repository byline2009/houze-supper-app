import 'package:houze_super/middle/model/facility/facility_model.dart';

class FacilityPageModel {
  int total;
  List<FacilityModel> facility;

  FacilityPageModel({this.total, this.facility});

  FacilityPageModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    facility = json['Facility'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = this.total;
    data['Facility'] = this.facility;
    return data;
  }
}
