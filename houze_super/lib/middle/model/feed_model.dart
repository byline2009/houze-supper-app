import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'keyvalue_model.dart';

class FeedMessageModel {
  String id;
  String refID;
  String type;
  String typeDetail;
  String title;
  List<KeyValueModel> fields;
  List<KeyValueModel> options;
  List<String> tags;
  bool isRead;
  String createdAt;

  FeedMessageModel(
      {@required this.id,
      this.refID,
      this.type,
      this.typeDetail,
      @required this.title,
      this.fields,
      this.options,
      this.tags,
      this.isRead,
      this.createdAt});

  factory FeedMessageModel.fromJson(Map<String, dynamic> json) {
    return FeedMessageModel(
        id: json['id'],
        refID: json['ref_id'],
        type: json['type'],
        typeDetail: json['type_detail'],
        title: json['title'],
        fields: (json['fields'] as List).map((i) {
          return KeyValueModel.fromJson(
              KeyValueModel(key: i["key"], value: i["value"]));
        }).toList(),
        options: (json['options'] as List).map((i) {
          return KeyValueModel.fromJson(
              KeyValueModel(key: i["key"], value: i["value"]));
        }).toList(),
        tags: json['tags']?.cast<String>(),
        isRead: json['is_read'],
        createdAt: json['created_at']);
  }

  FeedMessageModel.map(dynamic obj) {
    this.id = obj['id'];
    this.refID = obj['ref_id'];
    this.type = obj['type'];
    this.typeDetail = obj['type_detail'];
    this.title = obj['title'];
    this.fields = obj['fields'];
    this.options = obj['options'];
    this.tags = obj['tags'];
    this.isRead = obj['is_read'];
    this.createdAt = obj['created_at'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ref_id': refID,
        'type': type,
        'type_detail': typeDetail,
        'title': title,
        'fields': fields,
        'options': options,
        'tags': tags,
        'is_read': isRead,
        'created_at': createdAt,
      };

  String mapIcon() {
    switch (type) {
      case "announcement":
        return "announcement";

      case "ticket":
        return "ticket";

      case "fee_sent":
      case "fee_sent_2":
        return "feedsent";

      case "receipt_sent":
      case "receipt_sent_2":
        return "billing";
    }
    return "announcement";
  }
}

class PlayerModel extends Equatable {
  final String identifier;
  final String registrationID;
  final String template;

  PlayerModel({this.identifier, this.registrationID, this.template});

  static PlayerModel fromJson(dynamic json) {
    return PlayerModel(
      identifier: json['identifier'] == null ? null : json['identifier'],
      registrationID:
          json['registration_id'] == null ? null : json['registration_id'],
      template: json['template'] == null ? null : json['template'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = this.identifier;
    data['registration_id'] = this.registrationID;
    data['template'] = this.template;
    return data;
  }

  @override
  List<Object> get props => [
        identifier,
        registrationID,
        template,
      ];
}
