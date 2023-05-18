import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/bloc/index.dart';
import 'package:houze_super/app/bloc/overlay/overlay_bloc.dart';
import 'package:houze_super/middle/model/agent_model.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/model/handbook_model.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/middle/repo/challenge_repository.dart';
import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/middle/repo/statistic_repo.dart';
import 'package:houze_super/presentation/common_widgets/stateful/sc_video_player.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/view/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/view/sc_voting_detail.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/view/sc_discusion_detail.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/blocs/dashboard/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/bloc/mailbox_controller.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/ticket_page.dart';
import 'package:houze_super/presentation/screen/payment/sc_payment_transfer.dart';
import 'index.dart';
import 'screen/community/conversation/chat/views/index.dart';
import 'screen/community/conversation/forum/comment/view/sc_comment.dart';
import 'screen/community/run/statistic/view/sc_run_dashboard.dart';
import 'screen/login/sc_verify_otp.dart';
import 'screen/parking/detail/sc_parking_detail.dart';
import 'screen/parking/sc_parking.dart';
import 'screen/payment/sc_manual_transfer_guide_screen.dart';
import 'screen/profile/sc_house_xu.dart';
import 'screen/profile/view/index.dart';
import 'common_widgets/stateless/sc_image_view.dart';
import 'screen/404/sc_no_building.dart';
import 'screen/community/run/achivement/views/index.dart';
import 'screen/community/run/activity/views/index.dart';
import 'screen/community/run/group/index.dart';
import 'screen/community/run/index.dart';
import 'screen/community/index.dart';
import 'screen/handbook/sc_handbook.dart';
import 'screen/handbook/sc_handbook_detail.dart';
import 'screen/home/home_tab/facility/detail/history/sc_facility_history.dart';
import 'screen/home/home_tab/facility/detail/index.dart';
import 'screen/home/home_tab/facility/detail/info/index.dart';
import 'screen/home/home_tab/facility/register/detail/sc_facility_booking_detail.dart';
import 'screen/home/home_tab/facility/register/picker/sc_facility_pickevent.dart';
import 'screen/home/home_tab/facility/register/sc_facility_register.dart';
import 'screen/home/home_tab/facility/register/sc_facility_term.dart';
import 'screen/home/home_tab/facility/sc_facilities.dart';
import 'screen/home/home_tab/feed/sc_annoucement_detail.dart';
import 'screen/home/home_tab/feed/sc_feed_important_list.dart';
import 'screen/home/home_tab/nearby_service/detail/sc_places_around_detail.dart';
import 'screen/home/home_tab/nearby_service/sc_nearby_service_list.dart';
import 'screen/home/home_tab/sos/sc_sos.dart';
import 'screen/home/home_tab/voucher/index.dart';
import 'screen/home/home_tab/voucher/info/sc_info_shop.dart';
import 'screen/home/home_tab/voucher/qrcode/sc_qrcode_detail.dart';
import 'screen/home/home_tab/voucher/sc_voucher_detail.dart';
import 'screen/login/check_phone/sc_login_by_phone.dart';
import 'screen/login/sc_check_password.dart';
import 'screen/login/sc_create_password.dart';
import 'screen/mailbox/announcement/fee/sc_receipt_info.dart';
import 'screen/mailbox/ticket/comment/sc_ticket_comment.dart';
import 'screen/mailbox/ticket/detail/rating/index.dart';
import 'screen/parking/sc_parking_register.dart';
import 'screen/payment/order/fee/sc_fee_chart.dart';
import 'screen/payment/sc_fee_checkout.dart';
import 'screen/payment/sc_fee_gateway.dart';
import 'screen/payment/sc_fee_info.dart';
import 'screen/payment/sc_fee_overview.dart';
import 'screen/payment/sc_payment_detail.dart';
import 'screen/profile/sc_building_info.dart';
import 'screen/profile/view/sc_change_password.dart';
import 'screen/profile/view/sc_profile_info.dart';
import 'screen/profile/sc_utility_history.dart';
import 'screen/sc_main.dart';
import 'screen/sell/sc_sell_create.dart';
import 'screen/sell/sc_sell_detail.dart';
import 'screen/sell/sc_sell_list.dart';
import 'screen/sell/sc_sell_update.dart';
import 'screen/ticket/sc_ticket_create.dart';
import 'screen/home/home_tab/houze_xu_info/sc_houze_xu_info.dart';

