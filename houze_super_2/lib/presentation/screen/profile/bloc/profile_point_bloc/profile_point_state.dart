import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/houze_point/point_transaction_history_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';

class ProfileLoadPointState extends Equatable {
  final bool? isLoading;
  final ProfileModel? profile;
  final TotalPointModel? totalPoint;
  final String? error;

  const ProfileLoadPointState({
    this.isLoading,
    this.profile,
    this.totalPoint,
    this.error,
  });

  bool get hasLoading =>
      isLoading == true &&
      error == null &&
      profile == null &&
      totalPoint == null;
  bool get isInitial =>
      isLoading == false &&
      error == null &&
      profile == null &&
      totalPoint == null;
  bool get hasError =>
      isLoading == false &&
      error != null &&
      profile == null &&
      totalPoint == null;
  bool get hasData =>
      isLoading == false &&
      error == null &&
      profile != null &&
      totalPoint != null;

  factory ProfileLoadPointState.initial() {
    return ProfileLoadPointState(
      profile: null,
      totalPoint: null,
      isLoading: false,
      error: null,
    );
  }

  factory ProfileLoadPointState.loading() {
    return ProfileLoadPointState(
      profile: null,
      totalPoint: null,
      isLoading: true,
      error: null,
    );
  }

  factory ProfileLoadPointState.success(
    ProfileModel profile,
    TotalPointModel totalPoint,
  ) {
    return ProfileLoadPointState(
      profile: profile,
      totalPoint: totalPoint,
      isLoading: false,
      error: null,
    );
  }

  factory ProfileLoadPointState.error(String code) {
    return ProfileLoadPointState(
      profile: null,
      totalPoint: null,
      isLoading: false,
      error: code,
    );
  }

  @override
  String toString() {
    if (isInitial) {
      return 'ProfileState initial';
    }
    if (hasData) {
      return 'ProfileState {profile: ${profile!.paymeToken?.toString()} totalPoint: $totalPoint}';
    }
    if (hasLoading) {
      return 'ProfileState is loading';
    }

    if (hasError) {
      return 'ProfileState has error $error';
    }
    return '';
  }

  @override
  List<Object> get props => [
        isLoading ?? false,
        profile ?? '',
        totalPoint ?? '',
        error ?? '',
      ];
}
