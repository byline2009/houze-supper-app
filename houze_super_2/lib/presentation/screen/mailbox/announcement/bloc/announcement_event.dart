part of 'announcement_bloc.dart';

abstract class AnnouncementEvent extends Equatable {
  const AnnouncementEvent();

  @override
  List<Object> get props => [];
}

class AnnouncementFetched extends AnnouncementEvent {
  final String type;
  final String tag;
  final String time;
  final String buildingID;
  final int page;
  final bool? isRead;

  AnnouncementFetched({
    required this.type,
    required this.buildingID,
    required this.page,
    required this.time,
    required this.tag,
    required this.isRead,
  });
  @override
  String toString() {
    return 'AnnouncementFetched isRead: $isRead page=$page type=$type time=$time buildingID=$buildingID tag=$tag';
  }

  @override
  List<Object> get props => [
        type,
        buildingID,
        page,
        time,
        tag,
        isRead ?? false,
      ];
}
