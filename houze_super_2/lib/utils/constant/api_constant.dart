// import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'app_constant.dart';

// /*  Dev
// API_PROPERTY=https://integration-api.houze.io/citizen/property/
// API_FEE=https://integration-fee-citizen.houze.io/fee/
// API_OTP=https://integration-api.houze.io/houze-otp
// API_IDENTITY=https://integration-houze-api.houze.io/
// API_GATEWAY=https://integration-api.houze.io/
// API_RUN=https://integration-api.houze.io/lifestyle-run/
// */

// /* Pro
// API_PROPERTY=https://api.houze.io/citizen/property/
// API_GATEWAY=https://api.houze.io/
// API_FEE=https://fee-citizen.houze.io/fee/
// API_OTP=https://api.houze.io/houze-otp
// API_IDENTITY=https://api.houze.io/
// */

// class BasePath {
//   static late String gateway,
//       otp,
//       feeOrigin,
//       identity,
//       identityV2,
//       citizen,
//       feed,
//       oauth,
//       fee,
//       newFee,
//       payment,
//       property,
//       run,
//       chat,
//       forum;

//   static init() {
//     gateway = dotenv.env['API_GATEWAY']!;
//     otp = gateway + 'houze-otp'; //dotenv.env['API_OTP'];
//     feeOrigin = dotenv.env['API_FEE']!;
//     identityV2 = gateway + 'identity/'; //dotenv.env['API_IDENTITY'];

//     identity = gateway + 'identity/';
//     citizen = gateway + 'citizen/';
//     fee = gateway + 'v2/fee/';
//     newFee = dotenv.env['API_FEE']!;
//     payment = gateway + 'houze-pay/';
//     feed = gateway + 'houze-feed/';
//     oauth = gateway + 'oauth/';
//     property = gateway + 'citizen/property/';
//     run = dotenv.env['API_RUN']!;
//     chat = dotenv.env['API_CHAT']!;
//     forum = dotenv.env['API_FORUM']!;
//   }
// }

// class ChatPath {
//   static final channelChat = BasePath.chat + 'chat';
//   static final base = BasePath.chat + 'api/v1/chat/';
//   static final getMessagesLast =
//       ChatPath.base + AppConstant.appID + '/messages/last';
//   static final getMessagesChatDetail =
//       ChatPath.base + AppConstant.appID + '/messages/';
//   static final postChatImage = BasePath.citizen + 'storage/upload-image/';
// }

// class PointPath {
//   static final getPointTransationHistory =
//       BasePath.citizen + 'xu/transaction-history/';

//   static final getTotalHouzePoint = BasePath.citizen + 'xu/my-wallet/';
// }

// class OTPPath {
//   static final generateOtp = BasePath.otp + '/otp/';
//   static final verifyOtp = BasePath.otp + '/otp/verify/';
//   static final setPasswordV2 = BasePath.oauth + 'set-password/v2';
// }

// class RunPath {
//   static final baseUrl = BasePath.run;

//   static final getAllEvent = baseUrl + 'events/';
//   static final runActivities = baseUrl + 'activities/';
//   static final uploadFile = baseUrl + 'uploads/';
//   static final getStatisticOverview = baseUrl + 'statistic/overview/';
//   static final getDistanceDate = baseUrl + 'statistic/distance-date/';

//   static final getEventsRequest = getAllEvent + 'requests/';
//   static final putCancelJoinTeam = getEventsRequest;
//   static final getAllAchievementUser = baseUrl + 'achievement/me/';
// }

// class GroupPath {
//   static final baseUrl = BasePath.run + 'groups/';
//   static final deleteAGroup = baseUrl;
//   static final joinGroupByCode = baseUrl + 'join/';
// }

// class MerchantPath {
//   static final base = BasePath.identity + 'merchant/';
//   static final getCoupons = MerchantPath.base + 'coupon/';
//   static final getShops = MerchantPath.base + 'shop/';
//   static final getUserCoupon = MerchantPath.base + 'user-coupon/';
// }

// class AuthPath {
//   static late String checkPhoneNumber,
//       signIn,
//       refreshToken = BasePath.oauth + "api-token-refresh",
//       changePassword,
//       setPassword,
//       resetPassword,
//       profile,
//       profileImage;

//   static init() {
//     checkPhoneNumber = BasePath.oauth + "check-phone-number";
//     signIn = BasePath.oauth + "api-token-auth";
//     refreshToken = BasePath.oauth + "api-token-refresh";
//     changePassword = BasePath.oauth + "change-password/";
//     setPassword = BasePath.oauth + "set-password";
//     profile = BasePath.identity + 'oauth/profile/';
//     profileImage = BasePath.oauth + 'profile-image/';
//   }
// }

