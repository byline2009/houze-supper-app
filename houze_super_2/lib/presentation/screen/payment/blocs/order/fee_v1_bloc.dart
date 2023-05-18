import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';
import 'package:houze_super/presentation/index.dart';

import 'fee_v1_event.dart';
import 'fee_v1_state.dart';

class FeeGroupApartmentBloc extends Bloc<FeeV1Event, FeeV1State> {
  final PaymentRepository _repository;

  FeeGroupApartmentBloc({required PaymentRepository repo})
      : _repository = repo,
        super(FeeV1State()) {
    on<GetFeeGroupApartment>((event, emit) async {
      // emit(FeeV1State(isLoading: true));
      try {
        emit(state.copyWith(status: FeeV1Status.loading));

        final results = await _repository.getFeeGroupByApartment();
        for (var i = 0; i < results.length; i++) {
          final element = results[i];
          final availableFee =
              await Sqflite.getBuildingWithId(element.buildingId!);
          results[i].feeAvailable = availableFee!.feeDisplay;
        }
        // final building = (await Sqflite.getBuildingList());
        // List<String> _buildingNameFromSql = [];
        // for (int i = 0; i < building.length; i++) {
        //   _buildingNameFromSql.add(building[i].name!);
        // }
        // for (int i = 0; i < results.length; i++) {
        //   if (!_buildingNameFromSql.contains(results[i].buildingName!)) {
        //     results.removeAt(i);
        //   }
        // }

        // for (var i = 0; i < results.length; i++) {
        //   final element = results[i];
        //   final availableFee =
        //       await Sqflite.getBuildingWithId(element.buildingId!);
        //   results[i].feeAvailable = availableFee!.feeDisplay;
        // }
        // emit(FeeV1State(isLoading: false, feeGroupByApartments: results));

        emit(state.copyWith(
          status: FeeV1Status.success,
          feeGroupByApartments: results,
        ));
      } catch (e) {
        // throw e;
        emit(state.copyWith(
          status: FeeV1Status.error,
        ));
      }
    });
  }
}
