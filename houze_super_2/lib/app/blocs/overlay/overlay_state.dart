import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/building_model.dart';

abstract class OverlayBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

//MARK: Coupon
class AppInitial extends OverlayBlocState {
  @override
  String toString() => 'AppInitial';
  @override
  List<Object?> get props => [];
}

class OverlayLoading extends OverlayBlocState {
  @override
  String toString() => 'OverlayLoading';
  @override
  List<Object?> get props => [];
}

class PickBuildingSuccessful extends OverlayBlocState {
  final List<BuildingMessageModel> buildings;
  final BuildingMessageModel currentBuilding;
  final List<ApartmentMessageModel> apartments;
  PickBuildingSuccessful({
    required this.buildings,
    required this.currentBuilding,
    required this.apartments,
  });

  @override
  String toString() =>
      'PickBuildingSuccessful { buildings: ${buildings.length}, building_select: ${currentBuilding.name} apartmentsName: ${apartments.map((e) => e.name).toList()}}';
  @override
  List<Object> get props => [
        buildings,
        currentBuilding,
        apartments,
      ];
}

class BuildingFailure extends OverlayBlocState {
  final dynamic error;

  BuildingFailure({
    required this.error,
  });

  @override
  String toString() => 'BuildingFailure { error: $error }';

  @override
  List<Object> get props => [
        error,
      ];
}
