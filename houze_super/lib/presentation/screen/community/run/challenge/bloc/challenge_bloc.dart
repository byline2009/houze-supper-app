import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/challenge_repository.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'challenge_state.dart';
import 'index.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRepository repo;

  ChallengeBloc({
    @required this.repo,
  }) : super(
          ChallengeInitial(),
        );

  @override
  Stream<ChallengeState> mapEventToState(ChallengeEvent event) async* {
    if (event is EventLoadChallengeList) {
      yield StateLoadChallengeListLoading();
      try {
        final result = await getAllEventByBuildingID(
          event.buildingID,
        );
        yield StateLoadChallengeListSuccessful(
          result: result,
        );
      } catch (error) {
        yield StateLoadChallengeListFailure(
          error: error.toString(),
        );
      }
    }
  }

  Future<List<EventModel>> getAllEventByBuildingID(String buildingID) async {
    return await repo.getAllEvent(
      page: 0,
      buildingID: buildingID,
    );
  }
}
