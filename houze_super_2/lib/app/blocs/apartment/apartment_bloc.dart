import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/sqflite.dart';

import 'index.dart';

class ApartmentBloc extends Bloc<ApartmentEvent, List<ApartmentMessageModel>> {
  final ApartmentRepository apartmentRepo;

  ApartmentBloc({
    required this.apartmentRepo,
  }) : super(List<ApartmentMessageModel>.filled(0, ApartmentMessageModel(),
            growable: true)) {
    //get all apartments by buildingID
    on<GetAllApartment>((event, emit) async {
      try {
        final buildingId = event.buildingId != ''
            ? event.buildingId
            : Sqflite.currentBuildingID;

        final result =
            await apartmentRepo.getApartments(buildingId: buildingId!);

        emit(result);
      } catch (error) {
        //yield error;
      }
    });

    // get list apartments by buildingID
    on<ApartmentLoadList>((event, emit) async {
      try {
        final buildingId = Sqflite.currentBuildingID;
        final result =
            await apartmentRepo.getApartments(buildingId: buildingId);
        emit(result);
      } catch (error) {
        //yield error;
      }
    });
  }
}

class ApartmentDetailBloc extends Bloc<ApartmentEvent, ApartmentState> {
  final ApartmentRepository apartmentRepo;

  ApartmentDetailBloc({
    required this.apartmentRepo,
  }) : super(ApartmentInitial()) {
    // get detail information of specific apartment
    on<ApartmentGetDetail>((event, emit) async {
      emit(ApartmentLoading());

      try {
        final result = await apartmentRepo.getApartmentByID(id: event.id);

        emit(ApartmentGetDetailSuccessful(apartmentDetail: result));
      } on DioError catch (err) {
        emit(ApartmentFailure(error: err));
      }
    });
  }
}