// class TicketPath {
//   static final ticketBase = BasePath.citizen + 'ticket/';
//   static final postTicket = ticketBase + "create-ticket/";
//   static final getTicket = ticketBase;
// }

// class PropertyPath {
//   static final property = BasePath.citizen + 'property/';
//   static final getBuildings = BasePath.property + 'building/';
//   static final getApartments =
//       BasePath.citizen + "property/apartment/"; //property + "apartment";

//   static final getBuilding = BasePath.property + 'building/';
// }

// class FacilityPath {
//   static final getFacilities = BasePath.citizen + "facility/";
//   static final getDetail = getFacilities + "detail/";
//   static final getFacilityHistories = getFacilities + "booking/history/";
//   static final getBookingDetail = getFacilities + "booking/";
// }

// class FeedPath {
//   static final feedBase = BasePath.feed;
//   static final getNotifications = BasePath.feed + "v1/notifications";
//   static final feedRead = BasePath.feed + "v1/notifications/read/";
// }

// class FeePath {
//   static final feePath = BasePath.feeOrigin;
//   static final getFeeTotal = feePath + 'total/';
//   static final getReceiptDetail = feePath + 'receipt-detail/';
//   static final feeDetail = BasePath.newFee + "detail/";
// }

// class FeeV1Path {
//   static final getFeeGroupByApartment =
//       BasePath.fee + 'fee/fee-group-by-apartment/';
//   static final getFeeList = BasePath.fee + 'fee/list/';
//   static final getFee = BasePath.fee + 'fee/';

//   static final createFeePayment = BasePath.fee + 'payment/create-fee-payment/';
//   static final paymentHistory = BasePath.fee + 'payment/history/';

//   static final baseCitizenUrlCancelFeePayment =
//       BasePath.fee + "payment/cancel-fee-payment/";

//   static final basePaymentUrlBankTransfer =
//       BasePath.gateway + "v3/payment/banks";
// }

// class PaymentPath {
//   static final getGateways = BasePath.gateway + 'v3/payment/gateway/';
// }

// class APIConstant {
//   static final isProduction = dotenv.env['IS_PRODUCTION'];
//   static const String app_feed_id = "74f72868-4309-4589-ad56-2c6a4457c023";

//   static final postImage = BasePath.citizen + 'image/';
//   static final postVideo = BasePath.citizen + 'storage/upload-video/';

//   static final postCommentImage = BasePath.citizen + 'storage/upload-image/';

//   static final postApartmentImage =
//       BasePath.citizen + 'agent/apartment-image-upload/';

//   static final postApartmentImageAuthenticate =
//       BasePath.citizen + "agent/apartment-image-authenticate-upload/";

//   static final patchApartmentResell =
//       BasePath.citizen + "agent/apartment-resell-update/";

//   static final getApartmentResellDetail =
//       BasePath.citizen + "agent/apartment-resell-detail/";

//   static final apartmentResell = BasePath.citizen + "agent/apartment-resell/";

//   static final baseApartment = BasePath.citizen + "property/apartment";

//   static final baseFeedUrlFeedBadge = BasePath.feed + "v1/notifications/badge";

//   static final fee = BasePath.citizen + "/fee/";

//   static final feeTotal = BasePath.citizen + "/fee/total/";

//   static final feeReceiptDetail = BasePath.citizen + "fee/receipt-detail/";

//   static final getFeeByMonth = BasePath.newFee + "fee-history-by-month/";

//   static final handbook = BasePath.citizen + 'handbook/';

//   static final createVehicleImage =
//       BasePath.citizen + 'parking/create-vehicle-image/';

//   static final createVehicleParkingBooking =
//       BasePath.citizen + 'parking/create-vehicle-parking-booking/';

//   static final getParkingBookingHistory =
//       BasePath.citizen + 'parking/parking-booking-history/';

//   static final getParkingList = BasePath.citizen + 'parking/parking-list/';

//   static final getParkingVehicle =
//       BasePath.citizen + 'parking/parking-vehicle/';

//   static final postParkingVehicleImage =
//       BasePath.citizen + 'parking/create-vehicle-image/';

//   static final getPropertyBuilding = BasePath.citizen + 'property/building/';

//   static final postEKYC = BasePath.identity + 'ekyc/';

//   static final getEKYC = BasePath.identity + 'ekyc/current/';
// }

// class XuPath {
//   static final getXuEarn = BasePath.citizen + 'xu-earn/';
//   static final getXuLimit = BasePath.citizen + 'xu/limit/';
// }

// class PollPath {
//   static final getThread = BasePath.forum + 'threads/';
//   static final getPollInfo = BasePath.forum + 'poll-threads/';
//   static final postImage = BasePath.forum + 'images/';
//   static final userChoice = BasePath.forum + 'user-choices/';
//   static final userPermission = BasePath.forum + 'permissions/';
// }

