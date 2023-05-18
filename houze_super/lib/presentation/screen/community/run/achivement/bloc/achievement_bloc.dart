import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/achievement_repo.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/model/achievement_user_model.dart';

import 'achievement_event.dart';
import 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final AchievementRepository repo;

  AchievementBloc({@required this.repo}) : super(AchievementInitial());

  @override
  Stream<AchievementState> mapEventToState(AchievementEvent event) async* {
    if (event is AchievementsLoaded) {
      yield* _mapAchievementsLoadedToState(event);
    }
  }

  Stream<AchievementState> _mapAchievementsLoadedToState(
      AchievementsLoaded event) async* {
    try {
      final List<AchievementUserModel> results = await getAllAchievementUser();
      yield AchievementsLoadSuccess(results);
    } catch (_) {
      yield AchievementLoadFailure();
    }
  }

  Future<List<AchievementUserModel>> getAllAchievementUser() async {
    return await this.repo.getAllAchievementUser(
          page: 0,
        );
  }
}
