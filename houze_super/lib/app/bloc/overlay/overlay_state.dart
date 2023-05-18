import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/building_model.dart';

abstract class OverlayBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

//MARK: Coupon
class AppInitial extends OverlayBlocState {
  @override
  String toString() => 'AppInitial';
}

class OverlayLoading extends OverlayBlocState {
  @override
  String toString() => 'OverlayLoading';
}

class PickBuildingSuccessful extends OverlayBlocState {
  final List<BuildingMessageModel> buildings;
  final BuildingMessageModel currentBuilding;

  PickBuildingSuccessful({
    @required this.buildings,
    this.currentBuilding,
  });

  @override
  String toString() =>
      'PickBuildingSuccessful { buildings: $buildings, building_select: $currentBuilding }';
  @override
  List<Object> get props => [
        buildings,
        currentBuilding,
      ];
}

class BuildingFailure extends OverlayBlocState {
  final dynamic error;

  BuildingFailure({
    @required this.error,
  });

  @override
  String toString() => 'BuildingFailure { error: $error }';
  @override
  List<Object> get props => [
        error,
      ];
}
