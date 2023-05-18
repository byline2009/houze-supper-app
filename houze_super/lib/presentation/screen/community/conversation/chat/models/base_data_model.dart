import 'package:equatable/equatable.dart';

class BaseDataModel extends Equatable {
  BaseDataModel({
    this.statusCode,
    this.message,
    this.data,
  });

  final int statusCode;
  final dynamic message;
  final dynamic data;

  factory BaseDataModel.fromJson(Map<String, dynamic> json) => BaseDataModel(
        statusCode: json["statusCode"] == null ? null : json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : json["data"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode == null ? null : statusCode,
        "message": message,
        "data": data == null ? null : data,
      };

  @override
  List<Object> get props => [
        this.statusCode,
        this.message,
        this.data,
      ];
}
