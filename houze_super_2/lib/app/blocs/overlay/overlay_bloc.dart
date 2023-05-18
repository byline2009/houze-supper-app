import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import 'package:houze_super/app/blocs/overlay/overlay_event.dart';
import 'package:houze_super/app/blocs/overlay/overlay_state.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/middle/repo/building_repository.dart';
import 'package:houze_super/utils/sqflite.dart';

/* Handling of building changes */
class OverlayBloc extends Bloc<OverlayBlocEvent, OverlayBlocState> {
  final pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  final BuildingRepository rpBuilding = BuildingRepository();
  final ApartmentRepository repo = ApartmentRepository();
  //Model cache

  OverlayBloc() : super(AppInitial()) {
    on<BuildingPicked>((event, emit) async {
      emit(OverlayLoading());
      BuildingMessageModel currentBuilding;

      try {
        List<BuildingMessageModel> currentBuildings =
            await rpBuilding.getBuildings();
        currentBuilding = (await Sqflite.updateCurrentBuildings(
          buildings: currentBuildings,
        ))!;
        late List<ApartmentMessageModel> _apartments = [];

        if (currentBuildings.length > 0) {
          _apartments = await repo.getApartments(
            buildingId: currentBuilding.id!,
          );
        }

        emit(PickBuildingSuccessful(
          buildings: currentBuildings,
          currentBuilding: currentBuilding,
          apartments: _apartments,
        ));
      } catch (error) {
        emit(BuildingFailure(error: error));
      }
    });
  }
}
