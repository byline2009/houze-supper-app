part of 'houze_xu_bloc.dart';

abstract class HouzeXuState extends Equatable {
  const HouzeXuState();

  @override
  List<Object> get props => [];
}

class HouzeXuInitial extends HouzeXuState {}

class HouzeXuSuccessful extends HouzeXuState {
  final PointEarnModel houzeXu;

  HouzeXuSuccessful({@required this.houzeXu});
  @override
  List<Object> get props => [houzeXu];
  @override
  String toString() => 'HouzeXuSuccessful { houzeXu: $houzeXu }';
}

class HouzeXuFailure extends HouzeXuState {}

class HouzeXuLoading extends HouzeXuState {
  const HouzeXuLoading();

  @override
  List<Object> get props => [];
}
