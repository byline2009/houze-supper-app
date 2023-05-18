import 'package:equatable/equatable.dart';

abstract class FacilityListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FacilityHistoryLoadList extends FacilityListEvent {
  final int? page;
  final String id;

  FacilityHistoryLoadList({this.page, this.id = ""});

  @override
  String toString() => 'FacilityHistoryLoadList { page: $page, id: $id }';

  @override
  List<Object> get props => [];
}

class FacilityTypeLoadList extends FacilityListEvent {
  FacilityTypeLoadList();
  @override
  List<Object> get props => [];
}

class FacilityGetWorking extends FacilityListEvent {
  final String id;
  final String date;

  FacilityGetWorking({
    required this.id,
    required this.date,
  });

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
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
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
    required this.id,
  });
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'FacilityGetBookingDetail { id: $id }';
}
