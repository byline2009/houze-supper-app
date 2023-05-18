import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:houze_super/middle/model/houze_point/point_transaction_history_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/middle/repo/point_transaction_repository.dart';
import 'package:houze_super/middle/repo/profile_repository.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_event.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final repo = ProfileRepository();

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileLoad>((event, emit) async {
      emit(ProfileLoading());
      print("event: ProfileLoadList");
      try {
        final result = await repo.getProfile();
        emit(ProfileLoadSuccessful(profile: result));
      } on DioError catch (error) {
        emit(ProfileLoadFailure(error: error.type.toString()));
      }
    });
  }
}

class ProfilePointBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepo;
  final PointTransationRepository pointRepo;
  ProfileModel? profileCache;
  late TotalPointModel totalPointModelCache;

  ProfilePointBloc({
    required this.profileRepo,
    required this.pointRepo,
  }) : super(ProfileLoadPointInitial()) {
    on<ProfileLoadPoint>((event, emit) async {
      emit(ProfilePointLoading());
      if (profileCache != null) {
        emit(ProfilePointLoadSuccessful(
          profile: profileCache!,
          totalPointModel: totalPointModelCache,
        ));
        return;
      }

      try {
        final List<dynamic> response = await Future.wait([
          profileRepo.getProfile(),
          pointRepo.getTotalPoint(),
        ]);
        // final result = await profileRepo.getProfile();
        profileCache = response[0];

        // final totalPoint = await pointRepo.getTotalPoint();
        totalPointModelCache = response[1];

        emit(ProfilePointLoadSuccessful(
          profile: response[0],
          totalPointModel: response[1],
        ));
      } on DioError catch (error) {
        print(error);
        emit(ProfileLoadFailure(
          error: error.error,
        ));
      }
    });
  }
}
