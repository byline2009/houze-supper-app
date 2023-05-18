import '../building_model.dart';

class HubProperties {
  List<BuildingMessageModel> buildingJson;

  HubProperties({this.buildingJson});

  HubProperties.fromJson(Map<String, dynamic> json) {
    if (json['building_json'] != null) {
      buildingJson = new List<BuildingMessageModel>();
      json['building_json'].forEach((v) {
        buildingJson.add(new BuildingMessageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.buildingJson != null) {
      data['building_json'] = this.buildingJson.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
