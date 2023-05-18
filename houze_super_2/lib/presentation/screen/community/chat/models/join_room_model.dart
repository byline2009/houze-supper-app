import 'package:equatable/equatable.dart';

class JoinRoomModel extends Equatable {
  JoinRoomModel({
    this.roomId,
    this.type,
    this.refId,
    this.title,
  });

  final String? roomId;
  final String? type;
  final String? refId;
  final String? title;

  factory JoinRoomModel.fromJson(Map<String, dynamic> json) => JoinRoomModel(
        roomId: json["room_id"] == null ? null : json["room_id"],
        type: json["type"] == null ? null : json["type"],
        refId: json["ref_id"] == null ? null : json["ref_id"],
        title: json["title"] == null ? null : json["title"],
      );

  Map<String, dynamic> toJson() => {
        "room_id": roomId == null ? null : roomId,
        "type": type == null ? null : type,
        "ref_id": refId == null ? null : refId,
        "title": title == null ? null : title,
      };

  @override
  List<Object> get props => [
        this.roomId!,
        this.type!,
        this.refId!,
        this.title!,
      ];
}
