import 'dart:convert';

import 'package:equatable/equatable.dart';

class ImageUploadModel {
  String? id;

  ImageUploadModel({this.id});

  ImageUploadModel.map(dynamic obj) {
    this.id = obj['id'];
  }

  factory ImageUploadModel.fromJson(Map<String, dynamic> json) {
    return ImageUploadModel(
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class TicketModel {
  String? description;
  dynamic phone;
  int? category;
  String? apartmentID;
  String? floorID;
  String? blockID;
  String? buildingID;
  String? residentID;
  List<ImageUploadModel>? images;
  double? lat;
  double? long;
  String? videoUrl;
  TicketModel({
    this.description = "",
    this.category,
    this.phone,
    this.apartmentID = "",
    this.floorID,
    this.blockID,
    this.buildingID,
    this.residentID,
    this.images,
    this.lat,
    this.long,
    this.videoUrl,
  }) {
    if (this.images == null) {
      this.images = <ImageUploadModel>[];
    }
  }

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      description: json['description'],
      category: json['category'],
      phone: json['phone'],
      apartmentID: json['apartment_id'],
      floorID: json['floor_id'],
      blockID: json['block_id'],
      buildingID: json['building_id'],
      residentID: json['resident_id'],
      videoUrl: json['video_url'],
      images: (json['images'] as List).map((i) {
        return ImageUploadModel.fromJson(i);
      }).toList(),
    );
  }

  TicketModel.map(dynamic obj) {
    this.description = obj['description'];
    this.phone = obj['phone'];
    this.category = obj['category'];
    this.apartmentID = obj['apartment_id'];
    this.floorID = obj['floor_id'];
    this.blockID = obj['block_id'];
    this.buildingID = obj['building_id'];
    this.residentID = obj['resident_id'];
    this.videoUrl = obj['video_url'];
    this.images = (obj['images'] as List).map((i) {
      return ImageUploadModel.fromJson(i);
    }).toList();
    this.lat = obj['lat'];
    this.long = obj['long'];
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'category': category,
        'phone': phone,
        'apartment_id': apartmentID,
        'floor_id': floorID,
        'block_id': blockID,
        'building_id': buildingID,
        'resident_id': residentID,
        'video_url': videoUrl,
        'images': images ?? [],
        'lat': lat,
        'long': long,
      };

  Map<String, dynamic> toJsonWithoutVideoUrl() => {
        'description': description,
        'category': category,
        'phone': phone,
        'apartment_id': apartmentID,
        'floor_id': floorID,
        'block_id': blockID,
        'building_id': buildingID,
        'resident_id': residentID,
        'images': images ?? [],
        'lat': lat,
        'long': long,
      };
}

/* ticket detail */

class Assignee extends Equatable {
  final String? id;
  final bool? isStaff;
  final bool? isSuperuser;
  final String fullname;
  final int? phoneNumber;
  final String? gender;
  final String? imageThumb;
  final String? role;
  final bool? isAdmin;
  final int? intlCode;

  Assignee({
    required this.id,
    required this.isStaff,
    required this.isSuperuser,
    required this.fullname,
    required this.phoneNumber,
    required this.gender,
    required this.imageThumb,
    required this.role,
    required this.isAdmin,
    required this.intlCode,
  });

  factory Assignee.fromJson(Map<String, dynamic> json) => Assignee(
        id: json["id"] ?? "",
        isStaff: json["is_staff"],
        isSuperuser: json["is_superuser"],
        fullname: json["fullname"],
        phoneNumber: json["phone_number"],
        gender: json["gender"],
        role: json['role'] == null ? null : json['role'],
        isAdmin: json['is_admin'] == null ? null : json['is_admin'],
        intlCode: json['intl_code'] == null ? null : json['intl_code'],
        imageThumb: json['image_thumb'] == null ? null : json['image_thumb'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "is_staff": isStaff,
        "is_superuser": isSuperuser,
        "fullname": fullname,
        "phone_number": phoneNumber,
        "gender": gender,
        'image_thumb': imageThumb,
        "intl_code": intlCode,
        "is_admin": isAdmin,
        "role": role,
      };

  @override
  List<Object> get props => [
        this.id ?? "",
        this.isStaff ?? false,
        this.isSuperuser ?? false,
        this.fullname,
        this.phoneNumber ?? 0,
        this.gender ?? "",
        this.imageThumb ?? "",
        this.role ?? "",
        this.isAdmin ?? false,
        this.intlCode ?? 0,
      ];
}

class TicketDetailModel {
  String? id;
  Apartment? building;
  Apartment? block;
  Apartment? floor;
  Apartment? apartment;
  Resident? resident;
  String? residentId;
  String? description;
  String? doingAt;
  String? completedAt;
  int? category;
  int? status;
  String? codeIssue;
  String? assignTime;
  List<dynamic>? images;
  List<dynamic>? confirmImages;
  dynamic createdBy;
  dynamic note;
  String? created;
  Assignee? assignee;
  RatingModel? rating;
  dynamic lat;
  dynamic long;
  String? videoUrl;

