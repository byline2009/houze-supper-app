import 'package:event_bus/event_bus.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/repo/feed_repository.dart';

import 'index.dart';

class MailBoxController {
  static EventBus eventBus = EventBus();

  //Singleton
  MailBoxController._privateConstructor();

  factory MailBoxController() {
    return MailBoxController._privateConstructor();
  }

  /*
   * Event: Đã đọc phản ánh
   */
  Future<void> readFeed(FeedMessageModel feed) async {
    if (feed.isRead == false) {
      final feedRepository = FeedRepository();
      final rs = await feedRepository.feedAPI.readFeed(id: feed.id!);
      feed.isRead = rs;

      eventBus.fire(
        EventReadFeed(
          feed: feed,
        ),
      );

      print(
          '[*** MailBoxController] readFeed: title: ${feed.title} id: ${feed.id}');
    }
  }
}
