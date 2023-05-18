import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/repo/fee_repository.dart';
import 'package:houze_super/utils/settings/fee.dart';
import 'package:houze_super/utils/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'index.dart';

class FeeInfoBloc extends Bloc<FeeInfoEvent, FeeInfoState> {
  FeeRepository feeRepository = new FeeRepository();
  FinanceModel financeModel = new FinanceModel();

  var lock = Lock();

  FeeInfoBloc() : super(FeeInfoInitial()) {
    on<FeeLoadList>((event, emit) async {
      emit(FeeInfoLoadListLoading());
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
        emit(FeeInfoLoadListSuccessful(result: feeListModel));
      } catch (error) {
        emit(FeeInfoFailure(error: error));
      }
    });

    on<FeeFilter>((event, emit) async {
      emit(FeeInfoLoadListLoading());

      try {
        final building = event.building;
        final result = await feeRepository.getFeesListWithType(
            building: building,
            apartment: event.apartment,
            status: 1,
            types: event.types);
        emit(FeeInfoLoadListSuccessful(result: result));
      } catch (error) {
        emit(FeeInfoFailure(error: error));
      }
    });
    on<FeeChart>((event, emit) async {
      emit(FeeInfoLoadListLoading());

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

        emit(FeeInfoByMonthGetSuccessful(
          feeList: feeList,
          feeByMonths: feeByMonths,
        ));
      } catch (error) {
        emit(FeeInfoFailure(error: error));
      }
    });
    on<FeeLoadLimitList>((event, emit) async {
      emit(FeeInfoLoadListLoading());

      try {
        final result = await feeRepository.getFeeLimitList(
          limit: event.limit,
          apartment: event.apartment,
          feeType: event.feeType,
          year: event.year,
          building: event.building,
        );

        emit(FeeInfoLoadDetailSuccessful(result: result));
      } catch (error) {
        emit(FeeInfoFailure(error: error));
      }
    });
    on<FeeDetailLoad>((event, emit) async {
      var eventState = await lock.synchronized(() async {
        emit(FeeInfoLoadListLoading());

        try {
          final result = await feeRepository.getFees(
            page: 1,
            building: event.building,
            apartment: event.apartment,
            status: 1,
            type: event.type,
          );

          emit(FeeInfoLoadDetailSuccessful(result: result));
        } catch (error) {
          emit(FeeInfoFailure(error: error));
        }
      });

      await for (FeeInfoState value in eventState) {
        emit(value);
      }
    });
  }
}
