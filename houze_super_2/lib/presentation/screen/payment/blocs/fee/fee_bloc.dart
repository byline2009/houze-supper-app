import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/repo/fee_repository.dart';
import 'index.dart';
import 'package:houze_super/utils/settings/fee.dart';
import 'package:houze_super/utils/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class FeeBloc extends Bloc<FeeEvent, FeeState> {
  FeeRepository feeRepository = new FeeRepository();
  FinanceModel financeModel = new FinanceModel();

  var lock = Lock();

  FeeBloc() : super(FeeInitial()) {
    on<FeeLoadList>((event, emit) async {
      emit(FeeLoadListLoading());
      String buildingID = event.buildingID;
      if (buildingID.isEmpty) {
        buildingID = Sqflite.currentBuildingID;
      }

      try {
        final result = await feeRepository.getFeesList(
          building: buildingID,
          apartment: event.apartmentID,
          status: 1,
        );
        final feeListModel = await FeeSettings.sortFeeV2(
          buildingID,
          result,
          financeModel,
        );

        emit(FeeLoadListSuccessful(
          result: feeListModel,
        ));
      } catch (error) {
        emit(FeeFailure(error: error));
      }
    });

    on<FeeChart>((event, emit) async {
      emit(FeeLoadListLoading());

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

        emit(FeeByMonthGetSuccessful(
          feeList: feeList,
          feeByMonths: feeByMonths,
        ));
      } catch (error) {
        emit(FeeFailure(error: error));
      }
    });
    on<FeeLoadLimitList>((event, emit) async {
      emit(FeeLoadListLoading());

      try {
        final result = await feeRepository.getFeeLimitList(
          limit: event.limit,
          apartment: event.apartment,
          feeType: event.feeType,
          year: event.year,
          building: event.building,
        );

        emit(FeeLoadDetailSuccessful(results: result));
      } catch (error) {
        emit(FeeFailure(error: error));
      }
    });
  }
}
