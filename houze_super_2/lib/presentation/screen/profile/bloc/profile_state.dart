import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:houze_super/middle/model/houze_point/point_transaction_history_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';

@immutable
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  @override
  String toString() => 'ProfileInitial';

  @override
  List<Object> get props => [];
}

class ProfileLoadPointInitial extends ProfileState {
  @override
  String toString() => 'ProfileLoadPointInitial';

  @override
  List<Object> get props => [];
}

class ProfilePointLoading extends ProfileState {
  @override
  String toString() => 'ProfilePointLoading';
  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {
  @override
  String toString() => 'ProfileLoading';
  @override
  List<Object> get props => [];
}

class ProfileLoadSuccessful extends ProfileState {
  final ProfileModel profile;
  ProfileLoadSuccessful({
    required this.profile,
  });
  @override
  List<Object> get props => [
        profile,
      ];

  @override
  String toString() => 'ProfileLoadSuccessful { profile: $profile }';
}

class ProfilePointLoadSuccessful extends ProfileState {
  final ProfileModel profile;
  final TotalPointModel totalPointModel;
  ProfilePointLoadSuccessful({
    required this.profile,
    required this.totalPointModel,
  });
  @override
  List<Object> get props => [
        profile,
        totalPointModel,
      ];

  @override
  String toString() =>
      'ProfilePointLoadSuccessful { profile: ${profile.fullname}  amount: ${totalPointModel.amount}}';
}

class ProfileLoadFailure extends ProfileState {
  final String error;

  ProfileLoadFailure({required this.error});
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ProfileLoadFailure { error: $error }';
}

class ProfilePointLoadFailure extends ProfileState {
  final String error;

  ProfilePointLoadFailure({required this.error});
  @override
  List<Object> get props => [error];

  @override
  String toString() => 'ProfilePointLoadFailure { error: $error }';
}
