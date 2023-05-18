import 'dart:convert';

import 'package:equatable/equatable.dart';

class PageModel extends Equatable {
  final int? count;
  final String? next;
  final String? previous;
  final dynamic results;

  const PageModel({
    this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      count: json['count'] == null ? null : json['count'],
      next: json['next'] == null ? null : json['next'],
      previous: json['previous'] == null ? null : json['previous'],
      results: json['results'] == null ? null : json['results'],
    );
  }

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results,
      };

  @override
  List<Object> get props => [
        this.count ?? '',
        this.next ?? '',
        this.previous ?? '',
        this.results,
      ];
}

class IdNameModel extends Equatable {
  final String? id;
  final String? name;

  IdNameModel({
    this.id,
    this.name,
  });

  factory IdNameModel.fromJson(Map<String, dynamic> json) => IdNameModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object> get props => [
        id ?? '',
        name ?? '',
      ];
}

class ErrorModel {
  ErrorModel({
    this.errorCitizenJson,
  });

  ErrorCitizenJson? errorCitizenJson;

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        errorCitizenJson: json["error_citizen_json"] == null
            ? null
            : ErrorCitizenJson.fromJson(json["error_citizen_json"]),
      );

  Map<String, dynamic> toJson() => {
        "error_citizen_json":
            errorCitizenJson == null ? null : errorCitizenJson!.toJson(),
      };
}

class ErrorCitizenJson {
  ErrorCitizenJson({
    this.httpStatusCode,
    this.httpBody,
  });

  int? httpStatusCode;
  HttpBody? httpBody;

  factory ErrorCitizenJson.fromJson(Map<String, dynamic> data) =>
      ErrorCitizenJson(
        httpStatusCode:
            data["http_status_code"] == null ? null : data["http_status_code"],
        httpBody: data["http_body"] == null
            ? null
            : HttpBody.fromJson(json.decode(data["http_body"])),
      );

  Map<String, dynamic> toJson() => {
        "http_status_code": httpStatusCode == null ? null : httpStatusCode,
        "http_body": httpBody == null ? null : httpBody!.toJson(),
      };
}

class HttpBody {
  HttpBody({
    this.typeVehicle,
  });

  List<String>? typeVehicle;

  factory HttpBody.fromJson(Map<String, dynamic> json) => HttpBody(
        typeVehicle: json["type_vehicle"] == null
            ? null
            : List<String>.from(json["type_vehicle"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type_vehicle": typeVehicle == null
            ? null
            : List<dynamic>.from(typeVehicle!.map((x) => x)),
      };
}
