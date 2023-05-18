import 'package:bloc/bloc.dart';
import 'package:houze_super/domain/facility/facility_event.dart';
import 'package:houze_super/domain/facility/facility_state.dart';
import 'package:houze_super/middle/model/citizen_json_model.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/middle/repo/facility_repository.dart';

/*
  Facility general
*/
class FacilityBloc extends Bloc<FacilityEvent, FacilityState> {
  final repo = FacilityRepository();
  FacilityBloc() : super(FacilityInitial()) {
    on<FacilityGetDetailEvent>((event, emit) async {
      emit(FacilityLoadingInProgress());
      try {
        var rs = await repo.getFacilityDetail(id: event.id);
        emit(GetFacilityDetailSuccess(result: rs));
      } catch (error) {
        emit(FacilityFailureState(error));
      }
    });
    on<FacilityGetHistoryEvent>((event, emit) async {
      emit(FacilityLoadHistoriesInProgress());
      try {
        var rs = await repo.getHistories(event.id);
        emit(FacilityLoadHistoriesSuccess(rs!));
      } catch (error) {
        emit(FacilityFailureState(error.toString()));
      }
    });
    on<FacilityGetBookingHistoryEvent>((event, emit) async {
      emit(FacilityLoadHistoriesInProgress());
      try {
        var rs = await repo.getBookingHistory(
            page: event.page, status: event.status);
        emit(FacilityLoadHistoriesSuccess(rs!));
      } catch (error) {
        emit(FacilityFailureState(error.toString()));
      }
    });
    on<FacilityGetBookingDetailEvent>((event, emit) async {
      emit(FacilityLoadingInProgress());
      try {
        var rs = await repo.getFacilityBookingDetail(id: event.id);
        emit(GetFacilityBookingDetailSuccess(result: rs));
      } catch (error) {
        emit(FacilityFailureState(error));
      }
    });
    on<FacilityGetWorking>((event, emit) async {
      emit(FacilityLoadHistoriesInProgress());
      var dayoff = await repo.getFacilityDayoff(id: event.id, date: event.date);
      if (dayoff != null) {
        emit(GetFacilityDayoff(description: dayoff.description));
      } else {
        CitizenJsonModel rs =
            await repo.getFacilityWorking(id: event.id, date: event.date);
        final list = rs.citizenJson!.map((e) => e).toList();
        emit(GetFacilityWorkingSuccess(result: list));
      }
    });
    on<FacilityGetSlot>((event, emit) async {
      emit(FacilityLoadingInProgress());
      var rs = await repo.getFacilitySlot(
          id: event.id,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime);
      final list = rs.citizenJson!.map((e) => e).toList();
      emit(GetFacilitySlot(result: list, params: {
        "start_time": event.startTime,
        "end_time": event.endTime,
      }));
    });

    on<UserTapOnInvalidDate>((event, emit) async {
      emit(GetFacilityDayoff(description: ""));
    });
  }

  FacilityDetailModel? getFacilityDetailModel(FacilityState state) {
    if (state is GetFacilityDetailSuccess) {
      return state.result;
    }

    return null;
  }

  List<FacilitySlotModel> getFacilitySlot(FacilityState state) {
    if (state is GetFacilitySlot) {
      return state.result;
    }

    return [];
  }

  dynamic getFacilitySlotParams(FacilityState state) {
    if (state is GetFacilitySlot) {
      return state.params;
    }

    return null;
  }
}
