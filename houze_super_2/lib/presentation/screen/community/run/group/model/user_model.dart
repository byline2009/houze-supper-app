import 'package:equatable/equatable.dart';

class MemberModel extends Equatable {
  MemberModel({
    this.id,
    this.fullname,
    this.imageThumb,
    this.gender,
  });

  final String? id;
  final String? fullname;
  final String? imageThumb;
  final String? gender;

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
        id: json["id"],
        fullname: json["fullname"],
        imageThumb: json["image_thumb"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "image_thumb": imageThumb,
        "gender": gender,
      };

  @override
  List<Object> get props => [
        id ?? '',
        fullname ?? '',
        imageThumb ?? '',
        gender ?? '',
      ];

  @override
  String toString() =>
      'UserModel { id: $id \t fullname: $fullname \t gender: $gender \t imageThumb: $imageThumb}';
}
