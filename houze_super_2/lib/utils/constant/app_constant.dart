import 'dart:io';

import 'package:houze_super/middle/model/language_model.dart';

import '../sqflite.dart';

class AppImages {
  static const String path = 'assets/images/';
  static const String icPayME = path + 'ic-pay-me.png';
  static const String icHouzexPayME = path + 'img_pay_me.png';

  static const String icPhoneError = path + 'ic_phone_error.png';
  static const String icHouzePoint = path + 'ic_houze_point.png';
  static const String ic25Fit = path + 'ic_25_fit.png';
  static const String aharent = path + 'aharent.png';
  static const String btaskee = path + 'btaskee.png';
  static const String foodmap = path + 'foodmap.png';
  static const String meete = path + 'meete.png';
  static const String medalAddidas = path + 'medal-addidas.png';
  static const String medalDecathlon = path + 'medal-decathlon.png';

  /* point info */
  static const String pointInfoPath = 'assets/images/pointInfo/';
  static const String point_graphic = pointInfoPath + 'graphic.png';
}

class AppTabbar {
  /*Không có Tab Cộng đồng*/
//   static const int home = 0;
//   static const int payment = 1;
//   static const int mailbox = 2;
//   static const int profile = 3;

/*Có Tab Cộng đồng*/
  static const int home = 0;
  static const int community = 1;
  static const int payment = 2;
  static const int mailbox = 3;
  static const int profile = 4;
}

class AppVectors {
  static const String svgPath = 'assets/svg/';
  static const String icComingsoonService =
      svgPath + 'comingsoon/' + 'ic_comingsoon_service.svg';

  /*Payment*/
  static const payment = 'assets/svg/payment/';
  static const icOpenWalletPayme = payment + 'ic-open-wallet-payme.svg';

  /*new version*/
  static const icNewVersion = 'assets/svg/ic_new_version.svg';

  /*Community*/
  static const icCommunity = 'assets/svg/community/';
  static const icAttachImage = icCommunity + 'ic-attach-img.svg';
  static const icAttachImageIssue = icCommunity + 'ic-attach-image.svg';
  static const icDisableAttachImage = icCommunity + 'ic-gallery.svg';
  static const icTeamFailed = icCommunity + 'ic-team-failed.svg';
  static const icTeamSuccess = icCommunity + 'ic-team-success.svg';
  static const icMoreVert = icCommunity + 'ic-more-vert.svg';
  static const icNoneMedal = icCommunity + 'ic-none-medal.svg';
  static const icMedal1 = icCommunity + 'ic-medal-1.svg';
  static const icMedal10 = icCommunity + 'ic-medal-10.svg';
  static const icMedal100 = icCommunity + 'ic-medal-100.svg';
  static const icMedal500 = icCommunity + 'ic-medal-500.svg';
  static const icMedal1K = icCommunity + 'ic-medal-1-k.svg';
  static const icMedal10K = icCommunity + 'ic-medal-10-k.svg';
  static const icSmallHouzePoint = icCommunity + 'ic-small-houzepoint.svg';
  static const icMedal1Disabled = icCommunity + 'ic-medal-1-disabled.svg';
  static const icMedal10Disabled = icCommunity + 'ic-medal-10-disabled.svg';
  static const icMedal100Disabled = icCommunity + 'ic-medal-100-disabled.svg';
  static const icMedal500Disabled = icCommunity + 'ic-medal-500-disabled.svg';
  static const icMedal1KDisabled = icCommunity + 'ic-medal-1-k-disabled.svg';
  static const icMedal10KDisabled = icCommunity + 'ic-medal-10-k-disabled.svg';

  static const icWalkShoes = icCommunity + 'ic-walk-shoes.svg';
  static const icBubbleChat = icCommunity + 'ic-bubble-chat.svg';
  static const icRunLarge = icCommunity + 'ic-run-large.svg';
  static const icBadgeSmall = icCommunity + 'ic-badge-small.svg';
  static const icTrophy = icCommunity + 'ic-trophy.svg';
  static const icFire = icCommunity + 'ic-fire.svg';
  static const icWalkActive = icCommunity + 'ic_walk_active.svg';
  static const icWalkUnactive = icCommunity + 'ic-walk-unactive.svg';

