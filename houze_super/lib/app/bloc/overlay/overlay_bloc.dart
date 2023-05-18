import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:houze_super/app/bloc/apartment/index.dart';

import 'package:houze_super/app/bloc/overlay/overlay_event.dart';
import 'package:houze_super/app/bloc/overlay/overlay_state.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/middle/repo/building_repository.dart';
import 'package:houze_super/presentation/screen/home/home_tab/index.dart';
import 'package:houze_super/utils/sqflite.dart';

class OverlayBloc extends Bloc<BuildingPicked, OverlayBlocState> {
  final pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  final apartmentBloc = ApartmentBloc(
    apartmentRepo: ApartmentRepository(),
  );
  final feedBloc = FeedBloc();

  final BuildingRepository rpBuilding = BuildingRepository();

  closeBloc() {
    apartmentBloc.close();
    feedBloc.close();
  }

  //Model cache
  List<BuildingMessageModel> currentBuildings;
  BuildingMessageModel currentBuilding;

  OverlayBloc() : super(AppInitial());

  @override
  Stream<OverlayBlocState> mapEventToState(BuildingPicked event) async* {
    yield OverlayLoading();

    try {
      final result = await rpBuilding.getBuildings();

      currentBuildings = result;

      currentBuilding =
          await Sqflite.updateCurrentBuildings(buildings: currentBuildings);

      yield PickBuildingSuccessful(
        buildings: result,
        currentBuilding: currentBuilding,
      );

      if (result.length > 0) apartmentBloc.add(ApartmentLoadList());
    } catch (error) {
      yield BuildingFailure(error: error);
    }
  }
}
