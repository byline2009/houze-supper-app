import 'dart:convert';

EKYCModel eKYCModelFromJson(String str) => EKYCModel.fromJson(json.decode(str));

String eKYCModelToJson(EKYCModel data) => json.encode(data.toJson());

class EKYCModel {
  String fullName;
  int cardType;
  String card;
  String cardFrontImage;
  String cardBackImage;
  String portraitImage;
  int status;

  EKYCModel({
    this.fullName,
    this.cardType,
    this.card,
    this.cardFrontImage,
    this.cardBackImage,
    this.portraitImage,
    this.status,
  });

  factory EKYCModel.fromJson(Map<String, dynamic> json) => EKYCModel(
        fullName: json["fullname"],
        cardType: json["type_card"],
        card: json["card"],
        cardFrontImage: json["card_front_image"],
        cardBackImage: json["card_back_image"],
        portraitImage: json["portrait_image"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullName,
        "type_card": cardType,
        "card": card,
        "card_front_image": cardFrontImage,
        "card_back_image": cardBackImage,
        "portrait_image": portraitImage,
        "status": status,
      };
}
