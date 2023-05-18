import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/sqflite.dart';

import 'index.dart';

class ApartmentBloc extends Bloc<ApartmentEvent, List<ApartmentMessageModel>> {
  final ApartmentRepository apartmentRepo;

  ApartmentBloc({
    @required this.apartmentRepo,
  })  : assert(apartmentRepo != null),
        super(List<ApartmentMessageModel>());

  @override
  Stream<List<ApartmentMessageModel>> mapEventToState(
      ApartmentEvent event) async* {
    try {
      if (event is GetAllApartment) {
        yield* _mapEventGetAllApartment(event);
      } else if (event is ApartmentLoadList) {
        yield* _mapEventGetList(event);
      }
    } catch (error) {
      print(error);
    }
  }

  Stream<List<ApartmentMessageModel>> _mapEventGetAllApartment(
      GetAllApartment event) async* {
    try {
      final buildingId = event.buildingId ?? Sqflite.currentBuildingID;

      final result = await apartmentRepo.getApartments(buildingId: buildingId);

      yield result;
    } catch (error) {
      yield error;
    }
  }

  Stream<List<ApartmentMessageModel>> _mapEventGetList(
      ApartmentEvent event) async* {
    try {
      final buildingId = Sqflite.currentBuildingID;
      final result = await apartmentRepo.getApartments(buildingId: buildingId);
      yield result;
    } catch (error) {
      yield error;
    }
  }
}

class ApartmentDetailBloc extends Bloc<ApartmentEvent, ApartmentState> {
  final ApartmentRepository apartmentRepo;

  ApartmentDetailBloc({
    @required this.apartmentRepo,
  })  : assert(apartmentRepo != null),
        super(ApartmentInitial());

  @override
  Stream<ApartmentState> mapEventToState(ApartmentEvent event) async* {
    if (event is ApartmentGetDetail) {
      yield ApartmentLoading();

      try {
        final result = await apartmentRepo.getApartmentByID(id: event.id);

        yield ApartmentGetDetailSuccessful(apartmentDetail: result);
      } on DioError catch (err) {
        yield ApartmentFailure(error: err);
      }
    }
  }
}
