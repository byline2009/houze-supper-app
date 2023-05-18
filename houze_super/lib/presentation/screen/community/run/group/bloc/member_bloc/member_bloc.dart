import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/presentation/screen/community/run/group/bloc/member_bloc/member_state.dart';

import 'member_event.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final GroupRepository groupRepository;
  MemberBloc({
    @required this.groupRepository,
  }) : super(
          MemberInitial(),
        );

  @override
  Stream<MemberState> mapEventToState(MemberEvent event) async* {
    if (event is GroupLoadMembersRequestJoinTeam) {
      print("event: GroupLoadMembersRequestJoinTeam");

      yield MemberLoading();
      try {
        final result = await groupRepository.getEventsRequest(
          groupID: event.groupID,
        );
        yield GroupLoadMembersRequestJoinTeamSuccessful(
          result: result,
        );
      } catch (error) {
        yield GroupLoadMembersRequestJoinTeamFailure(
          error: error.toString(),
        );
      }
    }
  }
}