class AppRouter {
  static const String ROOT = '/';
  static const String SPLASH = 'app://splash';
  static const String createPassword = 'app://password/create';
  static const enterPasswordPage = 'app://password/enter';

  static const String imageViewPage = "app://image-view";
  static const String videoPlayerPage = "app://video-player";
  static const String ticketDetail = 'app://inbox/request/detail';
  static const TICKET_COMMENT_PAGE = "app://inbox/request/detail/all-comment";

  static const String verifyOTP = "app://login/otp/verify";
  static const String building404 = "app://home/building/404";

  /*Houze Policy*/
  static const String policy = 'app://profile/personal-information/policy';
  /* HOUSE XU */
  static const String HOUSE_XU_PAGE = 'app://profile/houze-xu';
  /*Houze xu info */
  static const String HOUZE_XU_INFO_PAGE =
      'app://profile/houze-xu/infomation-houze-xu';
  /*Houze run*/
  static const MEDAL_RECTANGLE_PAGE = "app://community/run/badges";
  static const RUN_EVENT_DETAIL_PAGE = "app://community/run/challennges/detail";
  static const AWARD_INFORMATION_PAGE =
      "app://community/run/challennges/detail/target/detail";

  static const String sendRequest = 'app://home/send-a-request';
  static const RECEIPT_INFO_PAGE =
      "app://inbox/annoucement/receipt-paid/detail";

  static const String COMMUNITY_RUN_MAIN_PAGE = 'app://community/start-running';
  static const String COMMUNITY_RUN_STARTING_PAGE =
      'app://CommunityRunStartingPage';
  static const String COMMUNITY_RUN_DASHBOARD_PAGE =
      'app://community/run/running-statistic';
  static const String ROOM_CHAT_DETAIL_PAGE =
      'app://community/chat/messenger/detail';
  static const String CHAT_ROOM_SETTING_PAGE = 'app://ChatRoomSettingScreen';
  static const String CHAT_ROOM_GALLERY_PAGE = 'app://ChatRoomGalleryScreen';

/*Voucher */
  static const QRCODE_VOUCHER_PAGE = 'app://home/voucher/my-voucher/detail';
  static const String VOUCHER_LIST_PAGE = 'app://home/voucher';
  static const String MY_VOUCHER_PAGE = 'app://home/voucher/my-voucher';
  static const VOUCHER_DETAIL_PAGE =
      "app://home/services-nearby/location-infomation/voucher-detail";

  static const String parkingCardList = 'app://home/parking-card-list';
  static const String PARKING_DETAIL = 'app://parking/detail';
  static const String parkingRegistration =
      'app://home/parking-card-list/registration';
  static const String forSellLease = 'app://home/for-sell-lease';
  static const String SELL_DETAIL = 'app://home/for-sell-lease/sell-property';
  static const String SELL_CREATE = 'app://sell/create';
  static const String SELL_UPDATE =
      'app://home/for-sell-lease/sell-property/update-infomation';
  static const String HANDBOOK = 'app://home/handbook';
  static const String HANDBOOK_DETAIL = 'app://home/handbook/detail';
  static const String PROFILE = 'app://profile/personal-information';
  static const String BUILDING_INFO_PAGE = 'app://profile/building-info';
  static const String UTILITY_HISTORY =
      'app://inbox/announcement/facility-booking/my-activity';
  static const String FACILITY_BOOKING_DETAIL_PAGE =
      'app://facility-booking/my-activity/register-detail';
  static const String UTILITY_DETAIL = 'app://utilities/detail';
  static const String CHANGE_PASSWORD = 'app://password/change';
  static const String EKYC = 'app://eKYC';
  // static const String CAMERA_PAGE = 'eKYC/camera';
  static const String EKYC_PHOTO_REVIEW = 'app://eKYC/photo/review';
  static const String EKYC_REVIEW = 'app://eKYC/review';
  static const String SOS_PAGE = 'app://home/emergency';
  static const String NEAR_BY_SERVICE_PAGE = 'app://home/services-nearby/list';
  static const String PLACES_DETAIL_PAGE =
      'app://home/services-nearby/location-infomation';
  static const String SHOP_INFO_PAGE = 'app://ShopInfomationScreen';
  static const String FACILITY_LIST_PAGE = "app://home/building-facility/list";
  static const String FACILITY_DETAIL_PAGE =
      "app://home/building-facility/detail";
  static const String FACILITY_HISTORY_PAGE =
      "app://home/building-facility/detail/histories";
  static const String FACILITY_REGISTER_PAGE =
      'app://home/building-facility/detail/facility-booking';
  /* Ticket */
  static const String RATING_SERVICE_PAGE = 'app://rating_service_page';
  static const String FACILITY_DETAIL_INFORMATION =
      'app://home/building-facility/detail/information';

