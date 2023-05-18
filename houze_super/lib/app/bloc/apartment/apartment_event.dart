import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ApartmentEvent extends Equatable {
  ApartmentEvent([List props = const []]) : super();
}

class GetAllApartment extends ApartmentEvent {
  final String buildingId;

  GetAllApartment({this.buildingId}) : super([]);

  @override
  String toString() => 'GetAllApartment { buildingId: $buildingId }';

  @override
  List<Object> get props => [buildingId];
}

class ApartmentLoadList extends ApartmentEvent {
  ApartmentLoadList() : super([]);
  @override
  List<Object> get props => [];
}

class ApartmentRefresh extends ApartmentEvent {
  ApartmentRefresh() : super([]);
  @override
  List<Object> get props => [];
}

class ApartmentGetDetail extends ApartmentEvent {
  final String id;

  ApartmentGetDetail({@required this.id}) : super();
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'ApartmentGetDetail {id: $id}';
}
