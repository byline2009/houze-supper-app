import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/middle/repo/point_transaction_repository.dart';
import 'package:houze_super/middle/repo/profile_repository.dart';
import 'index.dart';

class ProfileLoadPointBloc
    extends Bloc<ProfileLoadPointEvent, ProfileLoadPointState> {
  ProfileLoadPointBloc({
    this.profileRepo,
    this.pointRepo,
  }) : super(ProfileLoadPointState.initial());

  final ProfileRepository profileRepo;
  final PointTransationRepository pointRepo;

  @override
  Stream<ProfileLoadPointState> mapEventToState(
      ProfileLoadPointEvent event) async* {
    yield ProfileLoadPointState.loading();

    try {
      final ProfileModel result = await profileRepo.getProfile();
      final totalPoint = await pointRepo.getTotalPoint();
      yield ProfileLoadPointState.success(result, totalPoint);
    } catch (e) {
      yield ProfileLoadPointState.error(e.toString());
    }
  }
}
