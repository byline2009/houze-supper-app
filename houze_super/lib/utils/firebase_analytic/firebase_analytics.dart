import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class FBAnalytics {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  /*EVENTS */
  final String eventAppIconPick = 'event_app_icon_pick';

  /*PARAMS*/
  // ignore: non_constant_identifier_names
  final String PARAM_USER_ID = 'user_id';
  // ignore: non_constant_identifier_names
  final String PARAM_APP_ICON_ID = 'app_icon_id';

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /* User thay đổi app icon
    * Name: event_app_icon_pick
    * Type: In-app Event
    * params: {
      user_id: user id
      app_icon_id: app icon
    }
  */

  void sendEventAppIconPick({String userID, String appIconID}) {
    _analytics.logEvent(
        name: eventAppIconPick,
        parameters: {PARAM_USER_ID: userID, PARAM_APP_ICON_ID: appIconID});
    printLog(
        event: eventAppIconPick,
        param: {PARAM_USER_ID: userID, PARAM_APP_ICON_ID: appIconID});
  }

  void printLog({
    @required String event,
    Map<String, dynamic> param,
  }) {
    String log = '''[FBAnalytics] $event parameters: ${param.toString()}
    ''';
    print(log);
  }
}
