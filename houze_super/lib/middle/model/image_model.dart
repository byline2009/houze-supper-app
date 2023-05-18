class ImageModel {
  String id;
  String image;
  String imageThumb;

  ImageModel({
    this.id,
    this.image,
    this.imageThumb,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"],
        image: json["image"],
        imageThumb: json["image_thumb"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "image_thumb": imageThumb,
      };
}

class CommentImageModel {
  int id;
  String image;
  String imageThumb;

  CommentImageModel({
    this.id,
    this.image,
    this.imageThumb,
  });

  factory CommentImageModel.fromJson(Map<String, dynamic> json) =>
      CommentImageModel(
        id: json["id"],
        image: json["image"],
        imageThumb: json["image_thumb"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "image_thumb": imageThumb,
      };
}
