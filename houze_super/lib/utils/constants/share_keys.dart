class ShareKeys {
  static const String kLastDistance = 'last_distance';
  static const String kLastLatitude = 'last_latitude';
  static const String kLastLongitude = 'last_longitude';
  static const String kPayME = 'payme';

  static const String kPayMEToken = 'payme_token';
  static const String kStatePayME = 'payme_state';
  //Tài khoản đã định danh

  static const String kKycApproved = 'KYC_APPROVED';
  static const String kUnkownError = 'UNKNOWN_ERROR';
  //Tài khoản chưa kích hoạt
  // gọi fun openWallet() để kích hoạt tài khoản
  static const String kNotActivated = 'NOT_ACTIVATED';
  static const String kAccountNotActivated = 'ACCOUNT_NOT_ACTIVATED';
  static const String kPaymentError = 'PAYMENT_ERROR';
  //Tài khoản chưa định danh
  // gọi fun openKYC() để định danh tài khoản
  static const String kNotKyc = 'NOT_KYC';
  static const String kExpired = 'EXPIRED';
  //Tài khoản đã gửi thông tin định danh ,đang chờ duyệt
  static const String kKycReview = 'KYC_REVIEW';
  //Yêu cầu định danh bị từ chối
  // gọi fun openKYC() để định danh tài khoản
  static const String kKycRejected = 'KYC_REJECTED';
  static const String kAccountNotLogin = 'ACCOUNT_NOT_LOGIN';
  static const String kNotLogin = 'NOT_LOGIN';

  static const String kFullName = 'fullname';
  static const String kUserID = 'user_id';
  static const String kPhoneDial = 'phone_dial';

  static const String kAvatar = 'avatar';
  static const String kPhoneNumber = 'phone_number';
  static const String kChatToken = 'chatToken';

  static const String kAPIToken = 'api_token';
  static const String kDeviceToken = 'device_token';
  static const String kUserRefreshToken = 'user_refresh_token';
  static const String kSignIn = 'sign_in';
  static const String kLanguage = 'language';
  static const String kWelcome = 'welcome';
  static const String kAppVersion = 'app_version';
}
