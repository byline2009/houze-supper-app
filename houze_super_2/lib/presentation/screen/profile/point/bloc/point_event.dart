import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PointEvent extends Equatable {
  PointEvent() : super();
}

class GetPointHistory extends PointEvent {
  final int? page;
  final String? action;
  final String? buildingId;
  final String? date;
  GetPointHistory({this.buildingId, this.action, this.page, this.date});

  @override
  String toString() =>
      'FacilityGetWorking { building_id: $buildingId, action: $action, date: $date }';

  @override
  List<Object> get props => [
        this.buildingId ?? '',
        this.action ?? '',
        this.page ?? '',
        this.date ?? ''
      ];
}
