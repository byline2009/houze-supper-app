import 'package:equatable/equatable.dart';

class AccountInfoPayMe extends Equatable {
  AccountInfoPayMe({
    this.account,
  });

  final Account account;

  factory AccountInfoPayMe.fromJson(Map<String, dynamic> json) =>
      AccountInfoPayMe(
        account:
            json["Account"] == null ? null : Account.fromJson(json["Account"]),
      );

  Map<String, dynamic> toJson() => {
        "Account": account == null ? null : account.toJson(),
      };

  @override
  List<Object> get props => [
        account,
      ];
}

class Account extends Equatable {
  Account({
    this.accountId,
    this.fullname,
    this.alias,
    this.birthday,
    this.avatar,
    this.email,
    this.gender,
    this.isVerifiedEmail,
    this.isWaitingEmailVerification,
    this.phone,
    this.state,
    this.kyc,
    this.address,
  });

  final String accountId;
  final String fullname;
  final String alias;
  final String birthday;
  final String avatar;
  final String email;
  final String gender;
  final bool isVerifiedEmail;
  final bool isWaitingEmailVerification;
  final String phone;
  final String state;
  final Kyc kyc;
  final Address address;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        accountId: json["accountId"] == null ? null : json["accountId"],
        fullname: json["fullname"] == null ? null : json["fullname"],
        alias: json["alias"] == null ? null : json["alias"],
        birthday: json["birthday"] == null ? null : json["birthday"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        email: json["email"] == null ? null : json["email"],
        gender: json["gender"] == null ? null : json["gender"],
        isVerifiedEmail:
            json["isVerifiedEmail"] == null ? null : json["isVerifiedEmail"],
        isWaitingEmailVerification: json["isWaitingEmailVerification"] == null
            ? null
            : json["isWaitingEmailVerification"],
        phone: json["phone"] == null ? null : json["phone"],
        state: json["state"] == null ? null : json["state"],
        kyc: json["kyc"] == null ? null : Kyc.fromJson(json["kyc"]),
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "accountId": accountId == null ? null : accountId,
        "fullname": fullname == null ? null : fullname,
        "alias": alias == null ? null : alias,
        "birthday": birthday == null ? null : birthday,
        "avatar": avatar == null ? null : avatar,
        "email": email == null ? null : email,
        "gender": gender == null ? null : gender,
        "isVerifiedEmail": isVerifiedEmail == null ? null : isVerifiedEmail,
        "isWaitingEmailVerification": isWaitingEmailVerification == null
            ? null
            : isWaitingEmailVerification,
        "phone": phone == null ? null : phone,
        "state": state == null ? null : state,
        "kyc": kyc == null ? null : kyc.toJson(),
        "address": address == null ? null : address.toJson(),
      };
  @override
  List<Object> get props => [
        accountId,
        fullname,
        alias,
        birthday,
        avatar,
        email,
        gender,
        isVerifiedEmail,
        isWaitingEmailVerification,
        phone,
        state,
        kyc,
        address,
      ];
}

class Address extends Equatable {
  Address({
    this.street,
    this.city,
    this.ward,
    this.district,
  });
  @override
  List<Object> get props => [
        street,
        city,
        ward,
        district,
      ];
  final String street;
  final City city;
  final City ward;
  final City district;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"] == null ? null : json["street"],
        city: json["city"] == null ? null : City.fromJson(json["city"]),
        ward: json["ward"] == null ? null : City.fromJson(json["ward"]),
        district:
            json["district"] == null ? null : City.fromJson(json["district"]),
      );

  Map<String, dynamic> toJson() => {
        "street": street == null ? null : street,
        "city": city == null ? null : city.toJson(),
        "ward": ward == null ? null : ward.toJson(),
        "district": district == null ? null : district.toJson(),
      };
}

class City extends Equatable {
  City({
    this.identifyCode,
    this.path,
    this.title,
  });

  final String identifyCode;
  final String path;
  final String title;

  factory City.fromJson(Map<String, dynamic> json) => City(
        identifyCode:
            json["identifyCode"] == null ? null : json["identifyCode"],
        path: json["path"] == null ? null : json["path"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "identifyCode": identifyCode == null ? null : identifyCode,
        "path": path == null ? null : path,
        "title": title == null ? null : title,
      };

  @override
  List<Object> get props => [
        identifyCode,
        path,
        title,
      ];
}

class Kyc extends Equatable {
  Kyc({
    this.state,
    this.sentAt,
    this.reason,
    this.kycId,
    this.identifyNumber,
    this.details,
  });

  final String state;
  final String sentAt;
  final String reason;
  final String kycId;
  final String identifyNumber;
  final Details details;

  factory Kyc.fromJson(Map<String, dynamic> json) => Kyc(
        state: json["state"] == null ? null : json["state"],
        sentAt: json["sentAt"] == null ? null : json["sentAt"],
        reason: json["reason"] == null ? null : json["reason"],
        kycId: json["kycId"] == null ? null : json["kycId"],
        identifyNumber:
            json["identifyNumber"] == null ? null : json["identifyNumber"],
        details:
            json["details"] == null ? null : Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "state": state == null ? null : state,
        "sentAt": sentAt == null ? null : sentAt,
        "reason": reason == null ? null : reason,
        "kycId": kycId == null ? null : kycId,
        "identifyNumber": identifyNumber == null ? null : identifyNumber,
        "details": details == null ? null : details.toJson(),
      };

  @override
  List<Object> get props => [
        state,
        sentAt,
        reason,
        kycId,
        identifyNumber,
        details,
      ];
}

class Details extends Equatable {
  Details({
    this.video,
    this.image,
    this.face,
    this.identifyNumber,
    this.issuedAt,
  });

  final Face video;
  final Face image;
  final Face face;
  final String identifyNumber;
  final String issuedAt;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        video: json["video"] == null ? null : Face.fromJson(json["video"]),
        image: json["image"] == null ? null : Face.fromJson(json["image"]),
        face: json["face"] == null ? null : Face.fromJson(json["face"]),
        identifyNumber:
            json["identifyNumber"] == null ? null : json["identifyNumber"],
        issuedAt: json["issuedAt"] == null ? null : json["issuedAt"],
      );

  Map<String, dynamic> toJson() => {
        "video": video == null ? null : video.toJson(),
        "image": image == null ? null : image.toJson(),
        "face": face == null ? null : face.toJson(),
        "identifyNumber": identifyNumber == null ? null : identifyNumber,
        "issuedAt": issuedAt == null ? null : issuedAt,
      };

  @override
  List<Object> get props => [
        video,
        image,
        face,
        identifyNumber,
        issuedAt,
      ];
}

class Face extends Equatable {
  Face({
    this.state,
  });

  final String state;

  factory Face.fromJson(Map<String, dynamic> json) => Face(
        state: json["state"] == null ? null : json["state"],
      );

  Map<String, dynamic> toJson() => {
        "state": state == null ? null : state,
      };

  @override
  List<Object> get props => [state];
}
