class CommentModel {
  String? id;
  String? description;
  String? created;
  CreatedBy? createdBy;
  List<CommentImage>? images;
  CommentModel(
      {this.id, this.description, this.created, this.createdBy, this.images});

  CommentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    created = json['created'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((image) {
        images!.add(CommentImage.fromJson(image));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['description'] = this.description;
    data['created'] = this.created;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((i) => i.toJson()).toList();
    }
    return data;
  }
}

class CommentPageModel {
  int? total;
  List<CommentModel>? comments;

  CommentPageModel({this.total, this.comments});

  CommentPageModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = this.total;
    data['comments'] = this.comments;
    return data;
  }
}

class CreatedBy {
  String? id;
  bool? isStaff;
  bool? isSuperuser;
  String? fullname;
  dynamic phoneNumber;
  String? gender;
  String? role;
  String? imageThumb;

  CreatedBy(
      {this.id,
      this.isStaff,
      this.isSuperuser,
      this.fullname,
      this.phoneNumber,
      this.gender,
      this.role,
      this.imageThumb});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isStaff = json['is_staff'];
    isSuperuser = json['is_admin'];
    fullname = json['fullname'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    role = json['role'];
    imageThumb = json['image_thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['is_staff'] = this.isStaff;
    data['is_admin'] = this.isSuperuser;
    data['fullname'] = this.fullname;
    data['phone_number'] = this.phoneNumber;
    data['gender'] = this.gender;
    data['role'] = this.role;
    data['image_thumb'] = this.imageThumb;
    return data;
  }
}

class CommentImage {
  CommentImage({
    this.image,
    this.imageThumb,
  });

  String? image;
  String? imageThumb;

  factory CommentImage.fromJson(Map<String, dynamic> json) => CommentImage(
        image: json["image"],
        imageThumb: json["image_thumb"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "image_thumb": imageThumb,
      };
}