  static const icRun = icCommunity + 'ic_run.svg';
  static const icSaleRent = icCommunity + 'ic-sale-rent.svg';
  static const icFoundNotTeam = icCommunity + 'ic-not-found-team.svg';

  static const icRunActive = icCommunity + 'ic-run-active.svg';
  static const icOvalEnd = icCommunity + 'ic-oval-end.svg';
  static const icPoint = icCommunity + 'ic-houzepoint.svg';
  static const icOvalRegisted = icCommunity + 'ic-oval-registed.svg';
  static const icOvalPending = icCommunity + 'ic-oval-pending.svg';

  static const icNotiOn = icCommunity + 'ic-noti-on.svg';
  static const icNotiOff = icCommunity + 'ic-noti-off.svg';

  static const icChatLight = icCommunity + 'ic-chat-light.svg';

  /* Poll */
  static const icLike = icCommunity + 'ic-like.svg';
  static const icLikeActive = icCommunity + 'ic-like-active.svg';
  static const icComment = icCommunity + 'ic-comment.svg';
  static const icDropDown = icCommunity + 'ic-dropdown.svg';
  static const icVote = icCommunity + 'ic-vote.svg';
  static const icVoteSuccess = icCommunity + 'ic-vote-success.svg';

  /* Booking */
  static const booking = 'assets/svg/icon/booking/';
  static const icOval = booking + 'ic_oval.svg';
  static const icEdit = booking + "ic-edit.svg";
  /* Facility */
  static const status = 'assets/svg/icon/status/';
  static const icRegistercCancel = status + 'ic-register-cancel.svg';
  static const icRegisterDeny = status + 'ic-register-deny.svg';
  static const icRegistercSuccess = status + 'ic-register-success.svg';
  static const icRegistercPending = status + 'ic-register-pending.svg';
  static const icRegistercDone = status + 'ic-register-done.svg';
  static const icRegistercEmpty = status + 'ic_register_empty.svg';

  /*Login */
  static const String logoHouze = svgPath + 'login/logo_houze.svg';
  static const String icVnese = svgPath + 'login/ic_vnese.svg';

  static const String icViet = svgPath + 'login/ic_viet.svg';
  static const String icEnglish = svgPath + 'login/ic_english.svg';
  static const String icChine = svgPath + 'login/ic_cn.svg';
  static const String icKorean = svgPath + 'login/ic_korean.svg';
  static const String icJapan = svgPath + 'login/ic-JP.svg';

  /* Home */
  static const String homePath = 'assets/svg/home/';

  static const String icTabHouze = homePath + 'ic_houze.svg';
  static const String icTabCommunity = homePath + 'ic_community.svg';

  static const String icTabCommunityUnactive =
      homePath + 'ic-community-unactive.svg';
  static const String icTabHouzeUnactive = homePath + 'ic_houze_unactive.svg';
  static const String icStarsCircle = homePath + 'ic_stars_circle.svg';
  static const String icTabInvoice = homePath + 'ic_invoice.svg';
  static const String icTabInvoiceUnactive =
      homePath + 'ic_invoice_unactive.svg';
  static const String icTabMailbox = homePath + 'ic_mailbox.svg';
  static const String icTabMailboxUnactive =
      homePath + 'ic_mailbox_unactive.svg';
  static const String icTabProfile = homePath + 'ic_profile.svg';
  static const String icTabProfileUnactive =
      homePath + 'ic_profile_unactive.svg';

  static const String icSwapHoriz = homePath + 'ic_swap_horiz.svg';
  static const String icBill = homePath + 'ic_bill.svg';

  static const String icNotebook = homePath + 'ic_notebook.svg';
  static const String icVoucher = homePath + 'ic_voucher.svg';
  static const String icSellRent = homePath + 'ic_sell_rent.svg';
  static const String icSOS = homePath + 'ic_sos.svg';
  static const String icSendissue = homePath + 'ic_sendissue.svg';
  static const String icParking = homePath + 'ic_parking.svg';