// class DiscusionPath {
//   static final baseThread = BasePath.forum + 'threads/';
// }

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_constant.dart';

/*  Dev
API_PROPERTY=https://integration-api.houze.io/citizen/property/
API_FEE=https://integration-fee-citizen.houze.io/fee/
API_OTP=https://integration-api.houze.io/houze-otp
API_IDENTITY=https://integration-houze-api.houze.io/
API_GATEWAY=https://integration-api.houze.io/
API_RUN=https://integration-api.houze.io/lifestyle-run/
*/

/* Pro
API_PROPERTY=https://api.houze.io/citizen/property/
API_GATEWAY=https://api.houze.io/
API_FEE=https://fee-citizen.houze.io/fee/
API_OTP=https://api.houze.io/houze-otp
API_IDENTITY=https://api.houze.io/
*/

class Toolset {
  static late String paymentPrivateKey;

  static void init() {
    paymentPrivateKey = dotenv.env['FEE_PRIVATE_KEY'] ?? '';
    print(paymentPrivateKey.toString());
  }
}

class BasePath {
  static late String gateway,
      otp,
      feeOrigin,
      identity,
      identityV2,
      citizen,
      feed,
      oauth,
      fee,
      newFee,
      payment,
      property,
      run,
      chat,
      forum;

  static void init() {
    gateway = dotenv.env['API_GATEWAY']!;
    otp = gateway + 'houze-otp'; //dotenv.env['API_OTP'];
    feeOrigin = dotenv.env['API_FEE'] ?? '';
    identityV2 = gateway + 'identity/'; //dotenv.env['API_IDENTITY'];

    identity = gateway + 'identity/';
    citizen = gateway + 'citizen/';
    fee = gateway + 'v2/fee/';
    newFee = dotenv.env['API_FEE'] ?? '';
    payment = gateway + 'houze-pay/';
    feed = gateway + 'houze-feed/';
    oauth = gateway + 'oauth/';
    property = gateway + 'citizen/property/';
    run = dotenv.env['API_RUN'] ?? '';
    chat = dotenv.env['API_CHAT'] ?? '';
    forum = dotenv.env['API_FORUM'] ?? '';
  }
}

class ChatPath {
  static final channelChat = BasePath.chat + 'chat';
  static final base = BasePath.chat + 'api/v1/chat/';
  static final getMessagesLast =
      ChatPath.base + AppConstant.appID + '/messages/last';
  static final getMessagesChatDetail =
      ChatPath.base + AppConstant.appID + '/messages/';
  static final postChatImage = BasePath.citizen + 'storage/upload-image/';
}

class PointPath {
  static final getPointTransationHistory =
      BasePath.citizen + 'xu/transaction-history/';

  static final getTotalHouzePoint = BasePath.citizen + 'xu/my-wallet/';
}

class OTPPath {
  static final generateOtp = BasePath.otp + '/otp/';
  static final verifyOtp = BasePath.otp + '/otp/verify/';
  static final setPasswordV2 = BasePath.oauth + 'set-password/v2';
}

class RunPath {
  static final baseUrl = BasePath.run;

  static final getAllEvent = baseUrl + 'events/';
  static final runActivities = baseUrl + 'activities/';
  static final uploadFile = baseUrl + 'uploads/';
  static final getStatisticOverview = baseUrl + 'statistic/overview/';
  static final getDistanceDate = baseUrl + 'statistic/distance-date/';

  static final getEventsRequest = getAllEvent + 'requests/';
  static final putCancelJoinTeam = getEventsRequest;
  static final getAllAchievementUser = baseUrl + 'achievement/me/';
}

class GroupPath {
  static final baseUrl = BasePath.run + 'groups/';
  static final deleteAGroup = baseUrl;
  static final joinGroupByCode = baseUrl + 'join/';
}

class MerchantPath {
  static final base = BasePath.identity + 'merchant/';
  static final getCoupons = MerchantPath.base + 'coupon/';
  static final getShops = MerchantPath.base + 'shop/';
  static final getUserCoupon = MerchantPath.base + 'user-coupon/';
}

class AuthPath {
  static late String checkPhoneNumber,
      signIn,
      refreshToken = BasePath.oauth + "api-token-refresh",
      changePassword,
      setPassword,
      resetPassword,
      profile,
      profileImage;

  static void init() {
    checkPhoneNumber = BasePath.oauth + "check-phone-number";
    signIn = BasePath.oauth + "api-token-auth";
    refreshToken = BasePath.oauth + "api-token-refresh";
    changePassword = BasePath.oauth + "change-password/";
    setPassword = BasePath.oauth + "set-password";
    profile = BasePath.identity + 'oauth/profile/';
    profileImage = BasePath.oauth + 'profile-image/';
  }
}

class TicketPath {
  static final ticketBase = BasePath.citizen + 'ticket/';
  static final postTicket = ticketBase + "create-ticket/";
  static final getTicket = ticketBase;
}

