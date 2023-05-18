import 'package:equatable/equatable.dart';

class ImagesDetail extends Equatable {
  const ImagesDetail({
    this.id,
    this.image,
  });

  final String id;
  final String image;

  factory ImagesDetail.fromJson(dynamic json) {
    return ImagesDetail(
      id: json['id'] == null ? null : json['id'],
      image: json['image'] == null ? null : json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };

  @override
  List<Object> get props => [
        id,
        image,
      ];

  @override
  String toString() => 'ImagesDetail { id: $id  \t image: $image}';
}
