import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/utils/settings/places_categories.dart';

class ShopModel {
  String? id;
  String? name;
  int? type;
  ImageModel? image;
  String? address;
  String? path;
  double? distance;

  ShopModel(
      {this.id,
      this.name,
      this.type,
      this.image,
      this.address,
      this.path,
      this.distance});

  ShopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    image = json['image'] != null ? ImageModel.fromJson(json['image']) : null;
    address = json['address'];
    path = json['path'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['address'] = this.address;
    data['path'] = this.path;
    data['distance'] = this.distance;
    return data;
  }

  CategoryItem getCategoryByType() {
    return PlacesAround.categories
        .firstWhere((o) => type == o.id);
  }
}