class PropertyPath {
  static final property = BasePath.citizen + 'property/';
  static final getBuildings = BasePath.property + 'building/';
  static final getApartments =
      BasePath.citizen + "property/apartment/"; //property + "apartment";

  static final getBuilding = BasePath.property + 'building/';
  static final apartmentAcc = BasePath.fee + 'apartment-acc';
}

class FacilityPath {
  static final getFacilities = BasePath.citizen + "facility/";
  static final getDetail = getFacilities + "detail/";
  static final getFacilityHistories = getFacilities + "booking/history/";
  static final getBookingDetail = getFacilities + "booking/";
}

class FeedPath {
  static final feedBase = BasePath.feed;
  static final getNotifications = BasePath.feed + "v1/notifications";
  static final feedRead = BasePath.feed + "v1/notifications/read/";
}

class FeePath {
  static final feePath = BasePath.feeOrigin;
  static final getFeeTotal = feePath + 'total/';
  static final getReceiptDetail = feePath + 'receipt-detail/';
  static final feeDetail = BasePath.newFee + "detail/";
}

class FeeV1Path {
  static final getFeeGroupByApartment =
      BasePath.fee + 'fee/fee-group-by-apartment/';
  static final getFeeList = BasePath.fee + 'fee/list/';
  static final getFee = BasePath.fee + 'fee/';

  static final createFeePayment = BasePath.fee + 'payment/create-fee-payment/';
  static final paymentHistory = BasePath.fee + 'payment/history/';

  static final baseCitizenUrlCancelFeePayment =
      BasePath.fee + "payment/cancel-fee-payment/";

  static final basePaymentUrlBankTransfer =
      BasePath.gateway + "v3/payment/banks";
}

class PaymentPath {
  static final getGateways = BasePath.gateway + 'v3/payment/gateway/';
}

class APIConstant {
  static final isProduction = dotenv.env['IS_PRODUCTION'];
  static const String app_feed_id = "74f72868-4309-4589-ad56-2c6a4457c023";

  static final postImage = BasePath.citizen + 'image/';
  static final postVideo = BasePath.citizen + 'storage/upload-video/';

  static final postCommentImage = BasePath.citizen + 'storage/upload-image/';

  static final postApartmentImage =
      BasePath.citizen + 'agent/apartment-image-upload/';

  static final postApartmentImageAuthenticate =
      BasePath.citizen + "agent/apartment-image-authenticate-upload/";

  static final patchApartmentResell =
      BasePath.citizen + "agent/apartment-resell-update/";

  static final getApartmentResellDetail =
      BasePath.citizen + "agent/apartment-resell-detail/";

  static final apartmentResell = BasePath.citizen + "agent/apartment-resell/";

  static final baseApartment = BasePath.citizen + "property/apartment";

  static final baseFeedUrlFeedBadge = BasePath.feed + "v1/notifications/badge";
  static final baseFeedReadAll = BasePath.feed + "v1/notifications/read/user/";

  static final fee = BasePath.citizen + "/fee/";

  static final feeTotal = BasePath.citizen + "/fee/total/";

  static final feeReceiptDetail = BasePath.citizen + "fee/receipt-detail/";

  static final getFeeByMonth = BasePath.newFee + "fee-history-by-month/";

  static final handbook = BasePath.citizen + 'handbook/';

  static final createVehicleImage =
      BasePath.citizen + 'parking/create-vehicle-image/';

  static final createVehicleParkingBooking =
      BasePath.citizen + 'parking/create-vehicle-parking-booking/';

  static final getParkingBookingHistory =
      BasePath.citizen + 'parking/parking-booking-history/';

  static final getParkingList = BasePath.citizen + 'parking/parking-list/';

  static final getParkingVehicle =
      BasePath.citizen + 'parking/parking-vehicle/';

  static final postParkingVehicleImage =
      BasePath.citizen + 'parking/create-vehicle-image/';

  static final getPropertyBuilding = BasePath.citizen + 'property/building/';

  static final postEKYC = BasePath.identity + 'ekyc/';

  static final getEKYC = BasePath.identity + 'ekyc/current/';
}

class XuPath {
  static final getXuEarn = BasePath.citizen + 'xu-earn/';
  static final getXuLimit = BasePath.citizen + 'xu/limit/';
}

class PollPath {
  static final getThread = BasePath.forum + 'threads/';
  static final getPollInfo = BasePath.forum + 'poll-threads/';
  static final postImage = BasePath.forum + 'images/';
  static final userChoice = BasePath.forum + 'user-choices/';
  static final userPermission = BasePath.forum + 'permissions/';
}

class DiscusionPath {
  static final baseThread = BasePath.forum + 'threads/';
  static final baseComment = BasePath.forum + 'comments/';
}