  static const String FACILITY_PICK_PAGE =
      'app://home/building-facility/detail/facility-booking/make-your-booking';
  static const String FACILITY_TERMS_PAGE =
      'app://home/building-facility/detail/facility-booking/regulations-terms';
  static const String FEE_INFO_PAGE = 'app://pay/invoice/detail/fee/detail';
  static const String FEED_ANNOUNCEMENT_PAGE = "app://announcement/detail";
  static const String FEED_IMPORTANT_LIST_PAGE =
      'app://announcement/important-news/list';

  /* PAYMENT */
  static const String FEE_OVERVIEW_PAGE = "app://pay/invoice/detail";
  static const String PAYMENT_FEE_CHECK_PAGE =
      "app://pay/invoice/detail/pay-for-bill";
  static const String PAYMENT_GATEWAY_PAGE =
      "app://pay/invoice/detail/pay-for-bill/payment-method";
  static const String PAYMENT_DETAIL_PAGE =
      "app://pay/history-transactions/detail";

  static const PAYMENT_BANK_TRANSFER_PAGE =
      "app://pay/invoice/detail/pay-for-bill/payment-method/manual-bank-transfer";
  static const MANUAL_TRANSFER_PAGE =
      "app://pay/invoice/detail/pay-for-bill/payment-method/manual-bank-transfer/guide";
  static const String PAYMENT_FEE_CHART_PAGE =
      "app://pay/invoice/detail/fee-chart";

  /* POLL */
  static const String VOTING_DETAIL_PAGE = 'app://VotingDetailScreen';
  static const String SOCIAL_COMMENT_PAGE = 'app://SocialCommentPage';

  /* DISCUSSION */
  static const String DISCUSSION_DETAIL_PAGE = 'app://discussionDetailScreen';
  static const String POST_THREAD_PAGE = 'app://postThreadScreen';

