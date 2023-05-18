import 'package:equatable/equatable.dart';

abstract class ApartmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllApartment extends ApartmentEvent {
  final String? buildingId;

  GetAllApartment({this.buildingId});

  @override
  String toString() => 'GetAllApartment { buildingId: $buildingId }';

  @override
  List<Object> get props => [buildingId ?? ''];
}

class ApartmentLoadList extends ApartmentEvent {
  ApartmentLoadList();
}

class ApartmentGetDetail extends ApartmentEvent {
  final String id;

  ApartmentGetDetail({required this.id});
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'ApartmentGetDetail {id: $id}';
}
