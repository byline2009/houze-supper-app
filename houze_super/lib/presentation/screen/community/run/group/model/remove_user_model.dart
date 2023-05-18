import 'package:equatable/equatable.dart';

class RemoveUserModel extends Equatable {
  final List<String> users;

  const RemoveUserModel({this.users});

  factory RemoveUserModel.fromJson(Map<String, dynamic> json) =>
      RemoveUserModel(
        users: json['users'].cast<String>(),
      );

  Map<String, dynamic> toJson() =>
      {'users': users == null ? null : List<String>.from(users.map((x) => x))};

  @override
  List<Object> get props => [users];
}
