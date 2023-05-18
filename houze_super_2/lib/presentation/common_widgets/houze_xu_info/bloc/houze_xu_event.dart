part of 'houze_xu_bloc.dart';

abstract class HouzeXuEvent extends Equatable {
  const HouzeXuEvent();

  @override
  List<Object> get props => [];
}

class GetHouzeXu extends HouzeXuEvent {
  final String buildingId;

  GetHouzeXu({required this.buildingId});
  @override
  List<Object> get props => [buildingId];
  @override
  String toString() => 'HouzeXuSuccessful { buildingId: $buildingId }';
}
