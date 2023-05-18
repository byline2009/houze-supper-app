class ServicesMessageModel {
  String id;
  String imgUrl;
  String title;
  String address;

  ServicesMessageModel({this.id, this.imgUrl, this.title, this.address});

  factory ServicesMessageModel.fromJson(Map<String, dynamic> json) {
    return ServicesMessageModel(
        id: json['id'],
        imgUrl: json['img_url'],
        title: json['title'],
        address: json['address']);
  }

  ServicesMessageModel.map(dynamic obj) {
    this.id = obj['id'];
    this.imgUrl = obj['img_url'];
    this.title = obj['title'];
    this.address = obj['address'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'img_url': imgUrl,
        'title': title,
        'address': address,
      };
}

class ServicesModel {
  int statusCode;
  List<ServicesMessageModel> message;

  ServicesModel({this.statusCode, this.message});

  ServicesModel.fromJson(Map<String, dynamic> json) {
    this.statusCode = json['statusCode'];
    this.message = (json['message'] as List).map((i) {
      return ServicesMessageModel.fromJson(i);
    }).toList();
  }

  Map<String, dynamic> c() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}
