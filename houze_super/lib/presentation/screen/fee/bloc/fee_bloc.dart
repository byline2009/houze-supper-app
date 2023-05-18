import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/repo/fee_repository.dart';
import 'package:houze_super/presentation/screen/fee/bloc/index.dart';
import 'package:houze_super/utils/settings/fee.dart';
import 'package:houze_super/utils/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class FeeBloc extends Bloc<FeeEvent, FeeState> {
  FeeRepository feeRepository = new FeeRepository();
  FinanceModel financeModel = new FinanceModel();

  var lock = Lock();

  FeeBloc() : super(FeeInitial());

  @override
  Stream<FeeState> mapEventToState(FeeEvent event) async* {
    if (event is FeeLoadList) {
      yield FeeLoadListLoading();
      final buildingID = event.building ?? await Sqflite.getCurrentBuildingID();
      if (buildingID != null) {
        try {
          final result = await feeRepository.getFeesList(
              building: buildingID, apartment: event.apartment, status: 1);
          final feeListModel =
              await FeeSettings.sortFeeV2(buildingID, result, financeModel);
          yield FeeLoadListSuccessful(result: feeListModel);
        } catch (error) {
          yield FeeFailure(error: error);
        }
      }
    }

    if (event is FeeFilter) {
      yield FeeLoadListLoading();

      try {
        final building = event.building ?? await Sqflite.getCurrentBuildingID();
        final result = await feeRepository.getFeesListWithType(
            building: building,
            apartment: event.apartment,
            status: 1,
            types: event.types);
        yield FeeLoadListSuccessful(result: result);
      } catch (error) {
        yield FeeFailure(error: error);
      }
    }

    if (event is FeeChart) {
      yield FeeLoadListLoading();

      try {
        final feeList = await feeRepository.getFeeList(
          building: event.building,
          apartment: event.apartment,
          feeType: event.feeType,
          year: event.year,
          page: event.page,
        );

        final feeByMonths = await feeRepository.getFeeChart(
          building: event.building,
          apartment: event.apartment,
          feeType: event.feeType,
          year: event.year,
        );

        yield FeeByMonthGetSuccessful(
          feeList: feeList,
          feeByMonths: feeByMonths,
        );
      } catch (error) {
        yield FeeFailure(error: error);
      }
    }

    if (event is FeeLoadLimitList) {
      yield FeeLoadListLoading();

      try {
        final result = await feeRepository.getFeeLimitList(
          limit: event.limit,
          apartment: event.apartment,
          feeType: event.feeType,
          year: event.year,
          building: event.building,
        );

        yield FeeLoadDetailSuccessful(result: result);
      } catch (error) {
        yield FeeFailure(error: error);
      }
    }

    if (event is FeeDetailLoad) {
      var challengeState = await lock.synchronized(() async {
        var state = loadFeeDetail(event);
        return state;
      });

      await for (var value in challengeState) {
        yield value;
      }
    }
  }

  Stream<FeeState> loadFeeDetail(FeeDetailLoad event) async* {
    yield FeeLoadListLoading();

    try {
      final result = await feeRepository.getFees(
          building: event.building,
          apartment: event.apartment,
          status: 1,
          type: event.type);

      yield FeeLoadDetailSuccessful(result: result);
    } catch (error) {
      yield FeeFailure(error: error);
    }
  }
}
