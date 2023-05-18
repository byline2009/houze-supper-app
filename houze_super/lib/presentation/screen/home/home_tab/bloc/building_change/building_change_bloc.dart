import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:houze_super/presentation/screen/home/home_tab/bloc/index.dart';
import 'package:houze_super/utils/sqflite.dart';

class BuildingChangeBloc
    extends Bloc<BuildingChangeEvent, BuildingChangeState> {
  BuildingChangeBloc() : super(BuildingChangeInitial());

  @override
  Stream<BuildingChangeState> mapEventToState(
      BuildingChangeEvent event) async* {
    if (event is BuildingChangePicked) {
      yield BuildingChangeLoading();
      final currentBuildingID = await Sqflite.getCurrentBuildingID();
      final buildings = await Sqflite.getBuildingList();
      yield BuildingChangeSuccessful(
          currentBuildingID: currentBuildingID, buildings: buildings);
    }
  }
}
