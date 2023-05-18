import 'package:houze_super/middle/model/page_model.dart';

class ApartmentMessageBaseModel {
  List<ApartmentMessageModel> citizenJson;

  ApartmentMessageBaseModel({this.citizenJson});

  ApartmentMessageBaseModel.fromJson(Map<String, dynamic> json) {
    if (json['citizen_json'] != null) {
      citizenJson = List<ApartmentMessageModel>();
      json['citizen_json'].forEach((v) {
        citizenJson.add(ApartmentMessageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.citizenJson != null) {
      data['citizen_json'] = this.citizenJson.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ApartmentMessageModel {
  String id;
  String name;
  String floorId;
  String blockId;
  String buildingId;
  String apartmentTypeId;
  String residentId;

  ApartmentMessageModel(
      {this.id,
      this.name,
      this.floorId,
      this.blockId,
      this.buildingId,
      this.apartmentTypeId,
      this.residentId});

  ApartmentMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    floorId = json['floor_id'];
    blockId = json['block_id'];
    buildingId = json['building_id'];
    apartmentTypeId = json['apartment_type_id'];
    residentId = json['resident_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['floor_id'] = this.floorId;
    data['block_id'] = this.blockId;
    data['building_id'] = this.buildingId;
    data['apartment_type_id'] = this.apartmentTypeId;
    data['resident_id'] = this.residentId;
    return data;
  }
}

class ApartmentDetailModel {
  String id;
  String name;
  String area;
  IdNameModel floor;
  IdNameModel block;
  Building building;
  ApartmentType apartmentType;
  List<UserListModel> owners;
  List<UserListModel> renters;
  List<UserListModel> residents;

  ApartmentDetailModel(
      {this.id,
      this.name,
      this.area,
      this.floor,
      this.block,
      this.building,
      this.apartmentType,
      this.owners,
      this.renters,
      this.residents});

  ApartmentDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    area = json['area'];
    floor = json['floor'] != null ? IdNameModel.fromJson(json['floor']) : null;
    block = json['block'] != null ? IdNameModel.fromJson(json['block']) : null;
    building =
        json['building'] != null ? Building.fromJson(json['building']) : null;
    apartmentType = json['apartment_type'] != null
        ? ApartmentType.fromJson(json['apartment_type'])
        : null;
    if (json['owners'] != null) {
      owners = List<UserListModel>();
      json['owners'].forEach((v) {
        owners.add(UserListModel.fromJson(v));
      });
    }
    if (json['renters'] != null) {
      renters = List<UserListModel>();
      json['renters'].forEach((v) {
        renters.add(UserListModel.fromJson(v));
      });
    }
    if (json['residents'] != null) {
      residents = List<UserListModel>();
      json['residents'].forEach((v) {
        residents.add(UserListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['area'] = this.area;
    if (this.floor != null) {
      data['floor'] = this.floor.toJson();
    }
    if (this.block != null) {
      data['block'] = this.block.toJson();
    }
    if (this.building != null) {
      data['building'] = this.building.toJson();
    }
    if (this.apartmentType != null) {
      data['apartment_type'] = this.apartmentType.toJson();
    }
    if (this.owners != null) {
      data['owners'] = this.owners.map((v) => v.toJson()).toList();
    }
    if (this.renters != null) {
      data['renters'] = this.renters.map((v) => v.toJson()).toList();
    }
    if (this.residents != null) {
      data['residents'] = this.residents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Building {
  String id;
  String name;
  String address;
  String area;

  Building({this.id, this.name, this.address, this.area});

  Building.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    area = json['area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['area'] = this.area;
    return data;
  }
}

class ApartmentType {
  String id;
  String name;
  int bedrooms;
  int bathrooms;
  int kitchens;
  int balconies;

  ApartmentType(
      {this.id,
      this.name,
      this.bedrooms,
      this.bathrooms,
      this.kitchens,
      this.balconies});

  ApartmentType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bedrooms = json['bedrooms'];
    bathrooms = json['bathrooms'];
    kitchens = json['kitchens'];
    balconies = json['balconies'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['bedrooms'] = this.bedrooms;
    data['bathrooms'] = this.bathrooms;
    data['kitchens'] = this.kitchens;
    data['balconies'] = this.balconies;
    return data;
  }
}

class UserListModel {
  String id;
  String checkIn;
  String checkOut;
  int type;
  Resident resident;

  UserListModel(
      {this.id, this.checkIn, this.checkOut, this.type, this.resident});

  UserListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    checkIn = json['check_in'] != null ? json['check_in'] : "";
    checkOut = json['check_out'] != null ? json['check_out'] : "";
    type = json['type'];
    resident =
        json['resident'] != null ? Resident.fromJson(json['resident']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['type'] = this.type;
    if (this.resident != null) {
      data['resident'] = this.resident.toJson();
    }
    return data;
  }
}

class Resident {
  String id;
  String fullname;
  dynamic phoneNumber;
  String gender;

  Resident({this.id, this.fullname, this.phoneNumber, this.gender});

  Resident.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['phone_number'] = this.phoneNumber;
    data['gender'] = this.gender;
    return data;
  }
}
