import 'package:equatable/equatable.dart';

class ImageMetaModel extends Equatable {
  final String id;
  final String url;

  ImageMetaModel({
    required this.id,
    required this.url,
  });

  factory ImageMetaModel.fromJson(Map<String, dynamic> json) =>
      new ImageMetaModel(
        id: json["id"],
        url: json["url"] ?? json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };

  @override
  List<Object> get props => [
        id,
        url,
      ];
}

class ImageThumbModel {
  String? id;
  String? image;
  String? imageThumb;

  ImageThumbModel({this.id, this.image, this.imageThumb});

  ImageThumbModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    imageThumb = json['image_thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['image'] = this.image;
    data['image_thumb'] = this.imageThumb;
    return data;
  }
}
