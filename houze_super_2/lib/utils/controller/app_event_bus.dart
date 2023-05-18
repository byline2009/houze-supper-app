import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';

abstract class EventAppController extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventUpdateEventDetail extends EventAppController {
  final bool updated;
  final String eventID;

  EventUpdateEventDetail({
    required this.updated,
    required this.eventID,
  });

  @override
  List<Object> get props => [
        updated,
        eventID,
      ];
}

class EventUpdateEventItem extends EventAppController {
  final EventModel eventModel;

  EventUpdateEventItem({
    required this.eventModel,
  });

  @override
  List<Object> get props => [
        eventModel,
      ];
}

class EventProfileUpdateAvatar extends EventAppController {
  final ImageModel imageModel;

  EventProfileUpdateAvatar({
    required this.imageModel,
  });

  @override
  List<Object> get props => [
        imageModel,
      ];
}

class EventPaymentPay extends EventAppController {
  EventPaymentPay();

  @override
  List<Object> get props => [];
}
