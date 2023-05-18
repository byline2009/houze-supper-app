import 'package:houze_super/middle/model/image_model.dart';

class SellModel {
  String id;
  String apartmentId;
  String apartmentName;
  String floorName;
  String floorId;
  String blockName;
  String blockId;
  String buildingId;
  String area;
  int bedrooms;
  int bathrooms;
  int kitchens;
  int balconies;
  String sellPrice;
  double percentCommission;
  String requirement;
  int statusPosted;
  int type;
  List<ImageModel> images;
  List<ImageModel> imagesAuthenticated;
  DateTime created;
  DateTime modified;

  SellModel({
    this.id,
    this.apartmentId,
    this.apartmentName,
    this.floorName,
    this.floorId,
    this.blockName,
    this.blockId,
    this.buildingId,
    this.area,
    this.bedrooms,
    this.bathrooms,
    this.kitchens,
    this.balconies,
    this.sellPrice,
    this.percentCommission,
    this.requirement,
    this.statusPosted,
    this.type,
    this.images,
    this.imagesAuthenticated,
    this.created,
    this.modified,
  });

  factory SellModel.fromJson(Map<String, dynamic> json) => SellModel(
        id: json["id"],
        apartmentId: json["apartment_id"],
        apartmentName: json["apartment_name"],
        floorName: json["floor_name"],
        floorId: json["floor_id"],
        blockName: json["block_name"],
        blockId: json["block_id"],
        buildingId: json["building_id"],
        area: json["area"],
        bedrooms: json["bedrooms"],
        bathrooms: json["bathrooms"],
        kitchens: json["kitchens"],
        balconies: json["balconies"],
        sellPrice: json["sale_price"],
        percentCommission: double.parse(json["percent_commission"].toString()),
        requirement: json["requirement"],
        statusPosted: json["status_posted"],
        type: json["type"],
        images: List<ImageModel>.from(
            json["images"].map((x) => ImageModel.fromJson(x))),
        imagesAuthenticated: List<ImageModel>.from(
            json["images_authenticated"].map((x) => ImageModel.fromJson(x))),
        created: DateTime.parse(json["created"]),
        modified: DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "apartment_id": apartmentId,
        "apartment_name": apartmentName,
        "floor_name": floorName,
        "floor_id": floorId,
        "block_name": blockName,
        "block_id": blockId,
        "building_id": buildingId,
        "area": area,
        "bedrooms": bedrooms,
        "bathrooms": bathrooms,
        "kitchens": kitchens,
        "balconies": balconies,
        "sale_price": sellPrice,
        "percent_commission": percentCommission,
        "requirement": requirement,
        "status_posted": statusPosted,
        "type": type,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "images_authenticated":
            List<dynamic>.from(imagesAuthenticated.map((x) => x.toJson())),
        "created": created.toIso8601String(),
        "modified": modified.toIso8601String(),
      };
}

class SellTicketModel {
  String apartmentId;
  String sellPrice;
  double percentCommission;
  String requirement;
  int statusPosted;
  int type;
  var images = <ImageModel>[];
  var imagesAuthenticated = <ImageModel>[];

  SellTicketModel({
    this.apartmentId,
    this.sellPrice,
    this.percentCommission: 0.0,
    this.requirement,
    this.statusPosted,
    this.type,
    this.images,
    this.imagesAuthenticated,
  }) {
    if (this.images == null) this.images = <ImageModel>[];

    if (this.imagesAuthenticated == null)
      this.imagesAuthenticated = <ImageModel>[];
  }

  factory SellTicketModel.fromJson(Map<String, dynamic> json) =>
      SellTicketModel(
        apartmentId: json["apartment_id"],
        sellPrice: json["sale_price"],
        percentCommission: double.parse(json["percent_commission"].toString()),
        requirement: json["requirement"],
        statusPosted: json["status_posted"],
        type: json["type"],
        images: List<ImageModel>.from(
            json["images"].map((x) => ImageModel.fromJson(x))),
        imagesAuthenticated: List<ImageModel>.from(
            json["images_authenticated"].map((x) => ImageModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "apartment_id": apartmentId,
        "sale_price": sellPrice,
        "percent_commission": percentCommission,
        "requirement": requirement,
        "status_posted": statusPosted,
        "type": type,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "images_authenticated":
            List<dynamic>.from(imagesAuthenticated.map((x) => x.toJson())),
      };

  Map<String, dynamic> toJsonRemoveImageThumb() => {
        "apartment_id": apartmentId,
        "sale_price": sellPrice,
        "percent_commission": percentCommission,
        "requirement": requirement,
        "status_posted": statusPosted,
        "type": type,
        "images": List<dynamic>.from(images.map((x) {
          Map<String, dynamic> s = {"id": x.id};
          return s;
        })),
        "images_authenticated": List<dynamic>.from(imagesAuthenticated.map((x) {
          Map<String, dynamic> s = {"id": x.id};
          return s;
        })),
      };
}