  Widget _getPage(String url, Object params) {
    switch (url) {
      case ROOT:
        return MainScreen();

      case LoginPage.routeName:
        return LoginPage();

      case createPassword:
        final args = params as CreatePasswordPageArgument;
        return CreatePasswordPage(agr: args);

      /*Houze Policy*/
      case policy:
        return HouzePolicyScreen();
        break;

      /*Houze run*/
      // case CHAT_ROOM_GALLERY_PAGE:
      //   return ChatRoomGalleryScreen();

      case RUN_EVENT_DETAIL_PAGE:
        var args = params as RunEventDetailScreenArgument;
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => GroupRepository(),
            ),
            RepositoryProvider(
              create: (context) => ChallengeRepository(),
            ),
          ],
          child: BlocProvider(
            create: (context) => GroupBloc(
              groupRepository: context.read<GroupRepository>(),
              challengeRepository: context.read<ChallengeRepository>(),
            ),
            child: RunEventDetailScreen(
              argument: args,
            ),
          ),
        );

      case MEDAL_RECTANGLE_PAGE:
        return MedalRectangleScreen();

      case AWARD_INFORMATION_PAGE:
        var args = params as AwardInformationScreenArgument;

        return AwardInformationScreen(
          argument: args,
        );

      case imageViewPage:
        var args = params as ImageViewPageArgument;
        return ImageViewPage(params: args);

      case videoPlayerPage:
        var args = params as VideoPlayerViewArgument;
        return VideoPlayerScreen(params: args);

      case enterPasswordPage:
        final args = params as LoginPasswordScreenArguments;
        return LoginPasswordScreen(
          args: args,
        );

      case building404:
        var args = params as NoBuildingScreenArgument;
        return NoBuildingScreen(arg: args);

      case FEED_ANNOUNCEMENT_PAGE:
        var args = params as AnnouncementScreenArgument;

        return AnnouncementScreen(argument: args);

      case RECEIPT_INFO_PAGE:
        var args = params as ReceiptInfoScreenArgument;
        return ReceiptInfoScreen(agr: args);

      case VOUCHER_LIST_PAGE:
        return VouchersScreen();

      case FEED_IMPORTANT_LIST_PAGE:
        return FeedImportantListScreen();

      case PAYMENT_FEE_CHECK_PAGE:
        return FeeCheckoutScreen(args: params);

      case FACILITY_DETAIL_PAGE:
        var args = params as FacilityDetailScreenArgument;

        return FacilityDetailScreen(
          params: args,
        );

      case FEE_INFO_PAGE:
        var args = params as FeeInfoScreenArgument;

        return FeeInfoScreen(arg: args);

      case FACILITY_PICK_PAGE:
        var args = params as FacilityPickEventScreenArgument;
        return FacilityPickEventScreen(params: args);

      case PAYMENT_GATEWAY_PAGE:
        return FeeGatewayScreen(args: params);

      case PAYMENT_DETAIL_PAGE:
        return PaymentDetailScreen(args: params);

      case PAYMENT_BANK_TRANSFER_PAGE:
        return PaymentBankTransferScreen(params);

      case MANUAL_TRANSFER_PAGE:
        return ManualTransferScreen();

      case TICKET_COMMENT_PAGE:
        var args = params as TicketCommentScreenArgument;

        return TicketCommentScreen(args: args);

      case ticketDetail:
        // return TicketScreen(args: params);
        return TicketPage(args: params);

      case SOS_PAGE:
        return SOSScreen();

      case verifyOTP:
        final args = params as VerifyOTPPageArgument;
        return VerifyOTPPage(agr: args);

      case MY_VOUCHER_PAGE:
        return MyVoucherScreen();

      case HOUZE_XU_INFO_PAGE:
        var args = params as HouzeXuInfoScreenArgument;

        return HouzeXuInfoScreen(arg: args);

      case VOUCHER_DETAIL_PAGE:
        var args = params as MyVoucherDetailScreenArgument;

        return MyVoucherDetailScreen(args: args);

      case sendRequest:
        return SendRequestPage();

      case NEAR_BY_SERVICE_PAGE:
        return NearbyScreen();

      case FACILITY_REGISTER_PAGE:
        var args = params as FacilityRegisterScreenArgument;
        return FacilityRegisterScreen(params: args);

      case QRCODE_VOUCHER_PAGE:
        var args = params as QRCodeDetailScreenArgument;

        return QRCodeDetailScreen(args: args);

      case PLACES_DETAIL_PAGE:
        var args = params as PlacesDetailScreenArgument;

        return PlacesDetailScreen(agrs: args);

      case SHOP_INFO_PAGE:
        var args = params as ShopInfomationScreenArgument;

        return ShopInfomationScreen(agrs: args);

      case parkingCardList:
        return ParkingCardListPage();

      case PARKING_DETAIL:
        final ParkingVehicle parkingVehicle = params;
        return ParkingDetail(item: parkingVehicle);

      case parkingRegistration:
        return ParkingRegistrationPage();

      case HANDBOOK:
        return HandbookScreen();

      case HANDBOOK_DETAIL:
        Handbook handbook = params;
        return HandbookDetailScreen(handbook: handbook);

      /* Facility */
      case FACILITY_TERMS_PAGE:
        var args = params as FacilityTermScreenArgument;

        return FacilityTermScreen(args: args);
      case FACILITY_BOOKING_DETAIL_PAGE:
        var args = params as FacilityBookingDetailScreenArgument;

        return FacilityBookingDetailScreen(args: args);

      case FACILITY_LIST_PAGE:
        var args = params as FacilityScreenArgument;
        return FacilityScreen(args: args);

      case FACILITY_DETAIL_INFORMATION:
        return FacilityInfoScreen(args: params);

      case FACILITY_HISTORY_PAGE:
        var args = params as FacilityHistoryScreenArgument;
        return FacilityHistoryScreen(args: args);

      case forSellLease:
        return SellListPage();

      case SELL_DETAIL:
        final SellModel item = params;

        return SellDetailPage(item: item);

      case SELL_UPDATE:
        final String id = params;
        return SellUpdatePage(id: id);

      case SELL_CREATE:
        final String type = params;
        return SellCreatePage(type: type);

      case PROFILE:
        return ProfileInfoScreen();

      case BUILDING_INFO_PAGE:
        var args = params as InfoArguments;
        return BuildingInfoScreen(
          argument: args,
        );

      case UTILITY_HISTORY:
        return UtilityHistoryScreen();

      case CHANGE_PASSWORD:
        return UpdatePasswordScreen();
      // return ChangePasswordScreen();

      // case EKYC: //VerifyIdentityScreen(),
      //   return EKYCScreen();

      // case EKYC_REVIEW:
      //   final Map<String, dynamic> map = params;

      //   return EKYCReviewScreen(args: {
      //     'title': map['title'],
      //     'sub_title': map['sub_title'],
      //     'instance': map['instance'],
      //   });

      // case EKYC_PHOTO_REVIEW:
      //   final Map<String, dynamic> map = params;
      //   return PhotoReviewScreen(
      //     args: {
      //       'title': map['title'],
      //       'sub_title': map['sub_title'],
      //       'instance': map['instance'],
      //     },
      //   );

      // case CAMERA_PAGE:
      //   final Map<String, dynamic> map = params;
      //   return CameraScreen(
      //     args: {
      //       'title': map['title'],
      //       'sub_title': map['sub_title'],
      //       'instance': map['instance'],
      //     },
      //   );

      case RATING_SERVICE_PAGE:
        return RatingServiceScreen(ticket: params);

      case FEE_OVERVIEW_PAGE:
        var args = params as FeeOverviewScreenArgument;

        return FeeOverviewScreen(
          args: args,
        );

      case PAYMENT_FEE_CHART_PAGE:
        final Map<String, dynamic> map = params;

        return FeeChartScreen(
          buildingId: map['building_id'],
          apartmentId: map['apartment_id'],
          feeType: map['fee_type'],
        );

      case COMMUNITY_RUN_MAIN_PAGE:
        return RunMainScreen();

      case COMMUNITY_RUN_STARTING_PAGE:
        final args = params as RunStartingArgument;
        return RunStartingScreen(args: args);

      case COMMUNITY_RUN_DASHBOARD_PAGE:
        return MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => DashboardBloc(
              repo: StatisticRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => StatisticChartBloc(
              repo: StatisticRepository(),
            ),
          ),
        ], child: RunDashboardScreen());

      /* House xu */
      case HOUSE_XU_PAGE:
        return HouseXuScreen();

      case ROOM_CHAT_DETAIL_PAGE:
        final args = params as ChatRoomScreenArgument;
        return ChatRoomScreen(param: args);

      // case CHAT_ROOM_SETTING_PAGE:
      //   final args = params as ChatRoomSettingScreenArgument;

      //   return ChatRoomSettingScreen(
      //     param: args,
      //   );

      /* Poll */
      case DISCUSSION_DETAIL_PAGE:
        final args = params as DiscussionDetailScreenArgument;
        print(args.toString());
        return DiscussionDetailScreen(
          argument: args,
        );

      case VOTING_DETAIL_PAGE:
        final args = params as VotingDetailArguments;
        return VotingDetailScreen(
          arg: args,
        );

      case SOCIAL_COMMENT_PAGE:
        final args = params as SocialCommentScreenArgument;
        return SocialCommentScreen(
          args: args,
        );

      case POST_THREAD_PAGE:
        final args = params as PostThreadScreenArgument;
        print(args.toString());
        return PostThreadScreen(
          argument: args,
        );
    }
    return null;
  }

  AppRouter.pushReplacementNoParams(BuildContext context, String url) {
    print('[AppRouter] pushReplacementNoParams: $url');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, null);
            },
            settings: RouteSettings(name: url)));
  }

  AppRouter.pushReplacement(BuildContext context, String url, dynamic params) {
    print('[AppRouter] pushReplacement: $url');

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, params);
            },
            settings: RouteSettings(name: url)));
  }

  AppRouter.pushNoParams(BuildContext context, String url,
      {bool maintainState: true}) {
    print('[AppRouter] pushNoParams: $url');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, null);
            },
            maintainState: maintainState,
            settings: RouteSettings(name: url)));
  }

  AppRouter.pushNoParamsWithCallback(
      BuildContext context, String url, Function callback,
      {bool maintainState: true}) {
    print('[AppRouter] pushNoParamsWithCallback: $url');

    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {
                  return _getPage(url, null);
                },
                maintainState: maintainState,
                settings: RouteSettings(name: url)))
        .then(callback);
  }

  AppRouter.pushAndRemoveUntil(BuildContext context, String url) {
    print('[AppRouter] pushAndRemoveUntil: $url');

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, null);
            },
            settings: RouteSettings(name: url)),
        (route) => false);
  }
  AppRouter.push(BuildContext context, String url, dynamic params,
      [bool maintainState = true]) {
    print('[AppRouter] push: $url \t params: $params');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _getPage(url, params);
        },
        settings: RouteSettings(name: url),
        maintainState: maintainState,
      ),
    );
  }

  AppRouter.pushParamsWithCallback(
      BuildContext context, String url, dynamic params, Function callback,
      [bool maintainState = true]) {
    print('[AppRouter] push: $url \t params: $params');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _getPage(url, params);
        },
        settings: RouteSettings(name: url),
        maintainState: maintainState,
      ),
    ).then(callback);
  }

  AppRouter.pushDialogNoParams(BuildContext context, String url,
      {bool maintainState: true}) {
    print('[AppRouter] pushDialogNoParams: $url');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _getPage(url, null);
        },
        settings: RouteSettings(name: url),
        fullscreenDialog: true,
        maintainState: maintainState,
      ),
    );
  }

  AppRouter.pushDialogNoParamsWithCallBack(
      BuildContext context, String url, Function callback,
      {bool maintainState: true}) {
    print('[AppRouter] pushDialogNoParams: $url');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _getPage(url, null);
        },
        settings: RouteSettings(name: url),
        fullscreenDialog: true,
        maintainState: maintainState,
      ),
    ).then(callback);
  }

  AppRouter.pushDialog(BuildContext context, String url, dynamic params) {
    print('[AppRouter] pushDialog: $url');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, params);
            },
            settings: RouteSettings(name: url),
            fullscreenDialog: true));
  }

  AppRouter.replaceNoParams(BuildContext context, String url) {
    print('[AppRouter] replaceNoParams: $url');

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, null);
            },
            settings: RouteSettings(name: url)));
  }

  AppRouter.replace(BuildContext context, String url, dynamic params) {
    print('[AppRouter] replace: $url');

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, params);
            },
            settings: RouteSettings(name: url)));
  }

  static void navigateToDetailFeed({
    @required BuildContext context,
    @required FeedMessageModel feed,
  }) async {
    await MailBoxController().readFeed(feed);
    final buildingId =
        feed.options.singleWhere((e) => e.key == "building_id").value;

    Sqflite.setCurrentBuildingWithId(buildingId);

    switch (feed.type) {
      case "announcement":
        AppRouter.push(
          context,
          AppRouter.FEED_ANNOUNCEMENT_PAGE,
          AnnouncementScreenArgument(
            feedMessageModel: feed,
          ),
        );
        break;

      case "ticket":
      case "ticket_comment":
			// KEVTODO: /t/1quthdr
        AppRouter.push(
          context,
          AppRouter.ticketDetail,
          TicketScreenArguments(
            refID: feed.refID,
          ),
        );
        break;

      case "facility_booking":
        AppRouter.pushNoParams(
          context,
          AppRouter.UTILITY_HISTORY,
        );
        break;

      case "fee_sent":
      case "fee_sent_2":
        (BlocRegistry.get("overlay_bloc") as OverlayBloc)
            .pageController
            .animateToPage(
              AppTabbar.payment,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
        break;

      case "receipt_sent":
      case "receipt_sent_2":
        AppRouter.push(
          context,
          AppRouter.RECEIPT_INFO_PAGE,
          ReceiptInfoScreenArgument(
            id: feed.refID,
          ),
        );
        break;

      default:
        break;
    }
  }
}
