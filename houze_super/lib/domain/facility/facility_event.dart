import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FacilityEvent extends Equatable {
  FacilityEvent([List props = const []]) : super();
}

class FacilityGetDetailEvent extends FacilityEvent {
  final String id;

  FacilityGetDetailEvent({@required this.id}) : super(['']);
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'FacilityGetDetailEvent { id: $id }';
}

class FacilityGetBookingDetailEvent extends FacilityEvent {
  final String id;

  FacilityGetBookingDetailEvent({@required this.id}) : super(['']);
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'FacilityGetBookingDetailEvent { id: $id }';
}

class FacilityGetHistoryEvent extends FacilityEvent {
  final String id;

  FacilityGetHistoryEvent({this.id}) : super([id]);
  @override
  List<Object> get props => [id];
  @override
  String toString() => 'FacilityGetHistoryEvent { id: $id }';
}

class FacilityGetBookingHistoryEvent extends FacilityEvent {
  final int status;
  final int page;

  FacilityGetBookingHistoryEvent({@required this.page, this.status});
  @override
  List<Object> get props => [this.page, this.status];
  @override
  String toString() =>
      'FacilityGetBookingHistoryEvent {page: $page, status: $status}';
}

class FacilityGetHistoryPager extends FacilityEvent {
  final int page;
  final int status;
  final String facilityId;

  FacilityGetHistoryPager({this.page, this.status, @required this.facilityId})
      : super([page, status, facilityId]);
  @override
  List<Object> get props => [page, status, facilityId];
  @override
  String toString() =>
      'FacilityGetHistory { page: $page, facility_id: $facilityId, status: $status }';
}

class FacilityGetWorking extends FacilityEvent {
  final String id;
  final String date;

  FacilityGetWorking({@required this.id, @required this.date}) : super([id]);
  @override
  List<Object> get props => [id, date];
  @override
  String toString() => 'FacilityGetWorking { id: $id, date: $date }';
}

class FacilityGetSlot extends FacilityEvent {
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

class UserTapOnInvalidDate extends FacilityEvent {
  UserTapOnInvalidDate() : super([]);
  @override
  List<Object> get props => [];
}