  /* Parking */
  static const String car = 'assets/svg/parking/ic-car.svg';
  static const String electric_bike = 'assets/svg/parking/ic-electricbike.svg';
  static const String motor = 'assets/svg/parking/ic-motor.svg';
  static const String bicycle = 'assets/svg/parking/ic-bicycle.svg';
  static const String handbook = 'assets/svg/parking/ic-notebook.svg';
  static const String large_parking = 'assets/svg/parking/ic-parking-large.svg';
  static const String vehicle_card = 'assets/svg/parking/vehicle-card.svg';
  static const String icFacility = 'assets/svg/parking/ic-facility.svg';
  static const String icRegister = 'assets/svg/icon/booking/ic-register.svg';

  /* Icon */
  static const String iconPath = 'assets/svg/icon/';
  static const String ic_autorenew = iconPath + 'ic_autorenew.svg';
  static const String ic_arrow_right_red = iconPath + 'ic-arrow-right-red.svg';
  static const String ic_notification = iconPath + 'ic_notification.svg';
  static const String ic_bar_chart = iconPath + 'ic_bar_chart.svg';
  static const String ic_notification_empty =
      iconPath + 'ic-notification-empty.svg';
  static const String ic_touch_active =
      iconPath + "booking/ic-touch-active.svg";
  static const String ic_sos_large = iconPath + 'ic_sos_large.svg';
  static const String ic_visibility = iconPath + 'ic-visibility.svg';
  static const String ic_visibility_off = iconPath + 'ic-visibility-off.svg';
  static const String ic_close = iconPath + 'ic-close.svg';
  static const String ic_info = iconPath + 'ic_info.svg';
  static const String ic_back_overlay = iconPath + 'ic_back_overlay.svg';
  static const String icClose = iconPath + 'ic_close.svg';
  static const String ic_arrow_right = iconPath + 'ic_arrow_right.svg';
  static const String ic_sendissue = iconPath + 'ic_sendissue.svg';
  static const String ic_sendissue_process =
      iconPath + 'ic_sendissue_process.svg';
  static const String ic_sendissue_done = iconPath + 'ic_sendissue_done.svg';
  static const String ic_add_photo = iconPath + 'icon-add-photo.svg';
  static const String ic_star_unrate = iconPath + 'ic_star_unrate.svg';
  static const String ic_star = iconPath + 'ic_star.svg';
  static const String ic_call = iconPath + 'ic-call.svg';
  static const String ic_attach_money = iconPath + 'ic_attach_money.svg';
  static const String icIssue = iconPath + 'ic-issue.svg';
  static const String icBank = iconPath + 'ic-bank.svg';

  /*Service */
  static const String service = iconPath + 'service/';
  static const String ic_place_empty = service + 'ic_place_empty.svg';
  static const String graphic_voucher_empty =
      iconPath + 'graphic-voucher-empty.svg';
  /* Mailbox */
  static const String mailboxPath = 'assets/svg/mailbox/';
  static const String ic_annoucement_important =
      mailboxPath + 'ic_annoucement_important.svg';
  static const String ic_register = mailboxPath + 'ic_register.svg';
  static const String ic_facility = mailboxPath + 'ic-facility.svg';
  static const String ic_annoucement = mailboxPath + 'ic_annoucement.svg';
  static const String ic_rating_medium = mailboxPath + 'ic_rating_medium.svg';

  /* Feed */
  static const String ic_stars_circle = 'assets/svg/feed/ic_stars_circle.svg';

  /* Sell */
  static const String icRent = 'assets/svg/sell/ic-rent.svg';
  static const String icSell = 'assets/svg/sell/ic-sell.svg';
  static const String rent = 'assets/svg/sell/rent.svg';
  static const String sell = 'assets/svg/sell/sell.svg';
  static const String sellAndRent = 'assets/svg/sell/sell-rent.svg';

