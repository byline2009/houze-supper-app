import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  ProfileModel({
    this.id,
    this.fullname,
    this.phoneNumber,
    this.gender,
    this.birthday,
    this.identityCard,
    this.verifyStatus,
    this.passport,
    this.country,
    this.intlCode,
    this.image,
    this.imageThumb,
    this.paymeToken,
  });

  final String id;
  final String fullname;
  final int phoneNumber;
  final String gender;
  final String birthday;
  final String identityCard;
  final int verifyStatus;
  final String passport;
  final String country;
  final dynamic intlCode;
  final String image;
  final String imageThumb;
  final String paymeToken;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"] == null ? null : json["id"],
        fullname: json["fullname"] == null ? null : json["fullname"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        gender: json["gender"] == null ? null : json["gender"],
        birthday: json["birthday"] == null ? null : json["birthday"],
        identityCard:
            json["identity_card"] == null ? null : json['identity_card'],
        verifyStatus:
            json['verify_status'] == null ? null : json['verify_status'],
        passport: json['passport'] == null ? null : json['passport'],
        country: json['country'] == null ? null : json['country'],
        intlCode: json['intl_code'] == null ? null : json['intl_code'],
        image: json['image'] == null ? null : json['image'],
        imageThumb: json['image_thumb'] == null ? null : json['image_thumb'],
        paymeToken: json['payme_token'] == null ? null : json['payme_token'],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "fullname": fullname == null ? null : fullname,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "gender": gender == null ? null : gender,
        "birthday": birthday == null ? null : birthday,
        "verify_status": verifyStatus == null ? null : verifyStatus,
        'passport': passport == null ? null : passport,
        'country': country == null ? null : country,
        'intl_code': intlCode == null ? null : intlCode,
        'image': image == null ? null : image,
        'image_thumb': imageThumb == null ? null : imageThumb,
        'payme_token': paymeToken == null ? null : paymeToken,
      };

  @override
  List<Object> get props => [
        id,
        fullname,
        phoneNumber,
        gender,
        birthday,
        identityCard,
        verifyStatus,
        passport,
        country,
        intlCode,
        image,
        imageThumb,
        paymeToken,
      ];
}
