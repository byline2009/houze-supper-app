import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/ticket_model.dart';

class DiscussionModel {
  DiscussionModel(
      {this.id,
      this.buildingId,
      this.title,
      this.description,
      this.publishedDate,
      this.displayType,
      this.category,
      this.user,
      this.userId,
      this.likeCount,
      this.commentCount,
      this.images,
      this.hasLike});

  final String? id;
  final String? buildingId;
  final String? title;
  final String? description;
  final dynamic publishedDate;
  final int? displayType;
  final int? category;
  final User? user;
  final String? userId;
  int? likeCount;
  int? commentCount;
  final List<ImageModel>? images;
  bool? hasLike;

  factory DiscussionModel.fromJson(Map<String, dynamic> json) =>
      DiscussionModel(
        id: json["id"] == null ? null : json["id"],
        buildingId: json["building_id"] == null ? null : json["building_id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        publishedDate:
            json["published_date"] == null ? null : json["published_date"],
        displayType: json["display_type"] == null ? null : json["display_type"],
        category: json["category"] == null ? null : json["category"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        userId: json["user_id"] == null ? null : json["user_id"],
        likeCount: json["like_count"] == null ? null : json["like_count"],
        commentCount:
            json["comment_count"] == null ? null : json["comment_count"],
        images: json["images"] == null
            ? null
            : (json['images'] as List).map((i) {
                return ImageModel.fromJson(i);
              }).toList(),
        hasLike: json["has_like"] == null ? null : json["has_like"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "building_id": buildingId == null ? null : buildingId,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "published_date": publishedDate,
        "display_type": displayType == null ? null : displayType,
        "category": category == null ? null : category,
        "user": user == null ? null : user!.toJson(),
        "user_id": userId,
        "like_count": likeCount,
        "comment_count": commentCount,
        "images": images == null
            ? null
            : List<ImageModel>.from(images!.map((x) => x)),
        "has_like": hasLike,
      };
}

class User {
  User({
    this.id,
    this.fullname,
    this.gender,
    this.imageThumb,
    this.role,
    this.phoneNumber,
    this.intlCode,
  });

  String? id;
  String? fullname;
  String? gender;
  String? imageThumb;
  String? role;
  int? phoneNumber;
  int? intlCode;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullname: json["fullname"],
        gender: json["gender"],
        imageThumb: json["image_thumb"],
        role: json["role"],
        phoneNumber: json["phone_number"],
        intlCode: json["intl_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "gender": gender,
        "image_thumb": imageThumb,
        "role": role,
        "phone_number": phoneNumber,
        "intl_code": intlCode,
      };
}

class DiscussionUpdateModel {
  DiscussionUpdateModel(
      {this.id,
      this.buildingId,
      this.description,
      this.displayType,
      this.category,
      this.images}) {
    if (this.images == null) {
      this.images = [];
    }
  }

  String? id;
  String? buildingId;
  String? description;
  int? displayType;
  int? category;
  List<ImageUploadModel>? images;

  factory DiscussionUpdateModel.fromJson(Map<String, dynamic> json) =>
      DiscussionUpdateModel(
        id: json["id"] == null ? null : json["id"],
        buildingId: json["building_id"] == null ? null : json["building_id"],
        description: json["description"] == null ? null : json["description"],
        displayType: json["display_type"] == null ? null : json["display_type"],
        category: json["category"] == null ? null : json["category"],
        images: (json['images'] as List).map((i) {
          return ImageUploadModel.fromJson(i);
        }).toList(),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "building_id": buildingId == null ? null : buildingId,
        "description": description == null ? null : description,
        "display_type": displayType == null ? null : displayType,
        "category": category == null ? null : category,
        'image_ids': images!.map((i) {
          return i.id;
        }).toList(),
      };
}
