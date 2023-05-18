import 'package:firebase_analytics/firebase_analytics.dart';

/* This file contains Firebase Analytics tracking events used for tracking user's behaviors */
class FBAnalytics {
  static FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  /*EVENTS */
  final String eventAppIconPick = 'event_app_icon_pick';
  final String eventSendARequest = 'event_send_a_request';
  final String eventRequestACardRegistration =
      'event_request_a_card_registration';
  final String eventCallTheHotline = 'event_call_the_hotline';
  final String eventViewVoucher = 'event_view_voucher';
  final String eventViewHandbookList = 'event_view_handbook_list';
  final String eventViewImportantNewsList = 'event_view_important_news_list';
  final String eventViewImportantNews = 'event_view_important_news';
  final String eventViewServicesNearbyList = 'event_view_services_nearby_list';
  final String eventSelectServicesNearby = 'event_select_services_nearby';
  final String eventViewBuildingFacilityList =
      'event_view_building_facility_list';
  final String eventViewBuildingFacility = 'event_view_building_facility';
  final String eventViewHistoryRegistryList =
      'event_view_history_registry_list';
  final String eventViewRecentlyBooking = 'event_view_recently_booking';
  final String eventSearchGroupName = 'event_search_group_name';
  final String eventViewConversation = 'event_view_conversation';
  final String eventSendMessage = 'event_send_message';
  final String eventViewVotingList = 'event_view_voting_list';
  final String eventReactVoting = 'event_react_voting';
  final String eventViewAllCommentsVoting = 'event_view_all_comments_voting';
  final String eventViewAllCommentsDiscussion =
      'event_view_all_comments_discussion';
  final String eventCommentVoting = 'event_comment_voting';
  final String eventCommentDiscussion = 'event_comment_discussion';
  final String eventParticipateVoting = 'event_participate_voting';
  final String eventViewDiscussionList = 'event_view_discussion_list';
  final String eventPostNewThread = 'event_post_new_thread';
  final String eventReactDiscussion = 'event_react_discussion';
  final String eventFilterAnnouncement = 'event_filter_announcement';
  final String eventSelectViewAnnouncementUnread =
      'event_select_view_announcement_unread';
  final String eventViewAnnouncement = 'event_view_announcement';
  final String eventViewReceivedRequest = 'event_view_received_request';
  final String eventViewProcessingRequest = 'event_view_processing_request';
  final String eventViewCompletedRequest = 'event_view_completed_request';
  final String eventSendMessageRequest = 'event_send_message_request';
  final String eventViewRequestDetail = 'event_view_request_detail';
  final String eventCallAssignedStaff = 'event_call_assigned_staff';
  final String eventSendRatingReview = 'event_send_rating_review';

  /*PARAMS*/
  final String paramUserId = 'user_id';
  final String paramAppIconId = 'app_icon_id';
  final String paramCatagoryOfIssue = 'category_of_issue';
  final String paramMessageType = 'message_type';
  final String paramAnnouncementCategory = 'category';
  final String paramAnnouncementTime = 'time';

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

  void sendEventAppIconPick(
      {required String userID, required String appIconID}) {
    _analytics.logEvent(
        name: eventAppIconPick,
        parameters: {paramUserId: userID, paramAppIconId: appIconID});
    printLog(
        event: eventAppIconPick,
        param: {paramUserId: userID, paramAppIconId: appIconID});
  }

  void sendEventSendARequest(
      {required String userID, required int catagoryOfIssue}) {
    _analytics.logEvent(name: eventSendARequest, parameters: {
      paramUserId: userID,
      paramCatagoryOfIssue: catagoryOfIssue
    });
    printLog(
        event: eventSendARequest,
        param: {paramUserId: userID, paramCatagoryOfIssue: catagoryOfIssue});
  }

  void sendEventRequestACardRegistration({required String userID}) {
    _analytics.logEvent(
        name: eventRequestACardRegistration, parameters: {paramUserId: userID});
    printLog(
        event: eventRequestACardRegistration, param: {paramUserId: userID});
  }

  void sendEventCallTheHotline({required String userID}) {
    _analytics
        .logEvent(name: eventCallTheHotline, parameters: {paramUserId: userID});
    printLog(event: eventCallTheHotline, param: {paramUserId: userID});
  }

