import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/challenge_repository.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'index.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRepository repo;

  ChallengeBloc({
    required this.repo,
  }) : super(
          ChallengeInitial(),
        ) {
    on<EventLoadChallengeList>((event, emit) async {
      emit(StateLoadChallengeListLoading());
      try {
        final List<EventModel>? result = await getAllEventByBuildingID(
          event.buildingID,
        );
        emit(StateLoadChallengeListSuccessful(
          result: result,
        ));
      } catch (error) {
        emit(StateLoadChallengeListFailure(
          error: error.toString(),
        ));
      }
    });
  }

  Future<List<EventModel>> getAllEventByBuildingID(String buildingID) async {
    return await repo.getAllEvent(
      page: 0,
      buildingID: buildingID,
    );
  }
}