  TicketDetailModel({
    this.id,
    this.building,
    this.block,
    this.floor,
    this.apartment,
    this.resident,
    this.residentId,
    this.description,
    this.doingAt,
    this.completedAt,
    this.category,
    this.status,
    this.codeIssue,
    this.assignTime,
    this.images,
    this.confirmImages,
    this.createdBy,
    this.note,
    this.created,
    this.assignee,
    this.rating,
    this.lat,
    this.long,
    this.videoUrl,
  });

  factory TicketDetailModel.fromJson(Map<String, dynamic> json) =>
      TicketDetailModel(
        id: json["id"],
        building: Apartment.fromJson(json["building"]),
        block: Apartment.fromJson(json["block"]),
        floor: Apartment.fromJson(json["floor"]),
        apartment: Apartment.fromJson(json["apartment"]),
        resident: json["resident"] != null
            ? Resident.fromJson(json["resident"])
            : null,
        residentId: json["resident_id"],
        description: json["description"],
        doingAt: json["doing_at"],
        completedAt: json["completed_at"],
        category: json["category"],
        status: json["status"],
        codeIssue: json["code_issue"],
        assignTime: json["assign_time"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        confirmImages: List<dynamic>.from(json["confirm_images"].map((x) => x)),
        createdBy: json["created_by"],
        note: json["note"],
        created: json["created"],
        videoUrl: json["video_url"],
        assignee: json["assignee"] != null
            ? Assignee.fromJson(json["assignee"])
            : null,
        rating: json['rating'] != null
            ? RatingModel.fromJson(json["rating"])
            : null,
        lat: json['lat'] != null && json['lat'] != 0
            ? jsonToDouble(json["lat"])
            : null,
        long: json['long'] != null && json['long'] != 0
            ? jsonToDouble(json["long"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "building": building!.toJson(),
        "block": block!.toJson(),
        "floor": floor!.toJson(),
        "apartment": apartment!.toJson(),
        "resident": resident!.toJson(),
        "resident_id": residentId,
        "description": description,
        "doing_at": doingAt,
        "completed_at": completedAt,
        "category": category,
        "status": status,
        "code_issue": codeIssue,
        "assign_time": assignTime,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "confirm_images": List<dynamic>.from(confirmImages!.map((x) => x)),
        "created_by": createdBy,
        "note": note,
        "created": created,
        "assignee": assignee!.toJson(),
        "rating": rating!.toJson(),
        "lat": lat,
        "long": long,
        "video_url": videoUrl,
      };

  String getTitleRating() {
    switch (rating!.rating) {
      case 1:
        return "poor";
      case 2:
        return "fair";
      case 3:
        return "good";
      case 4:
        return "very_good";
      case 5:
        return "excellent";
    }
    return '';
  }

  static double jsonToDouble(dynamic value) => value.toDouble();
}

class Building {
  String? id;
  String? name;

  Building({this.id, this.name});

  Building.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Resident {
  String? id;
  String? fullname;
  dynamic phoneNumber;
  String? gender;

  Resident({this.id, this.fullname, this.phoneNumber, this.gender});

  Resident.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['phone_number'] = this.phoneNumber;
    data['gender'] = this.gender;
    return data;
  }
}

class Images {
  String? id;
  String? url;

  Images({this.id, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}

class Apartment {
  String? id;
  String? name;

  Apartment({
    this.id,
    this.name,
  });

  factory Apartment.fromRawJson(String str) =>
      Apartment.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Apartment.fromJson(Map<String, dynamic> json) => Apartment(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class TicketRatingTitleModel {
  String? image;
  String? title;
  TicketRatingTitleModel({this.image, this.title});

  TicketRatingTitleModel.map(dynamic obj) {
    this.image = obj['image'];
    this.title = obj['title'];
  }
}

class RatingModel {
  String? id;
  int? rating;
  List<int>? quickReview;
  String? review;
  String? ticketID;

  RatingModel(
      {this.id, this.rating, this.quickReview, this.review, this.ticketID});

  RatingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rating = json['rating'];
    quickReview = json['quick_review'].cast<int>();
    review = json['review'];
    ticketID = json['ticket_id'];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "rating": rating,
        "quick_review": quickReview ?? [],
        "review": review ?? "",
        "ticket_id": ticketID,
      };
}
