import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/middle/repo/parking_repo.dart';
import 'package:houze_super/presentation/screen/parking/bloc/parking_event.dart';
import 'package:houze_super/presentation/screen/parking/bloc/parking_state.dart';
import 'package:houze_super/utils/sqflite.dart';

class ParkingVehicleBloc
    extends Bloc<ParkingVehicleEvent, ParkingVehicleState> {
  final ParkingRepo _repo = ParkingRepo();

  ParkingVehicleBloc() : super(ParkingVehicleInitial());

  @override
  Stream<ParkingVehicleState> mapEventToState(
      ParkingVehicleEvent event) async* {
    if (event is ParkingVehicleGetList) {
      yield ParkingVehicleLoading();

      try {
        final buildingId = Sqflite.currentBuildingID;

        final result = await _repo.getParkingVehicle(
            buildingId: buildingId, aparmentId: event.params["apartment_id"]);

        final List<ParkingVehicle> parkingVehicles = (result.results as List)
            .map((e) => ParkingVehicle.fromJson(e))
            .toList();

        yield ParkingVehicleGetListSuccessful(parkingVehicles: parkingVehicles);
      } catch (error) {
        yield ParkingVehicleGetListFailure(error: error);
      }
    }
  }
}

class ParkingHistoryBookingBloc
    extends Bloc<ParkingHistoryBookingEvent, ParkingHistoryBookingState> {
  final ParkingRepo _repo = ParkingRepo();

  ParkingHistoryBookingBloc() : super(ParkingHistoryBookingInitial());

  @override
  Stream<ParkingHistoryBookingState> mapEventToState(
      ParkingHistoryBookingEvent event) async* {
    if (event is ParkingHistoryBookingGetList) {
      yield ParkingHistoryBookingLoading();

      try {
        final buildingId = Sqflite.currentBuildingID;

        final result = await _repo.getParkingHistoryBooking(
            buildingId: buildingId, apartmentId: event.params["apartment_id"]);

        final List<ParkingVehicle> parkingBookingHistories =
            (result.results as List)
                .map((e) => ParkingVehicle.fromJson(e))
                .toList();

        yield ParkingHistoryBookingGetListSuccessful(
            parkingBookingHistories: parkingBookingHistories);
      } catch (error) {
        yield ParkingHistoryBookingGetListFailure(error: error);
      }
    }
  }
}

class ParkingListBloc extends Bloc<ParkingEvent, ParkingState> {
  ParkingRepo _repo = ParkingRepo();

  ParkingListBloc() : super(ParkingListInitial());

  @override
  Stream<ParkingState> mapEventToState(ParkingEvent event) async* {
    if (event is ParkingGetList) {
      yield ParkingListLoading();

      print("event: ParkingLoadList");
      try {
        final buildingId = Sqflite.currentBuildingID;

        final result = await _repo.getParkingList(buildingId: buildingId);

        yield ParkingGetListSuccessful(result: result);
      } catch (error) {
        yield ParkingGetListFailure(error: error);
      }
    }
  }
}
