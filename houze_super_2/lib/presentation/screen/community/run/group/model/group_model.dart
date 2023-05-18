import 'package:equatable/equatable.dart';
import 'package:houze_super/utils/index.dart';

import 'index.dart';

/*
statusRun: 
== 0 ? chưa đạt
== 1 ? đạt
*/
enum StatusRunState { none, running, accomplished, fault }

class GroupModel extends Equatable {
  GroupModel({
    this.id,
    this.eventId,
    this.statusRun,
    this.name,
    this.isWaitingAccept,
    this.distance,
    this.totalTime,
    this.code,
    this.createdBy,
    this.joined,
    this.requests,
  });

  final String? id;
  final String? eventId;
  final int? statusRun;
  final String? name;
  final bool? isWaitingAccept;
  final String? distance;
  final String? totalTime;
  final String? code;
  final MemberModel? createdBy;
  final List<JoinedModel>? joined;
  final List<RequestModel>? requests;

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
        id: json["id"],
        eventId: json["event_id"],
        statusRun: json["status_run"],
        name: json["name"],
        isWaitingAccept: json["is_waiting_accept"],
        distance: json["distance"],
        totalTime: json["total_time"],
        code: json["code"],
        createdBy: MemberModel.fromJson(json["created_by"]),
        joined: json["joined"] == null
            ? null
            : List<JoinedModel>.from(
                json["joined"].map((x) => JoinedModel.fromJson(x))),
        requests: json["requests"] == null
            ? null
            : List<RequestModel>.from(
                json["requests"].map((x) => RequestModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "status_run": statusRun,
        "name": name,
        "is_waiting_accept": isWaitingAccept,
        "distance": distance,
        "total_time": totalTime,
        "code": code,
        "created_by": createdBy != null ? createdBy!.toJson() : null,
        "joined": joined == null
            ? null
            : List<JoinedModel>.from(joined!.map((x) => x)),
        "requests": requests == null
            ? null
            : List<RequestModel>.from(requests!.map((x) => x)),
      };

  double get distanceKm => distance!.toDouble()!.kilometers();

  @override
  List<Object> get props => [
        id ?? '',
        eventId ?? '',
        statusRun ?? 0,
        name ?? '',
        isWaitingAccept ?? '',
        distance ?? '',
        totalTime ?? '',
        code ?? '',
        createdBy ?? '',
        joined ?? '',
        requests ?? '',
      ];

  @override
  String toString() =>
      'GroupModel { group_id: $id \t name: $name \t statusRun: $statusRun}';
}
