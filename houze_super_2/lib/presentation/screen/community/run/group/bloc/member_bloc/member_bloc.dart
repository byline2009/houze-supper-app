
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/presentation/screen/community/run/group/bloc/member_bloc/member_state.dart';
import 'package:houze_super/presentation/screen/community/run/group/model/request_model.dart';

import 'member_event.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final GroupRepository groupRepository;
  MemberBloc({
    required this.groupRepository,
  }) : super(
          MemberInitial(),
        ) {
    on<GroupLoadMembersRequestJoinTeam>((event, emit) async {
      emit(MemberLoading());
      try {
        final List<RequestModel>? result =
            await groupRepository.getEventsRequest(
          groupID: event.groupID,
        );
        emit(GroupLoadMembersRequestJoinTeamSuccessful(
          result: result,
        ));
      } catch (error) {
        emit(GroupLoadMembersRequestJoinTeamFailure(
          error: error.toString(),
        ));
      }
    });
  }
}
