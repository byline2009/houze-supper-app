import 'package:equatable/equatable.dart';

abstract class BuildingChangeEvent extends Equatable {
  BuildingChangeEvent([List props = const []]) : super();
}

class BuildingChangePicked extends BuildingChangeEvent {
  BuildingChangePicked() : super([]);

  @override
  List<Object> get props => [];
}
