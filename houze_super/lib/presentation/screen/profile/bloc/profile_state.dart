import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/profile_model.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final ProfileModel profile;
  final String error;

  const ProfileState({
    this.isLoading,
    this.profile,
    this.error,
  });

  bool get hasLoading => isLoading && error == null && profile == null;
  bool get isInitial => !isLoading && error == null && profile == null;
  bool get hasError => !isLoading && error != null && profile == null;
  bool get hasData => !isLoading && error == null && profile != null;

  factory ProfileState.initial() {
    return ProfileState(
      profile: null,
      isLoading: false,
      error: null,
    );
  }

  factory ProfileState.loading() {
    return ProfileState(
      profile: null,
      isLoading: true,
      error: null,
    );
  }

  factory ProfileState.success(
    ProfileModel profile,
  ) {
    return ProfileState(
      profile: profile,
      isLoading: false,
      error: null,
    );
  }

  factory ProfileState.error(String code) {
    return ProfileState(
      profile: null,
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
      return 'ProfileState paymeToken: ${profile.paymeToken.toString()}';
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
        isLoading,
        profile,
        error,
      ];
}
