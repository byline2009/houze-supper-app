class FeeGroupByApartments {
  List<FeeApartments> apartments;
  String buildingId;
  String buildingName;
  List<int> feeAvailable;
  String companyId;
  String companyImageThumb;
  String companyName;
  String service;
  int buildingType;

  FeeGroupByApartments(
      {this.apartments,
      this.buildingId,
      this.buildingName,
      this.feeAvailable,
      this.companyId,
      this.companyImageThumb,
      this.companyName,
      this.service,
      this.buildingType});

  FeeGroupByApartments.fromJson(Map<String, dynamic> json) {
    if (json['apartments'] != null) {
      apartments = List<FeeApartments>();
      json['apartments'].forEach((v) {
        apartments.add(FeeApartments.fromJson(v));
      });
    }
    buildingId = json['building_id'];
    buildingName = json['building_name'];
    feeAvailable = json["fee_available"] == null
        ? null
        : List<int>.from(json["working_days"].map((x) => x));
    companyId = json['company_id'];
    companyImageThumb = json['company_image_thumb'];
    companyName = json['company_name'];
    service = json['service'];
    buildingType = json['building_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.apartments != null) {
      data['apartments'] = this.apartments.map((v) => v.toJson()).toList();
    }
    data['building_id'] = this.buildingId;
    data['building_name'] = this.buildingName;
    data['fee_available'] = this.feeAvailable == null
        ? null
        : List<dynamic>.from(feeAvailable.map((x) => x));
    data['company_id'] = this.companyId;
    data['company_image_thumb'] = this.companyImageThumb;
    data['company_name'] = this.companyName;
    data['service'] = this.service;
    data['building_type'] = this.buildingType;
    return data;
  }
}

class Fees {
  int type;
  String totalFee;

  Fees({this.type, this.totalFee});

  Fees.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    totalFee = json['total_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['total_fee'] = this.totalFee;
    return data;
  }
}

class FeeApartments {
  String id;
  String name;
  List<Fees> fees;

  FeeApartments({this.id, this.name, this.fees});

  FeeApartments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['fees'] != null) {
      fees = new List<Fees>();
      json['fees'].forEach((v) {
        fees.add(new Fees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.fees != null) {
      data['fees'] = this.fees.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

