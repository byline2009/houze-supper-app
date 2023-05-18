import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/fee/fee_model.dart';
import 'package:houze_super/middle/repo/fee_repository.dart';
import 'package:houze_super/presentation/index.dart';

import 'fee_v1_event.dart';

class FeeV1State {
  bool isLoading = false;
  List<FeeGroupByApartments> feeGroupByApartments =
      List<FeeGroupByApartments>();

  FeeV1State({this.isLoading = false, this.feeGroupByApartments});
}

class FeeGroupApartmentBloc extends Bloc<FeeV1Event, FeeV1State> {
  final feeRepository = FeeRepository();

  FeeGroupApartmentBloc() : super(FeeV1State(isLoading: false));

  @override
  Stream<FeeV1State> mapEventToState(event) async* {
    if (event is GetFeeGroupApartment) {
      yield FeeV1State(isLoading: true);
      try {
        final results = await feeRepository.getFeeGroupByApartment();
        for (var i = 0; i < results.length; i++) {
          final element = results[i];
          final availableFee =
              await Sqflite.getBuildingWithId(element.buildingId);
          results[i].feeAvailable = availableFee.feeDisplay;
        }
        yield FeeV1State(isLoading: false, feeGroupByApartments: results);
      } catch (e) {
        throw e;
      }
    }
  }
}
