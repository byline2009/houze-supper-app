import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/building_model.dart';

abstract class BuildingChangeState extends Equatable {
  BuildingChangeState([List props = const []]) : super();
}

class BuildingChangeInitial extends BuildingChangeState {
  @override
  String toString() => 'BuildingChangeInitial';
  @override
  List<Object> get props => [];
}

class BuildingChangeSuccessful extends BuildingChangeState {
  final String currentBuildingID;
  final List<BuildingMessageModel> buildings;

  BuildingChangeSuccessful({this.currentBuildingID, this.buildings});
  @override
  List<Object> get props => [this.currentBuildingID, this.buildings];

  @override
  String toString() =>
      'BuildingChangeSuccessful { currentBuildingID: $currentBuildingID, buildings: $buildings }';
}

class BuildingChangeLoading extends BuildingChangeState {
  @override
  String toString() => 'BuildingChangeLoading';
  @override
  List<Object> get props => [];
}
