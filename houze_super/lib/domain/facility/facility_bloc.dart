import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

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
  FacilityBloc() : super(FacilityInitial());

  @override
  Stream<FacilityState> mapEventToState(
    FacilityEvent event,
  ) async* {
    if (event is FacilityGetDetailEvent) {
      yield* _mapFacilityGetDetailEventToState(event.id);
    }

    /* Load lịch sử dky */
    if (event is FacilityGetHistoryEvent) {
      yield* _mapFacilityGetHistoryEventToState(event.id);
    }

    if (event is FacilityGetBookingHistoryEvent) {
      yield* _mapFacilityGetBookingHistoryEventToState(
        page: event.page,
        status: event.status,
      );
    }

    /* Load facility đã đăng ký */
    if (event is FacilityGetBookingDetailEvent) {
      yield* _mapFacilityGetBookingDetailEventToState(event.id);
    }

    if (event is FacilityGetWorking) {
      yield* _mapFacilityGetWorkingEventToState(event.id, event.date);
    }

    if (event is FacilityGetSlot) {
      yield* _mapFacilityGetSlotEventToState(event);
    }

    if (event is UserTapOnInvalidDate) {
      yield GetFacilityDayoff(description: "this_facility_is_this_today");
    }
  }

  Stream<FacilityState> _mapFacilityGetWorkingEventToState(
      String id, String date) async* {
    yield FacilityLoadHistoriesInProgress();
    var dayoff = await repo.getFacilityDayoff(id: id, date: date);
    if (dayoff != null) {
      yield GetFacilityDayoff(description: dayoff.description);
    } else {
      CitizenJsonModel rs = await repo.getFacilityWorking(id: id, date: date);
      final list = rs.citizenJson.map((e) => e).toList();
      yield GetFacilityWorkingSuccess(result: list);
    }
  }

  Stream<FacilityState> _mapFacilityGetSlotEventToState(
      FacilityGetSlot event) async* {
    yield FacilityLoadHistoriesInProgress();
    var rs = await repo.getFacilitySlot(
        id: event.id,
        date: event.date,
        startTime: event.startTime,
        endTime: event.endTime);
    final list = rs.citizenJson.map((e) => e).toList();
    yield GetFacilitySlot(result: list, params: {
      "start_time": event.startTime,
      "end_time": event.endTime,
    });
  }

  Stream<FacilityState> _mapFacilityGetHistoryEventToState(String id) async* {
    yield FacilityLoadHistoriesInProgress();
    try {
      var rs = await repo.getHistories(id);
      yield FacilityLoadHistoriesSuccess(rs);
    } catch (error) {
      yield FacilityFailureState(error.toString());
    }
  }

  Stream<FacilityState> _mapFacilityGetBookingHistoryEventToState(
      {@required int page, int status}) async* {
    yield FacilityLoadHistoriesInProgress();
    try {
      var rs = await repo.getBookingHistory(page: page, status: status);
      yield FacilityLoadHistoriesSuccess(rs);
    } catch (error) {
      yield FacilityFailureState(error.toString());
    }
  }

  FacilityDetailModel getFacilityDetailModel(FacilityState state) {
    if (state is GetFacilityDetailSuccess) {
      return state.result;
    }

    return null;
  }

  Stream<FacilityState> _mapFacilityGetDetailEventToState(String id) async* {
    yield FacilityLoadingInProgress();
    try {
      var rs = await repo.getFacilityDetail(id: id);
      yield GetFacilityDetailSuccess(rs);
    } catch (error) {
      yield FacilityFailureState(error);
    }
  }

  Stream<FacilityState> _mapFacilityGetBookingDetailEventToState(
      String id) async* {
    yield FacilityLoadingInProgress();
    try {
      var rs = await repo.getFacilityBookingDetail(id: id);
      yield GetFacilityBookingDetailSuccess(rs);
    } catch (error) {
      yield FacilityFailureState(error);
    }
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