  /* Rating */
  static const String rating = 'assets/svg/rating/';
  static const String ic_flash = rating + 'ic_flash.svg';
  static const String ic_super = rating + 'ic_super.svg';
  static const String ic_on_time = rating + 'ic_on_time.svg';
  static const String ic_planet = rating + 'ic_planet.svg';
  static const String ic_late = rating + 'ic_late.svg';
  static const String ic_normal = rating + 'ic_normal.svg';
  static const String ic_banned = rating + 'ic_banned.svg';
  static const String ic_bad_service = rating + 'ic_bad_service.svg';
  static const String ic_impolite = rating + 'ic_impolite.svg';
  static const String ic_review = rating + 'ic_review.svg';

  /* Profile */
  static const String icon_policy = 'assets/svg/profile/icon-policy.svg';
  static const String facility = 'assets/svg/profile/ic-facility.svg';
  static const String home = 'assets/svg/profile/ic-home.svg';
  static const String houzePoint = 'assets/svg/profile/ic-houzepoint.svg';
  static const String phone = 'assets/svg/profile/ic-phone.svg';
  static const String shield = 'assets/svg/profile/ic-shield.svg';
  static const String logOut = 'assets/svg/profile/ic-logout.svg';
  static const String balcony = 'assets/svg/profile/ic-balcony.svg';
  static const String cook = 'assets/svg/profile/ic-cook.svg';
  static const String singleBed = 'assets/svg/profile/ic-singlebed.svg';
  static const String toilet = 'assets/svg/profile/ic-toilet.svg';
  static const String registerAll = 'assets/svg/profile/ic-register-all.svg';
  static const String registerCancel =
      'assets/svg/profile/ic-register-cancel.svg';
  static const String registerDeny = 'assets/svg/profile/ic-register-deny.svg';
  static const String registerPending =
      'assets/svg/profile/ic-register-pending.svg';
  static const String registerSuccess =
      'assets/svg/profile/ic-register-success.svg';
  static const String graphicShield = 'assets/svg/profile/graphic-shield.svg';
  static const String handPhone = 'assets/svg/profile/ic-hand-phone.svg';
  /* EKYC */
  static const String ekyc = 'assets/svg/ekyc/graphic-e-kyc.svg';

  /* 404 */
  static const String ic_404_invoice = 'assets/svg/404/ic-invoice-large.svg';

  /* point info */
  static const String pointInfoPath = 'assets/svg/pointInfo/';
  static const String point_graphic = pointInfoPath + 'graphic.svg';
}

class AppStrings {
  static const String envDev = '.env.dev';
  static const String envProd = '.env.prod';

  static const String important = 'important';

  static String htmlBuilder(String description) {
    return """<html>
      <header><meta name='viewport' content='width=device-width, initial-scale=1.0, user-scalable=yes'>
      </header><body>$description</body></html>""";
  }
}

class DesignUtil {
  static const double width = 375.0;
  static const double height = 812.0;
}

class AppConstant {

  static const String phoneDial = '+84';
  static const String phoneCode = 'VN'; //Vietnam
  static const double payMinLimit = 10000;

  static const String locateVI = 'vi';
  static const String locateEN = 'en';
  static const String locateChinese = 'zh';
  static const String locateKorean = 'ko';
  static const String locateJapanese = 'ja';
  //iPhone X
  static const int screenWidth = 375;
  static const int screenHeight = 812;

  static const double appbarHeightExpanded = 120.0;
  static const int limitDefault = 10;
  static const int limitMessages = 20;
  static const int cacheDays = 3;

  static const String PREFIX_URL = 'data:text/html;charset=utf-8;base64,';

// ignore: non_constant_identifier_names
  static String DEVICE_TYPE = (Platform.isAndroid == true) ? "gcm" : "apple";

