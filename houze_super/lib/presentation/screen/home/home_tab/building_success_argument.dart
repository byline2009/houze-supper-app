import 'package:houze_super/middle/model/building_model.dart';

class BuildingSuccessArgument {
  final BuildingMessageModel currentBuilding;
  final List<BuildingMessageModel> buildings;
  const BuildingSuccessArgument({this.currentBuilding, this.buildings});
}
