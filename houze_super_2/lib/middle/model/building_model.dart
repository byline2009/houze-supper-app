class BuildingMessageModel {
  String? id;
  String? hotLine;
  String? name;
  String? address;
  String? area;
  List<int>? feeDisplay;
  int? statusSale;
  String? description;
  double? lat;
  double? long;
  List<String>? apartmentsName;
  Company? company;
  List<String>? gateways;
  bool? isMicro;
  String? service;
  String? logo;
  int? type;

  BuildingMessageModel({
    this.id,
    this.hotLine,
    this.name,
    this.address,
    this.area,
    this.feeDisplay,
    this.statusSale,
    this.description,
    this.lat,
    this.long,
    this.apartmentsName,
    this.company,
    this.gateways,
    this.isMicro,
    this.logo,
    this.service,
    this.type,
  });

  BuildingMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hotLine = json['hot_line'];
    name = json['name'];
    address = json['address'];
    area = json['area'];
    feeDisplay = json['fee_display'].cast<int>();
    statusSale = json['status_sale'];
    description = json['description'];
    lat = json['lat'];
    long = json['long'];
    apartmentsName = json['apartments_name'].cast<String>();
    company =
        json['company'] != null ? Company.fromJson(json['company']) : Company();
    gateways = json['gateways'].cast<String>();
    isMicro = json['is_micro'] ?? false;
    logo = json['logo'];
    service = json['service'];
    type = json['type'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['hot_line'] = this.hotLine;
    data['name'] = this.name;
    data['address'] = this.address;
    data['area'] = this.area;
    data['fee_display'] = this.feeDisplay;
    data['status_sale'] = this.statusSale;
    data['description'] = this.description;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['apartments_name'] = this.apartmentsName;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    data['gateways'] = this.gateways;
    data['is_micro'] = this.isMicro;
    data['logo'] = this.logo;
    data['service'] = this.service;
    data['type'] = this.type;
    return data;
  }

  String convertApartments() {
    String rs = '';
    apartmentsName!.forEach((f) {
      if (f != apartmentsName!.last) {
        rs += f + ', ';
      } else {
        rs += f;
      }
    });
    return rs;
  }
}

class BuildingImage {
  BuildingImage({
    this.image,
    this.imageThumb,
  });

  String? image;
  String? imageThumb;

  BuildingImage.fromJson(Map<String, dynamic> json) {
    image = json["image"];
    imageThumb = json["image_thumb"];
  }

  Map<String, dynamic> toJson() => {
        "image": image,
        "image_thumb": imageThumb,
      };
}

class Company {
  String? id;
  String? name;
  String? welcome;
  String? imageThumb;
  String? coverThumb;
  String? logo;

  Company(
      {this.id,
      this.name: "has_not_been_updated",
      this.welcome: "Welcome to Houze App",
      this.imageThumb: "",
      this.coverThumb = "",
      this.logo});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    welcome = json['welcome'];
    imageThumb = json['image_thumb'];
    coverThumb = json['cover_thumb'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['welcome'] = this.welcome;
    data['image_thumb'] = this.imageThumb;
    data['cover_thumb'] = this.coverThumb;
    data['logo'] = this.logo;
    return data;
  }
}
