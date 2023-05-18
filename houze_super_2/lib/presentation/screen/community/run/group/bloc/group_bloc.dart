
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/middle/repo/challenge_repository.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'package:houze_super/presentation/screen/community/run/group/model/group_model.dart';

import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupRepository groupRepository;
  final ChallengeRepository challengeRepository;
  GroupBloc({
    required this.groupRepository,
    required this.challengeRepository,
  }) : super(
          GroupInitial(),
        ) {
    on<EventLoadGroupDetail>((event, emit) async {
      emit(GroupLoading());
      try {
        final EventModel? eventModel = await challengeRepository.getEventDetail(
          id: event.eventID,
        );
        final List<GroupModel>? groups = await groupRepository.getAllGroup(
          page: 0,
          eventID: event.eventID,
        );

        emit(StateLoadEventDetailSuccessful(
          eventModel: eventModel,
          groups: groups,
        ));
      } catch (error) {
        emit(StateLoadEventDetailFailure(
          error: error.toString(),
        ));
      }
    });
  }
}