  void sendEventViewVoucher({required String userID}) {
    _analytics
        .logEvent(name: eventViewVoucher, parameters: {paramUserId: userID});
    printLog(event: eventViewVoucher, param: {paramUserId: userID});
  }

  void sendEventViewHandbookList({required String userID}) {
    _analytics.logEvent(
        name: eventViewHandbookList, parameters: {paramUserId: userID});
    printLog(event: eventViewHandbookList, param: {paramUserId: userID});
  }

  void sendEventViewImportantNewsList({required String userID}) {
    _analytics.logEvent(
        name: eventViewImportantNewsList, parameters: {paramUserId: userID});
    printLog(event: eventViewImportantNewsList, param: {paramUserId: userID});
  }

  void sendEventViewImportantNews({required String userID}) {
    _analytics.logEvent(
        name: eventViewImportantNews, parameters: {paramUserId: userID});
    printLog(event: eventViewImportantNews, param: {paramUserId: userID});
  }

  void sendEventViewServicesNearbyList({required String userID}) {
    _analytics.logEvent(
        name: eventViewServicesNearbyList, parameters: {paramUserId: userID});
    printLog(event: eventViewServicesNearbyList, param: {paramUserId: userID});
  }

  void sendEventSelectServicesNearby({required String userID}) {
    _analytics.logEvent(
        name: eventSelectServicesNearby, parameters: {paramUserId: userID});
    printLog(event: eventSelectServicesNearby, param: {paramUserId: userID});
  }

  void sendEventViewBuildingFacilityList({required String userID}) {
    _analytics.logEvent(
        name: eventViewBuildingFacilityList, parameters: {paramUserId: userID});
    printLog(
        event: eventViewBuildingFacilityList, param: {paramUserId: userID});
  }

  void sendEventViewBuildingFacility({required String userID}) {
    _analytics.logEvent(
        name: eventViewBuildingFacility, parameters: {paramUserId: userID});
    printLog(event: eventViewBuildingFacility, param: {paramUserId: userID});
  }

  void sendEventViewHistoryRegistryList({required String userID}) {
    _analytics.logEvent(
        name: eventViewHistoryRegistryList, parameters: {paramUserId: userID});
    printLog(event: eventViewHistoryRegistryList, param: {paramUserId: userID});
  }

  void sendEventViewRecentlyBooking({required String userID}) {
    _analytics.logEvent(
        name: eventViewRecentlyBooking, parameters: {paramUserId: userID});
    printLog(event: eventViewRecentlyBooking, param: {paramUserId: userID});
  }

  void sendEventSearchGroupName({required String userID}) {
    _analytics.logEvent(
        name: eventSearchGroupName, parameters: {paramUserId: userID});
    printLog(event: eventSearchGroupName, param: {paramUserId: userID});
  }

  void sendEventViewConversation({required String userID}) {
    _analytics.logEvent(
        name: eventViewConversation, parameters: {paramUserId: userID});
    printLog(event: eventViewConversation, param: {paramUserId: userID});
  }

  void sendEventSendMessage(
      {required String userID, required String messageType}) {
    _analytics.logEvent(
        name: eventSendMessage,
        parameters: {paramUserId: userID, paramMessageType: messageType});
    printLog(
        event: eventSendMessage,
        param: {paramUserId: userID, paramMessageType: messageType});
  }

  void sendEventViewVotingList({required String userID}) {
    _analytics
        .logEvent(name: eventViewVotingList, parameters: {paramUserId: userID});
    printLog(event: eventViewVotingList, param: {paramUserId: userID});
  }

  void sendEventReactVoting({required String userID}) {
    _analytics
        .logEvent(name: eventReactVoting, parameters: {paramUserId: userID});
    printLog(event: eventReactVoting, param: {paramUserId: userID});
  }

  void sendEventViewAllCommentsVoting({required String userID}) {
    _analytics.logEvent(
        name: eventViewAllCommentsVoting, parameters: {paramUserId: userID});
    printLog(event: eventViewAllCommentsVoting, param: {paramUserId: userID});
  }

  void sendEventViewAllCommentsDiscussion({required String userID}) {
    _analytics.logEvent(
        name: eventViewAllCommentsDiscussion,
        parameters: {paramUserId: userID});
    printLog(
        event: eventViewAllCommentsDiscussion, param: {paramUserId: userID});
  }

