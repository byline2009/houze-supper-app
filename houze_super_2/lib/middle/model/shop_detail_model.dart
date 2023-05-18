import 'package:houze_super/middle/model/image_model.dart';

class ShopDetailModel {
  String? id;
  String? name;
  String? description;
  int? status;
  double? lat;
  double? long;
  List<ImageModel>? images;
  List<Hours>? hours;
  String? address;
  String? path;

  ShopDetailModel(
      {this.id,
      this.name,
      this.description,
      this.status,
      this.lat,
      this.long,
      this.images,
      this.hours,
      this.address,
      this.path});

  ShopDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    status = json['status'];
    lat = json['lat'];
    long = json['long'];
    if (json['images'] != null) {
      images = <ImageModel>[];
      json['images'].forEach((v) {
        images!.add(ImageModel.fromJson(v));
      });
    }
    if (json['hours'] != null) {
      hours = <Hours>[];
      json['hours'].forEach((v) {
        hours!.add(Hours.fromJson(v));
      });
    }
    address = json['address'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['status'] = this.status;
    data['lat'] = this.lat;
    data['long'] = this.long;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.hours != null) {
      data['hours'] = this.hours!.map((v) => v.toJson()).toList();
    }
    data['address'] = this.address;
    data['path'] = this.path;
    return data;
  }
}

class Hours {
  String? id;
  String? startTime;
  String? endTime;
  int? weekday;

  Hours({this.id, this.startTime, this.endTime, this.weekday});

  Hours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    weekday = json['weekday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['weekday'] = this.weekday;
    return data;
  }
}
