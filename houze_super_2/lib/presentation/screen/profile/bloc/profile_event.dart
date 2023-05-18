import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileLoad extends ProfileEvent {
  ProfileLoad();

  @override
  String toString() => 'ProfileLoad {}';

  @override
  List<Object> get props => [];
}

class ProfileLoadPoint extends ProfileEvent {
  ProfileLoadPoint();

  @override
  String toString() => 'ProfileLoadPoint {}';

  @override
  List<Object> get props => [];
}

class ProfileUpdated extends ProfileEvent {
  ProfileUpdated();

  @override
  String toString() => 'ProfileUpdated { }';

  @override
  List<Object> get props => [];
}
