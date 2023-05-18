import 'package:equatable/equatable.dart';

import 'user_model.dart';

class RequestModel extends Equatable {
  final String id;
  final MemberModel user;

  const RequestModel({this.id, this.user});

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json['id'] == null ? null : json['id'],
        user: json['user'] != null ? MemberModel.fromJson(json['user']) : null,
      );
  Map<String, dynamic> toJson() => {
        'id': this.id == null ? null : this.id,
        'user': this.user == null ? null : user.toJson(),
      };

  @override
  List<Object> get props => [
        id,
        user,
      ];
}
