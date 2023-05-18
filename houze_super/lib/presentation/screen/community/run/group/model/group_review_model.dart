import 'package:equatable/equatable.dart';

class GroupReviewModel extends Equatable {
  final int status;
  const GroupReviewModel({this.status});

  factory GroupReviewModel.fromJson(Map<String, dynamic> json) =>
      GroupReviewModel(
        status: json['status'] == null ? null : json['status'],
      );

  Map<String, dynamic> toJson() => {
        'status': this.status == null ? null : this.status,
      };

  @override
  List<Object> get props => [status];
}
