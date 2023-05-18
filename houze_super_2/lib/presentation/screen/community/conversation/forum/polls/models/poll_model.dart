import 'package:houze_super/middle/model/image_model.dart';

class PollModel {
  PollModel({
    this.id,
    this.title,
    this.description,
    this.publishedDate,
    this.poll,
    this.status,
    this.user,
    this.userId,
    this.likeCount,
    this.commentCount,
    this.threadType,
    this.images,
    this.canVote,
    this.hasLike,
  });

  String? id;
  String? title;
  String? description;
  dynamic publishedDate;
  Poll? poll;
  int? status;
  User? user;
  String? userId;
  int? likeCount;
  int? commentCount;
  int? threadType;
  List<String>? images;
  bool? canVote;
  bool? hasLike;

  factory PollModel.fromJson(Map<String, dynamic> json) => PollModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        publishedDate: json["published_date"],
        poll: Poll.fromJson(json["poll"]),
        status: json["status"],
        user: User.fromJson(json["user"]),
        userId: json["user_id"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        threadType: json["thread_type"],
        images: json["images"] != null
            ? List<String>.from(json["images"].map((x) => x))
            : null,
        canVote: json["can_vote"],
        hasLike: json["has_like"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "published_date": publishedDate,
        "poll": poll?.toJson(),
        "status": status,
        "user": user?.toJson(),
        "user_id": userId,
        "like_count": likeCount,
        "comment_count": commentCount,
        "thread_type": threadType,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "can_vote": canVote,
        "has_like": hasLike,
      };
}

class Poll {
  Poll({
    this.id,
    this.description,
    this.totalCount,
    this.choices,
  });

  String? id;
  String? description;
  int? totalCount;
  List<Choice>? choices;

  factory Poll.fromJson(Map<String, dynamic> json) => Poll(
        id: json["id"],
        description: json["description"],
        totalCount: json["total_count"],
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "total_count": totalCount,
        "choices": List<dynamic>.from(choices!.map((x) => x.toJson())),
      };
}

class Choice {
  Choice({
    this.id,
    this.description,
    this.choiceCount,
  });

  String? id;
  String? description;
  int? choiceCount;

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        id: json["id"],
        description: json["description"],
        choiceCount: json["choice_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "choice_count": choiceCount,
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

class CurrentUser {
  CurrentUser({
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
  int? role;
  int? phoneNumber;
  int? intlCode;

  factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
        id: json["id"],
        fullname: json["fullname"],
        gender: json["gender"],
        imageThumb: json["image_thumb"],
        role: json["role"] == null ? null : json["role"],
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

class VotingModel {
  VotingModel({
    this.id,
    this.title,
    this.buildingName,
    this.apartmentName,
    this.currentUser,
    this.currentRole,
    this.apartmentArea,
    this.point,
    this.choice,
    this.user,
    this.role,
    this.poll,
  });

  String? id;
  String? title;
  String? buildingName;
  String? apartmentName;
  CurrentUser? currentUser;
  int? currentRole;
  dynamic apartmentArea;
  int? point;
  Choice? choice;
  User? user;
  int? role;
  Poll? poll;

  factory VotingModel.fromJson(Map<String, dynamic> json) => VotingModel(
        id: json["id"],
        title: json["title"],
        buildingName: json["building_name"],
        apartmentName: json["apartment_name"],
        currentUser: CurrentUser.fromJson(json["current_user"]),
        currentRole: json["current_role"],
        apartmentArea: json["apartment_area"],
        point: json["point"],
        choice: json["choice"] == null ? null : Choice.fromJson(json["choice"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        role: json["role"] == null ? null : json["role"],
        poll: Poll.fromJson(json["poll"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "building_name": buildingName,
        "apartment_name": apartmentName,
        "current_user": currentUser!.toJson(),
        "current_role": currentRole,
        "apartment_area": apartmentArea,
        "point": point,
        "choice": choice!.toJson(),
        "user": user,
        "role": role,
        "poll": poll!.toJson(),
      };
}

class PollCommentModel {
  PollCommentModel({
    this.id,
    this.created,
    this.userId,
    this.user,
    this.description,
    this.displayType,
    this.images,
  });

  String? id;
  DateTime? created;
  String? userId;
  User? user;
  String? description;
  int? displayType;
  List<ImageModel>? images;

  factory PollCommentModel.fromJson(Map<String, dynamic> json) =>
      PollCommentModel(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        userId: json["user_id"],
        user: User.fromJson(json["user"]),
        description: json["description"],
        displayType: json["display_type"],
        images: json["images"] != null
            ? List<ImageModel>.from(
                json["images"].map((x) => ImageModel.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created!.toIso8601String(),
        "user_id": userId,
        "user": user!.toJson(),
        "description": description,
        "display_type": displayType,
        "images": List<dynamic>.from(images!.map((x) => x)),
      };
}
