import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/middle/repo/point_transaction_repository.dart';
import 'package:houze_super/middle/repo/profile_repository.dart';
import 'index.dart';

class ProfileLoadPointBloc
    extends Bloc<ProfileLoadPointEvent, ProfileLoadPointState> {
  ProfileLoadPointBloc({
    required this.profileRepo,
    required this.pointRepo,
  }) : super(ProfileLoadPointState.initial()) {
    on<ProfileLoadPointEvent>((event, emit) async {
      emit(ProfileLoadPointState.loading());

      try {
        final ProfileModel result = await profileRepo.getProfile();
        final totalPoint = await pointRepo.getTotalPoint();
        emit(ProfileLoadPointState.success(result, totalPoint!));
      } catch (e) {
        emit(ProfileLoadPointState.error(e.toString()));
      }
    });
  }

  final ProfileRepository profileRepo;
  final PointTransationRepository pointRepo;
}
