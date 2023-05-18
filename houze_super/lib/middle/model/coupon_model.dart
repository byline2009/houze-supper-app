import 'package:houze_super/middle/model/image_meta_model.dart';
import 'package:houze_super/middle/model/image_model.dart';

class CouponModel {
  CouponModel(
      {this.id,
      this.title,
      this.startDate,
      this.endDate,
      this.images,
      this.shops,
      this.isExpired,
      this.isPicked,
      this.quantity,
      this.description});

  String id;
  String title;
  String startDate;
  String endDate;
  List<ImageModel> images;
  List<Shops> shops;
  bool isExpired;
  bool isPicked;
  int quantity;
  String description;

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    if (json['images'] != null) {
      images = List<ImageModel>();
      json['images'].forEach((v) {
        images.add(ImageModel.fromJson(v));
      });
    }
    if (json['shops'] != null) {
      shops = List<Shops>();
      json['shops'].forEach((v) {
        shops.add(Shops.fromJson(v));
      });
    }
    isExpired = json['is_expired'];
    isPicked = json['is_picked'];
    quantity = json['quantity'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.shops != null) {
      data['shops'] = this.shops.map((v) => v.toJson()).toList();
    }

    data['is_expired'] = this.isExpired;
    data['is_picked'] = this.isPicked;
    data['quantity'] = this.quantity;
    data['description'] = this.description;
    return data;
  }
}

class Shops {
  String id;
  String name;
  int type;
  ImageThumbModel image;
  String address;
  String path;

  Shops({
    this.id,
    this.name,
    this.type,
    this.image,
    this.address,
    this.path,
  });

  Shops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    image =
        json['image'] != null ? ImageThumbModel.fromJson(json['image']) : null;
    address = json['address'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.image != null) {
      data['image'] = this.image.toJson();
    }
    data['address'] = this.address;
    data['path'] = this.path;
    return data;
  }
}

////COUPON MODEL
class CouponListModel {
  int response;
  int count = 0;
  List<CouponModel> data;

  CouponListModel({this.response, this.count = 0, this.data});

  CouponListModel.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    count = json['count'];
    if (json['data'] != null) {
      data = <CouponModel>[];
      json['data'].forEach((v) {
        data.add(CouponModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['response'] = this.response;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
