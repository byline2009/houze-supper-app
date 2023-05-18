import 'package:flutter/foundation.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/repo/feed_repository.dart';

class FeedProvider with ChangeNotifier, DiagnosticableTreeMixin {
  // FeedMessageModel _feed;

  // FeedMessageModel get feed => _feed;

  // void tapToSeeDetail() async {
  //   if (_feed.isRead == false) {
  //     final feedRepository = FeedRepository();
  //     final result = await feedRepository.feedAPI.readFeed(id: _feed.id);
  //     if (result == true) {
  //       notifyListeners();
  //     }
  //   }
  // }

  /// Internal, private state of the cart.
  late FeedMessageModel _feed;

  /// An unmodifiable view of the items in the cart.
  FeedMessageModel get feed => _feed;

  /// The current total price of all items (assuming all items cost $42).
  bool? get isRead => _feed.isRead;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void tap(FeedMessageModel data) async {
    if (data.isRead == false) {
      final feedRepository = FeedRepository();
      final result = await feedRepository.feedAPI.readFeed(id: data.id!);
      if (result == true) {
        notifyListeners();
      }
    }
  }
}