  static const runLogKey = "+MbQeThWmZq4t7w!";
  static const appID = "ffbc0133-7efc-4e05-9fcc-d35dc7e46346";
  static final List<LanguageModel> languages = [
    LanguageModel(
      name: 'Tiếng Việt',
      flag: AppVectors.icViet,
      locale: AppConstant.locateVI,
    ),
    LanguageModel(
      name: 'English',
      flag: AppVectors.icEnglish,
      locale: AppConstant.locateEN,
    ),
    LanguageModel(
      name: '中文',
      flag: AppVectors.icChine,
      locale: AppConstant.locateChinese,
    ),
    LanguageModel(
      name: '한국어',
      flag: AppVectors.icKorean,
      locale: AppConstant.locateKorean,
    ),
    LanguageModel(
      name: '日本語',
      flag: AppVectors.icJapan,
      locale: AppConstant.locateJapanese,
    )
  ];

  // Discusion page
  static const CATEGORY_GENERAL = 0;
  static const CATEGORY_BUY = 1;
  static const CATEGORY_SELL = 2;
  static const DISPLAY_NAME = 1;
  static const DISPLAY_PHONE = 0;
}

class ServiceConverter {
  //ignore service "z", check service "building" and type only.
  static const Map<String, int> TypeService = {
    "building0": 0,
    "building1": 2,
    "z0": 1,
    "z1": 1
  };

  static const Map<String, List<String>> dictionary = {
    "apartment_with_colon": [
      "apartment_with_colon",
      "room_with_colon_and_space",
      "house_number_with_colon_and_space", // số nhà:
    ],
    "building": ["building", "house", "residential_area"], //khu dân cư
    "select_an_apartment": [
      "select_an_apartment",
      "select_a_room",
      "select_a_house_number", // chọn số nhà
    ],
    "apartment": ["apartment", "room", "house_number"], // nhà
    "apartment_id_with_colon": [
      "apartment_id_with_colon",
      "room_id_with_colon",
      "house_number_with_colon_and_space" // số nhà:
    ],
    "resident": ["resident", "tenant", "resident"], // cư dân
    "floor_with_colon": [
      "floor_with_colon",
      "floor_with_colon",
      "street_with_colon" // đường:
    ],
    "apartment_information": [
      "apartment_information",
      "room_information",
      "house_information" // thông tin nhà
    ],
    "apartment_area_with_colon": [
      "apartment_area_with_colon",
      "room_area_with_colon",
      "house_area_with_colon", // diện tích nhà:
    ],
    "apartment_vote_done_msg": [
      "apartment_vote_done_msg",
      "room_vote_done_msg",
      "house_vote_done_msg",
    ],
    "building_with_colon": [
      "building_with_colon",
      "house_with_colon",
      "residential_area_with_colon" // khu dân cư:
    ],
    "block_with_colon": [
      "block_with_colon",
      "region_with_colon",
      "region_with_colon" // khu:
    ],
    "change_apartment": ["change_apartment", "change_room", "change_house"],
    "building_info": [
      "building_info",
      "house_information",
      "residential_area_information" // thông tin khu dân cư
    ],
    "building_facility": [
      "building_facility", //tiện ích toà nhà
      "house_facility", // tiện ích nhà
      "residential_area_facility" // tiện ích khu dân cư
    ],
    "building_handbook": [
      "building_handbook", //sổ tay toà nhà
      "house_handbook", // sổ tay nhà
      "residential_area_handbook" // sổ tay khu dân cư
    ],
    "building_manager": [
      "building_manager", // quản lý toà nhà
      "house_manager", // quản lý nhà
      "residential_area_manager" // quản lý khu dân cư
    ],
    "apartment_wallet": [
      "apartment_wallet", // ví căn hộ
      "home_wallet", // ví nhà
      "apartment_wallet",
    ]
  };
  static Future<String> convertTypeBuilding(String type) async {
    final building = await Sqflite.getCurrentBuilding();
    int getType = ((building?.type ?? 1) > 1) ? 0 : building!.type!;
    String index = building!.service! + getType.toString();
    return dictionary[type]![TypeService[index]!];
  }

  static Future<String> convertTypeService(String type, String service) async {
    return dictionary[type]![TypeService[service] ?? 0];
  }

  static Future<String> getTextToConvert(String type) async {
    return await ServiceConverter.convertTypeBuilding(type);
  }
}
