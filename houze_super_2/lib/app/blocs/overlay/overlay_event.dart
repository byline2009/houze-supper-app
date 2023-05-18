import 'package:equatable/equatable.dart';

abstract class OverlayBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BuildingPicked extends OverlayBlocEvent {
  BuildingPicked();

  @override
  List<Object> get props => [];
}
