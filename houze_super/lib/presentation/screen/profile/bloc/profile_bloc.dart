import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/middle/repo/profile_repository.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_event.dart';

import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileLoadEvent, ProfileState> {
  ProfileBloc({
    @required this.profileRepo,
  }) : super(ProfileState.initial());

  final ProfileRepository profileRepo;

  @override
  Stream<ProfileState> mapEventToState(ProfileLoadEvent event) async* {
    yield ProfileState.loading();

    try {
      final ProfileModel result = await profileRepo.getProfile();
      yield ProfileState.success(
        result,
      );
    } catch (e) {
      yield ProfileState.error(e.toString());
    }
  }
}
