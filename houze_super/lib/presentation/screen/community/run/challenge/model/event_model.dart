import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/index.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/chat/widgets/run_constant.dart';
import 'package:houze_super/utils/index.dart';
import 'package:intl/intl.dart';

import 'images_detail_model.dart';

/* Hiển thị Kết quả tiến trình chạy được của nhóm trong 1 giải chạy

none: Chưa đăng ký Giải chạy
running: Giải chạy đang diễn ra và 
          user đã tham gia Giải và 
          Team chưa hoàn thành mục tiêu.
accomplished: Team đã hoàn thành mục tiêu 
              trước khi Giải chạy kết thúc 
              (Hiện tại, giải có thể đang diễn ra hoặc đã kết thúc)
fault: Team không hoàn thành mục tiêu
        (Hiện tại Giải đã kết thúc)

*/

class EventModel extends Equatable {
  EventModel({
    this.id,
    this.name,
    this.organization,
    this.isRegistry,
    this.isExpired,
    this.groupTotal,
    this.description,
    this.descriptionDetail,
    this.beginAt,
    this.endAt,
    this.daysLeft,
    this.targetRun,
    this.maximumMember,
    this.imageThumb,
    this.groups,
    this.imagesDetail,
    this.externalTarget,
  });

  final String id;
  final String name;
  final String organization;
  final bool isRegistry;
  final bool isExpired;
  final int groupTotal;
  final String description;
  final String descriptionDetail;
  final String beginAt;
  final String endAt;
  final double daysLeft;
  final int targetRun;
  final int maximumMember;
  final String imageThumb;
  final int externalTarget;

  final List<GroupModel> groups;
  final List<ImagesDetail> imagesDetail;

  static EventModel fromJson(dynamic json) {
    return EventModel(
      id: json["id"] == null ? null : json["id"],
      name: json["name"] == null ? null : json["name"],
      organization: json["organization"] == null ? null : json["organization"],
      isRegistry: json["is_registry"] == null ? null : json["is_registry"],
      isExpired: json["is_expired"] == null ? null : json["is_expired"],
      groupTotal: json["group_total"] == null ? null : json["group_total"],
      description: json["description"] == null ? null : json["description"],
      descriptionDetail: json["description_detail"] == null
          ? null
          : json["description_detail"],
      beginAt: json["begin_at"] == null ? null : json["begin_at"],
      endAt: json["end_at"] == null ? null : json["end_at"],
      daysLeft: json["days_left"] == null ? null : json["days_left"].toDouble(),
      targetRun: json["target_run"] == null ? null : json["target_run"],
      maximumMember:
          json["maximum_member"] == null ? null : json["maximum_member"],
      imageThumb: json["image_thumb"] == null ? null : json["image_thumb"],
      groups: json["groups"] == null
          ? null
          : List<GroupModel>.from(json["groups"].map((x) => x)),
      imagesDetail: json["images_detail"] == null
          ? null
          : List<ImagesDetail>.from(
              json["images_detail"].map(
                (x) => ImagesDetail.fromJson(x),
              ),
            ),
      externalTarget:
          json["external_target"] == null ? null : json["external_target"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "organization": organization == null ? null : organization,
        "is_registry": isRegistry == null ? null : isRegistry,
        "is_expired": isExpired == null ? null : isExpired,
        "group_total": groupTotal == null ? null : groupTotal,
        "description": description == null ? null : description,
        "description_detail":
            descriptionDetail == null ? null : descriptionDetail,
        "begin_at": beginAt == null ? null : beginAt,
        "end_at": endAt == null ? null : endAt,
        "days_left": daysLeft == null ? null : daysLeft,
        "target_run": targetRun == null ? null : targetRun,
        "maximum_member": maximumMember == null ? null : maximumMember,
        "image_thumb": imageThumb == null ? null : imageThumb,
        "groups": groups == null
            ? null
            : List<GroupModel>.from(
                groups.map((x) => x),
              ),
        "images_detail": imagesDetail == null
            ? null
            : List<dynamic>.from(
                imagesDetail.map(
                  (x) => x.toJson(),
                ),
              ),
        "external_target": externalTarget == null ? null : externalTarget,
      };

  String timeToRun(BuildContext context) =>
      LocalizationsUtil.of(context).translate('k_from') +
      ' ' +
      DateUtil.format('dd/MM/yyyy', beginAt) +
      ' ' +
      LocalizationsUtil.of(context).translate('k_to') +
      ' ' +
      DateUtil.format('dd/MM/yyyy', endAt);

  String get targetRunUnit => NumberFormat('#,###').format((targetRun)) + ' km';

  RunningState get runningState {
    if (isExpired) {
      return RunningState.expired;
    }
    if (!isExpired && isRegistry) {
      return RunningState.registered;
    }
    return RunningState.unregistered;
  }

  @override
  List<Object> get props => [
        id,
        name,
        organization,
        isRegistry,
        isExpired,
        groupTotal,
        description,
        descriptionDetail,
        beginAt,
        endAt,
        daysLeft,
        targetRun,
        maximumMember,
        imageThumb,
        groups,
        imagesDetail,
        externalTarget,
      ];

  String getDaysLeft(BuildContext context) {
    if (isExpired)
      return '0 ' + LocalizationsUtil.of(context).translate('k_day');
    if (daysLeft < 1.0 && daysLeft > 0.0)
      return (daysLeft * 24.0).roundToDouble().toInt().toString() +
          ' ' +
          LocalizationsUtil.of(context).translate('k_hours');
    return (daysLeft).roundToDouble().toInt().toString() +
        ' ' +
        LocalizationsUtil.of(context).translate('k_day');
  }

  Color foregroundColorLineBar(GroupModel group, EventModel event) {
    if (group.statusRun == 1) {
      return RunConstant.completed;
    } else {
      if (event.isExpired == false) {
        return RunConstant.participating;
      }
      return RunConstant.notCompleted;
    }
  }

  Color backgroundLineBarColor(GroupModel group, EventModel event) {
    if (group.statusRun == 1) {
      return RunConstant.completed;
    } else {
      if (event.isExpired == false) {
        return Color(0xfff2e8ff);
      }
      return Color(0xfff5f5f5);
    }
  }

  @override
  String toString() =>
      'EventModel { id: $id \t name: $name \t organization: $organization}';
}
