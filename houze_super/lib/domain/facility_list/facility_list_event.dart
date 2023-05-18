import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class FacilityListEvent extends Equatable {
  FacilityListEvent([List props = const []]) : super();
}

class FacilityHistoryLoadList extends FacilityListEvent {
  final int page;
  final String id;

  FacilityHistoryLoadList({this.page, this.id = ""}) : super([page]);

  @override
  String toString() => 'FacilityHistoryLoadList { page: $page, id: $id }';

  @override
  List<Object> get props => [];
}

class FacilityTypeLoadList extends FacilityListEvent {
  FacilityTypeLoadList() : super([]);
  @override
  List<Object> get props => [];
}

class FacilityGetWorking extends FacilityListEvent {
  final String id;
  final String date;

  FacilityGetWorking({
    @required this.id,
    @required this.date,
  }) : super([id]);

  @override
  String toString() => 'FacilityGetWorking { id: $id, date: $date }';
  @override
  List<Object> get props => [];
}

class FacilityGetSlot extends FacilityListEvent {
  final String id;
  final String date;
  final String startTime;
  final String endTime;

  FacilityGetSlot({
    @required this.id,
    @required this.date,
    @required this.startTime,
    @required this.endTime,
  }) : super([id]);
  @override
  List<Object> get props => [
        this.id,
        this.date,
        this.startTime,
        this.endTime,
      ];
  @override
  String toString() =>
      'FacilityGetSlot { id: $id, date: $date, start_time: $startTime, end_time: $endTime }';
}

class FacilityGetBookingDetail extends FacilityListEvent {
  final String id;

  FacilityGetBookingDetail({
    @required this.id,
  }) : super([id]);
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'FacilityGetBookingDetail { id: $id }';
}