  void sendEventCommentVoting({required String userID}) {
    _analytics
        .logEvent(name: eventCommentVoting, parameters: {paramUserId: userID});
    printLog(event: eventCommentVoting, param: {paramUserId: userID});
  }

  void sendEventCommentDiscussion({required String userID}) {
    _analytics.logEvent(
        name: eventCommentDiscussion, parameters: {paramUserId: userID});
    printLog(event: eventCommentDiscussion, param: {paramUserId: userID});
  }

  void sendEventParticipateVoting({required String userID}) {
    _analytics.logEvent(
        name: eventParticipateVoting, parameters: {paramUserId: userID});
    printLog(event: eventParticipateVoting, param: {paramUserId: userID});
  }

  void sendEventViewDiscussionList({required String userID}) {
    _analytics.logEvent(
        name: eventViewDiscussionList, parameters: {paramUserId: userID});
    printLog(event: eventViewDiscussionList, param: {paramUserId: userID});
  }

  void sendEventPostNewThread({required String userID}) {
    _analytics
        .logEvent(name: eventPostNewThread, parameters: {paramUserId: userID});
    printLog(event: eventPostNewThread, param: {paramUserId: userID});
  }

  void sendEventReactDiscussion({required String userID}) {
    _analytics.logEvent(
        name: eventReactDiscussion, parameters: {paramUserId: userID});
    printLog(event: eventReactDiscussion, param: {paramUserId: userID});
  }

  void sendEventFilterAnnouncement(
      {required String userID, String? category, String? time}) {
    _analytics.logEvent(name: eventFilterAnnouncement, parameters: {
      paramUserId: userID,
      paramAnnouncementCategory: category ?? '',
      paramAnnouncementTime: time ?? ''
    });

    printLog(event: eventFilterAnnouncement, param: {
      paramUserId: userID,
      paramAnnouncementCategory: category ?? '',
      paramAnnouncementTime: time ?? ''
    });
  }

  void sendEventSelectViewAnnouncementUnread({required String userID}) {
    _analytics.logEvent(
        name: eventSelectViewAnnouncementUnread,
        parameters: {paramUserId: userID});
    printLog(
        event: eventSelectViewAnnouncementUnread, param: {paramUserId: userID});
  }

  void sendEventViewAnnouncement({required String userID}) {
    _analytics.logEvent(
        name: eventViewAnnouncement, parameters: {paramUserId: userID});
    printLog(event: eventViewAnnouncement, param: {paramUserId: userID});
  }

  void sendEventViewReceivedRequest({required String userID}) {
    _analytics.logEvent(
        name: eventViewReceivedRequest, parameters: {paramUserId: userID});
    printLog(event: eventViewReceivedRequest, param: {paramUserId: userID});
  }

  void sendEventViewProcessingRequest({required String userID}) {
    _analytics.logEvent(
        name: eventViewProcessingRequest, parameters: {paramUserId: userID});
    printLog(event: eventViewProcessingRequest, param: {paramUserId: userID});
  }

  void sendEventViewCompletedRequest({required String userID}) {
    _analytics.logEvent(
        name: eventViewCompletedRequest, parameters: {paramUserId: userID});
    printLog(event: eventViewCompletedRequest, param: {paramUserId: userID});
  }

  void sendEventSendMessageRequest({required String userID}) {
    _analytics.logEvent(
        name: eventSendMessageRequest, parameters: {paramUserId: userID});
    printLog(event: eventSendMessageRequest, param: {paramUserId: userID});
  }

  void sendEventViewRequestDetail({required String userID}) {
    _analytics.logEvent(
        name: eventViewRequestDetail, parameters: {paramUserId: userID});
    printLog(event: eventViewRequestDetail, param: {paramUserId: userID});
  }

  void sendEventCallAssignedStaff({required String userID}) {
    _analytics.logEvent(
        name: eventCallAssignedStaff, parameters: {paramUserId: userID});
    printLog(event: eventCallAssignedStaff, param: {paramUserId: userID});
  }

  void sendEventSendRatingReview({required String userID}) {
    _analytics.logEvent(
        name: eventSendRatingReview, parameters: {paramUserId: userID});
    printLog(event: eventSendRatingReview, param: {paramUserId: userID});
  }

  void printLog({
    required String event,
    required Map<String, dynamic> param,
  }) {
    String log = '''[FBAnalytics] $event parameters: ${param.toString()}
    ''';
    print(log);
  }
}
