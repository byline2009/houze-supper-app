import 'package:event_bus/event_bus.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'index.dart';

class AppController {
  late EventBus eventBus;
  //Singleton
  AppController._privateConstructor() {
    eventBus = EventBus();
  }

  static AppController _instance = AppController._privateConstructor();

  factory AppController() {
    return _instance == null ? AppController._privateConstructor() : _instance;
  }

  void updateEventDetail({
    required String eventID,
    required bool update,
  }) {
    if (update == true) {
      eventBus.fire(
        EventUpdateEventDetail(
          updated: update,
          eventID: eventID,
        ),
      );
    }
  }

  void updateEventItem({
    required EventModel eventModel,
  }) {
    if (eventModel.id != null) {
      eventBus.fire(
        EventUpdateEventItem(
          eventModel: eventModel,
        ),
      );
    }
  }

  void updateAvatarUser({
    required ImageModel image,
  }) {
    if (image.id != null) {
      Storage.saveAvatar(
        image.imageThumb!,
      );
      eventBus.fire(
        EventProfileUpdateAvatar(
          imageModel: image,
        ),
      );
    }
  }

  void updateOrderPage() {
    eventBus.fire(EventPaymentPay());
  }
}
