import 'dart:convert';

import 'image_meta_model.dart';
import 'ticket_model.dart';

ParkingVehicleBooking parkingVehicleBookingFromJson(String str) =>
    ParkingVehicleBooking.fromJson(json.decode(str));

String parkingVehicleBookingToJson(ParkingVehicleBooking data) =>
    json.encode(data.toJson());

class ParkingVehicle {
  String? id;
  Apartment? building;
  Apartment? apartment;
  Apartment? parking;
  int? typeVehicle;
  int? status;
  String? cardCode;
  String? vehicleName;
  String? vehicleColor;
  String? licensePlate;
  String? dateRegistration;
  String? dateExpiration;
  bool? isExpired;
  String? description;
  String? note;
  List<ImageMetaModel>? images;

  ParkingVehicle({
    this.id,
    this.building,
    this.apartment,
    this.parking,
    this.typeVehicle,
    this.status,
    this.cardCode,
    this.vehicleName,
    this.vehicleColor,
    this.licensePlate,
    this.dateRegistration,
    this.dateExpiration,
    this.isExpired,
    this.description,
    this.note,
    this.images,
  });

  factory ParkingVehicle.fromJson(Map<String, dynamic> json) => ParkingVehicle(
        id: json["id"],
        building: Apartment.fromJson(json["building"]),
        apartment: Apartment.fromJson(json["apartment"]),
        parking: Apartment.fromJson(json["parking"]),
        typeVehicle: json["type_vehicle"],
        status: json["status"],
        cardCode: json["card_code"],
        vehicleName: json["vehicle_name"],
        vehicleColor: json["vehicle_color"],
        licensePlate: json["license_plate"],
        dateRegistration: json["date_registration"],
        dateExpiration: json["date_expiration"],
        isExpired: json["is_expired"],
        description: json["description"],
        note: json["note"],
        images: List<ImageMetaModel>.from(
            json["images"].map((x) => ImageMetaModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "building": building!.toJson(),
        "apartment": apartment!.toJson(),
        "parking": parking!.toJson(),
        "type_vehicle": typeVehicle,
        "status": status,
        "card_code": cardCode,
        "vehicle_name": vehicleName,
        "vehicle_color": vehicleColor,
        "license_plate": licensePlate,
        "date_registration": dateRegistration,
        "date_expiration": dateExpiration,
        "is_expired": isExpired,
        "description": description,
        "note": note,
        "images": List<ImageMetaModel>.from(images!.map((x) => x.toJson())),
      };
}

class ParkingVehicleBooking {
  ParkingVehicleBooking({
    this.buildingId,
    this.apartmentId,
    this.residentId,
    this.parkingId,
    this.typeVehicle,
    this.vehicleName,
    this.vehicleColor,
    this.licensePlate,
    this.description,
    this.images,
  });

  String? buildingId;
  String? apartmentId;
  String? residentId;
  String? parkingId;
  int? typeVehicle;
  String? vehicleName;
  String? vehicleColor;
  String? licensePlate;
  String? description;
  List<ImageMetaModel>? images;

  factory ParkingVehicleBooking.fromJson(Map<String, dynamic> json) =>
      ParkingVehicleBooking(
        buildingId: json["building_id"],
        apartmentId: json["apartment_id"],
        residentId: json["resident_id"],
        parkingId: json["parking_id"],
        typeVehicle: json["type_vehicle"],
        vehicleName: json["vehicle_name"],
        vehicleColor: json["vehicle_color"],
        licensePlate: json["license_plate"],
        description: json["description"],
        images: List<ImageMetaModel>.from(
            json["images"].map((x) => ImageMetaModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "building_id": buildingId,
        "apartment_id": apartmentId,
        "resident_id": residentId,
        "parking_id": parkingId,
        "type_vehicle": typeVehicle,
        "vehicle_name": vehicleName,
        "vehicle_color": vehicleColor,
        "license_plate": licensePlate,
        "description": description,
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class Parking {
  String? id;
  String? name;
  int? carSlots;
  int? motoSlots;
  int? bikeSlots;
  int? eSlots;
  int? status;
  Building? building;

  Parking({
    this.id,
    this.name,
    this.carSlots,
    this.motoSlots,
    this.bikeSlots,
    this.eSlots,
    this.status,
    this.building,
  });

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
        id: json["id"],
        name: json["name"],
        carSlots: json["car_slots"],
        motoSlots: json["moto_slots"],
        bikeSlots: json["bike_slots"],
        eSlots: json["e_slots"],
        status: json["status"],
        building: Building.fromJson(json["building"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "car_slots": carSlots,
        "moto_slots": motoSlots,
        "bike_slots": bikeSlots,
        "e_slots": eSlots,
        "status": status,
        "building": building!.toJson(),
      };
}
