import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/blocs/apartment/index.dart';
import 'package:houze_super/app/blocs/index.dart';
import 'package:houze_super/middle/api/payment_api.dart';
import 'package:houze_super/middle/model/agent_model.dart';
import 'package:houze_super/middle/model/facility/facility_detail_model.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/model/handbook_model.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/middle/repo/fee_repository.dart';
import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/sc_houze_xu_info.dart';
import 'package:houze_super/presentation/common_widgets/sc_video_player.dart';
import 'package:houze_super/presentation/screen/community/chat/views/sc_chat_room.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/view/sc_comment.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/view/sc_voting_detail.dart';
import 'package:houze_super/middle/repo/challenge_repository.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/bloc/achievement_bloc.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/views/sc_medal_rectangle.dart';
import 'package:houze_super/presentation/screen/community/run/activity/views/sc_main_running.dart';
import 'package:houze_super/presentation/screen/home/bloc/tabbar_title_bloc.dart';
import 'package:houze_super/presentation/screen/login/bloc/forgot/index.dart';
import 'package:houze_super/presentation/screen/payment/blocs/fee/index.dart';
import 'package:houze_super/presentation/screen/payment/blocs/fee_filter/index.dart';
import 'package:houze_super/presentation/screen/payment/blocs/payment/index.dart';
import 'package:houze_super/presentation/screen/payment/order/fee/blocs/index.dart';
import 'package:houze_super/presentation/screen/payment/sc_manual_transfer_guide_screen.dart';
import 'package:houze_super/presentation/screen/payment/sc_payment_transfer.dart';
import 'package:houze_super/providers/log_provider.dart';
import '../middle/repo/achievement_repo.dart';
import 'index.dart';
import 'screen/community/conversation/forum/discussion/view/sc_post_thread.dart';
import 'screen/community/run/statistic/view/sc_run_dashboard.dart';
import 'screen/home/home_tab/feed/sc_annoucement_detail.dart';
import 'screen/login/sc_verify_otp.dart';
import 'screen/parking/detail/sc_parking_detail.dart';
import 'screen/profile/sc_house_xu.dart';
import 'screen/profile/view/index.dart';

import 'common_widgets/sc_image_view.dart';
import 'screen/community/run/group/index.dart';
import 'screen/community/index.dart';
import 'screen/home/home_tab/facility/detail/history/sc_facility_history.dart';
import 'screen/home/home_tab/facility/detail/info/index.dart';
import 'screen/home/home_tab/feed/sc_feed_important_list.dart';
import 'screen/home/home_tab/nearby_service/detail/sc_places_around_detail.dart';
import 'screen/home/home_tab/nearby_service/sc_nearby_service_list.dart';
import 'screen/home/home_tab/sos/sc_sos.dart';
import 'screen/home/home_tab/voucher/index.dart';
import 'screen/home/home_tab/voucher/info/sc_info_shop.dart';
import 'screen/home/home_tab/voucher/qrcode/sc_qrcode_detail.dart';
import 'screen/home/home_tab/voucher/sc_voucher_detail.dart';
import 'screen/login/check_phone/sc_login_by_phone.dart';
import 'screen/mailbox/announcement/fee/sc_receipt_info.dart';
import 'screen/mailbox/ticket/comment/sc_ticket_comment.dart';
import 'screen/parking/sc_parking_register.dart';
import 'screen/payment/order/fee/sc_fee_chart.dart';
import 'screen/payment/sc_fee_checkout.dart';
import 'screen/payment/sc_fee_gateway.dart';
import 'screen/payment/sc_fee_info.dart';
import 'screen/payment/sc_fee_overview.dart';
import 'screen/payment/sc_payment_detail.dart';
import 'screen/profile/sc_building_info.dart';
import 'screen/profile/view/sc_change_password.dart';
import 'screen/profile/sc_utility_history.dart';
import 'screen/sc_main.dart';
import 'screen/sell/sc_sell_create.dart';
import 'screen/sell/sc_sell_detail.dart';
import 'screen/sell/sc_sell_list.dart';
import 'screen/sell/sc_sell_update.dart';
import 'screen/ticket/sc_ticket_create.dart';

class AppRouter {
  static const String ROOT = '/';
  // static const String MAIN = 'app://main';
  static const String SPLASH = 'app://splash';
  static const String LOGIN = 'app://login';
  static const CREATE_PASSWORD_PAGE = "app://CreatePasswordScreen";
  static const VIDEO_PLAYER_SCREEN = "app://VideoPlayerPage";
  static const String TICKET_DETAIL = 'app://ticket_detail';
  static const CHECK_PASSWORD_PAGE = 'app://CheckPasword';
  static const CHECK_OTP_PAGE = "app://ForgotPassword";
  static const PAGE_404_NO_BUILDING = "app://Page404NoBuilding";

  /*Houze Policy*/
  static const HOUZE_POLICY_SCREEN = 'app://HouzePolicyScreen';

  /*Houze run*/
  static const MEDAL_RECTANGLE_PAGE = "app://community/run/badges";
  static const RUN_EVENT_DETAIL_PAGE = "app://RunEventScreen";
  static const AWARD_INFORMATION_SCREEN = "app://AwardInformationScreen";

  static const TICKET_COMMENT_PAGE = "app://TicketCommentPage";

  static const String TICKET_CREATE = 'app://TicketCreate';
  static const RECEIPT_INFO_PAGE = "app://ReceiptInfoPage";

  static const String COMMUNITY_RUN_MAIN_PAGE = 'app://CommunityRunMainPage';
  static const String COMMUNITY_RUN_STARTING_PAGE =
      'app://CommunityRunStartingPage';
  static const String COMMUNITY_RUN_DASHBOARD_PAGE =
      'app://CommunityRunDashboardScreen';
  static const String ROOM_CHAT_DETAIL_SCREEN =
      'app://CommunityMessengerDetailScreen';
  static const String CHAT_ROOM_SETTING_SCREEN = 'app://ChatRoomSettingScreen';
  static const String CHAT_ROOM_GALLERY_SCREEN = 'app://ChatRoomGalleryScreen';

/*Voucher */
  static const QRCODE_VOUCHER_SCREEN = 'app://QRCODE_VOUCHER_SCREEN';
  static const String VOUCHER_LIST_PAGE = 'app://voucher_list_page';
  static const String MY_VOUCHER_SCREEN = 'app://MY_VOUCHER_SCREEN';
  static const VOUCHER_DETAIL_SCREEN = "app://VOUCHER_DETAIL_SCREEN";

  static const String SHOW_INFO = '/show_info';
  static const String PARKING = '/parking';
  static const String PARKING_DETAIL = '/parking/';
  static const String PARKING_REGISTER = '/parking/register';
  static const String SELL = '/sell';
  static const String SELL_DETAIL = '/sell/';
  static const String SELL_CREATE = '/sell/create';
  static const String SELL_UPDATE = '/sell/update';
  static const String HANDBOOK = '/notebook';
  static const String HANDBOOK_DETAIL = '/notebook/';
  static const String PROFILE = '/profile';
  static const String BUILDING_INFO_PAGE = '/building';
  static const String UTILITY_HISTORY = '/utilities';
  static const String UTILITY_DETAIL = '/utilities/';
  static const String CHANGE_PASSWORD = '/change-password';
  static const String EKYC = '/eKYC';
  static const String CAMERA_SCREEN = 'eKYC/camera';
  static const String EKYC_PHOTO_REVIEW = 'eKYC/photo-review';
  static const String EKYC_REVIEW = '/eKYC/review';
  static const String SOS_PAGE = 'app:/sos_page';
  static const String NEAR_BY_SERVICE_PAGE = 'app://near_by_service';
  static const String PLACES_DETAIL_PAGE = 'app://places_detail_page';
  static const String SHOP_INFO_PAGE = 'app://ShopInfomationScreen';
  static const String FACILITY_LIST_PAGE = "app://facility_list_screen";
  static const String FACILITY_DETAIL_PAGE = "app://facility_detail_screen";
  static const String FACILITY_HISTORY_PAGE =
      "app://facility_detail_load_histories_screen";
  static const String FACILITY_REGISTER_PAGE = 'app://FacilityRegisterScreen';
  /* Ticket */
  static const String RATING_SERVICE_PAGE = 'app://rating_service_page';
  static const String FACILITY_DETAIL_INFORMATION =
      'app://facility_detail_information';
  static const String FACILITY_BOOKING_DETAIL_PAGE =
      'app://FacilityBookingDetailScreen';
  static const String FACILITY_PICK_SCREEN = 'app://FacilityPickEventScreen';
  static const String FACILITY_TERMS_PAGE = 'app://FacilityTermsPage';
  static const String FEE_INFO_PAGE = 'app://FEE_INFO_PAGE';
  static const String FEED_ANNOUNCEMENT_PAGE = "app://TabViewFeed";
  static const String FEED_IMPORTANT_LIST_PAGE =
      'app://FeedImportantListScreen';

  /* PAYMENT */
  static const String PAYMENT_FEE_OVERVIEW_PAGE =
      "app://PaymentFeeOverviewPage";
  static const String PAYMENT_FEE_CHECK_PAGE = "app://PaymentFeeCheckPage";
  static const String PAYMENT_GATEWAY_PAGE = "app://PaymentGatewayPage";
  static const String PAYMENT_DETAIL_PAGE = "app://PaymentDetailScreen";

  static const PAYMENT_BANK_TRANSFER_SCREEN = "app://PaymentBankTransferScreen";
  static const MANUAL_TRANSFER_SCREEN = "app://ManualTransferScreen";
  static const String PAYMENT_FEE_CHART_SCREEN = "app://PaymentFeeChartScreen";

  /* HOUSE XU */
  static const String HOUSE_XU_PAGE = 'app://HouseXuScreen';

  /*Houze xu info */
  static const String HOUZE_XU_INFO_PAGE =
      'app://profile/houze-xu/infomation-houze-xu';

  /* POLL */
  static const String VOTING_DETAIL_PAGE = 'app://VotingDetailScreen';
  static const String SOCIAL_COMMENT_PAGE = 'app://SocialCommentPage';

  /* DISCUSSION */
  static const String DISCUSSION_DETAIL_PAGE = 'app://discussionDetailScreen';
  static const String POST_THREAD_PAGE = 'app://postThreadScreen';
  static const String imageViewPage = "app://image-view";
  static LogProvider get logger => const LogProvider('👉👉 AppRouter');

  Widget? _getPage(String url, Object? params) {
    switch (url) {
      case ROOT:
        return MainScreen();

      /*Houze Policy*/
      case HOUZE_POLICY_SCREEN:
        return HouzePolicyScreen();

      /*Houze run*/
      // case CHAT_ROOM_GALLERY_SCREEN:
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
              groupRepository: RepositoryProvider.of<GroupRepository>(context),
              challengeRepository:
                  RepositoryProvider.of<ChallengeRepository>(context),
            ),
            child: RunEventDetailScreen(
              argument: args,
            ),
          ),
        );

      case MEDAL_RECTANGLE_PAGE:
        return BlocProvider(
          create: (context) => AchievementBloc(
            repo: AchievementRepository(),
          ),
          child: MedalRectangleScreen(),
        );

      case AWARD_INFORMATION_SCREEN:
        var args = params as AwardInformationScreenArgument;

        return AwardInformationScreen(
          argument: args,
        );

      case imageViewPage:
        var args = params as ImageViewPageArgument;
        return ImageViewPage(params: args);

      case VIDEO_PLAYER_SCREEN:
        var args = params as VideoPlayerViewArgument;
        return VideoPlayerScreen(params: args);

      case LOGIN:
        return LoginPhoneScreen();

      case CREATE_PASSWORD_PAGE:
        var args = params as CreatePasswordScreenArgument;
        return CreatePasswordScreen(agr: args);

      case CHECK_PASSWORD_PAGE:
        var args = params as LoginPasswordScreenArguments;
        return BlocProvider(
          create: (context) => LoginBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
          child: LoginPasswordScreen(args: args),
        );

      case PAGE_404_NO_BUILDING:
        return BlocProvider(
          create: (context) => OverlayBloc(),
          child: NoBuildingScreen(),
        );

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
        var args = params as FeeCheckoutScreenArgument;

        return FeeCheckoutScreen(args: args);

      case FACILITY_DETAIL_PAGE:
        var args = params as FacilityDetailScreenArgument;

        return FacilityDetailScreen(
          params: args,
        );

      case FEE_INFO_PAGE:
        var args = params as FeeInfoScreenArgument;

        return FeeInfoScreen(arg: args);

      case FACILITY_PICK_SCREEN:
        var args = params as FacilityPickEventScreenArgument;
        return FacilityPickEventScreen(params: args);

      case PAYMENT_GATEWAY_PAGE:
        var args = params as FeeGatewayScreenArgument;
        return RepositoryProvider(
          create: (context) => PaymentRepository(api: PaymentAPI()),
          child: BlocProvider<FeeGatewayBloc>(
            create: (contex) => FeeGatewayBloc(
              filterBloc: FeeFilterBloc(
                feeRepository: FeeRepository(),
              ),
              paymentBloc: PaymentBloc(
                  paymentRepository: contex.read<PaymentRepository>()),
            ),
            child: FeeGatewayScreen(args: args),
          ),
        );

      // return FeeGatewayScreen(args: args);

      case PAYMENT_DETAIL_PAGE:
        var args = params as PaymentDetailScreenArgument;
        return RepositoryProvider(
          create: (context) => PaymentRepository(api: PaymentAPI()),
          child: BlocProvider(
            create: (context) => PaymentBloc(
                paymentRepository: context.read<PaymentRepository>()),
            child: PaymentDetailScreen(args: args),
          ),
        );

      case PAYMENT_BANK_TRANSFER_SCREEN:
        var args = params as PaymentBankTransferArguments;
        return RepositoryProvider(
          create: (context) => PaymentRepository(api: PaymentAPI()),
          child: BlocProvider(
            create: (context) => PaymentBloc(
                paymentRepository: context.read<PaymentRepository>()),
            child: PaymentBankTransferScreen(args),
          ),
        );
      case MANUAL_TRANSFER_SCREEN:
        return ManualTransferScreen();

      case TICKET_COMMENT_PAGE:
        var args = params as TicketCommentScreenArgument;

        return TicketCommentScreen(args: args);

      case TICKET_DETAIL:
        var args = params as TicketScreenArguments;
        return TicketScreen(args: args);

      case SOS_PAGE:
        return SOSScreen();

      case CHECK_OTP_PAGE:
        var args = params as VerifyOTPScreenArgument;

        return BlocProvider(
            child: VerifyOTPScreen(agr: args),
            create: (context) => ForgotBloc());

      case MY_VOUCHER_SCREEN:
        return MyVoucherScreen();

      case HOUZE_XU_INFO_PAGE:
        var args = params as HouzeXuInfoPageArgument;

        return HouzeXuInfoPage(arg: args);

      case VOUCHER_DETAIL_SCREEN:
        var args = params as MyVoucherDetailScreenArgument;

        return MyVoucherDetailScreen(args: args);

      case TICKET_CREATE:
        return SendRequestPage();

      case NEAR_BY_SERVICE_PAGE:
        return NearbyScreen();

      case FACILITY_REGISTER_PAGE:
        var args = params as FacilityRegisterScreenArgument;
        return FacilityRegisterScreen(params: args);

      case QRCODE_VOUCHER_SCREEN:
        var args = params as QRCodeDetailScreenArgument;

        return QRCodeDetailScreen(args: args);

      case PLACES_DETAIL_PAGE:
        var args = params as PlacesDetailScreenArgument;

        return PlacesDetailScreen(agrs: args);

      case SHOP_INFO_PAGE:
        var args = params as ShopInfomationScreenArgument;

        return ShopInfomationScreen(agrs: args);

      case PARKING:
        // return ParkingScreen();
        return ParkingPage();

      case PARKING_DETAIL:
        var parkingVehicle = params as ParkingVehicle;
        return ParkingDetail(item: parkingVehicle);

      case PARKING_REGISTER:
        return ParkingRegisterPage();

      case HANDBOOK:
        return HandbookScreen();

      case HANDBOOK_DETAIL:
        var handbook = params as Handbook;
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
        var args = params as FacilityDetailModel;
        return FacilityInfoScreen(args: args);

      case FACILITY_HISTORY_PAGE:
        var args = params as FacilityHistoryScreenArgument;
        return FacilityHistoryScreen(args: args);

      case SELL:
        return SellListPage();

      case SELL_DETAIL:
        var item = params as SellModel;

        return SellDetailPage(item: item);

      case SELL_UPDATE:
        var id = params as String;

        return SellUpdatePage(id: id);

      case SELL_CREATE:
        var type = params as String;

        return SellCreatePage(type: type);

      case PROFILE:
        return ProfileInfoScreen();

      case BUILDING_INFO_PAGE:
        var args = params as InfoArguments;
        return RepositoryProvider(
          create: (context) => ApartmentRepository(),
          child: MultiBlocProvider(
            providers: <BlocProvider>[
              BlocProvider<OverlayBloc>(create: (_) => OverlayBloc()),
              // BlocProvider<ApartmentBloc>(
              //     create: (context) => ApartmentBloc(
              //         apartmentRepo: context.read<ApartmentRepository>())),
              BlocProvider<ApartmentDetailBloc>(
                create: (context) => ApartmentDetailBloc(
                    apartmentRepo: context.read<ApartmentRepository>()),
              ),
              BlocProvider<TabbarTitleBloc>(
                  create: (_) => TabbarTitleBloc(service: "")),
            ],
            child: BuildingInfoScreen(
              argument: args,
            ),
          ),
        );

      case UTILITY_HISTORY:
        return UtilityHistoryScreen();

      case CHANGE_PASSWORD:
        return UpdatePasswordScreen();
      // return ChangePasswordScreen();

      // case EKYC: //VerifyIdentityScreen(),
      //   return EKYCScreen();

      // case EKYC_REVIEW:
      //   var map = params as Map<String, dynamic>;

      //   return EKYCReviewScreen(args: {
      //     'title': map['title'],
      //     'sub_title': map['sub_title'],
      //     'instance': map['instance'],
      //   });

      // case EKYC_PHOTO_REVIEW:
      //   var map = params as Map<String, dynamic>;

      //   return PhotoReviewScreen(
      //     args: {
      //       'title': map['title'],
      //       'sub_title': map['sub_title'],
      //       'instance': map['instance'],
      //     },
      //   );

      // case CAMERA_SCREEN:
      //   var map = params as Map<String, dynamic>;

      //   return CameraScreen(
      //     args: {
      //       'title': map['title'],
      //       'sub_title': map['sub_title'],
      //       'instance': map['instance'],
      //     },
      //   );

      case RATING_SERVICE_PAGE:
        var ticket = params as TicketDetailModel;

        return RatingServiceScreen(ticket: ticket);

      case PAYMENT_FEE_OVERVIEW_PAGE:
        var args = params as FeeOverviewScreenArgument;

        return RepositoryProvider(
          create: (context) => ApartmentRepository(),
          child: MultiBlocProvider(
            providers: <BlocProvider>[
              BlocProvider<ApartmentBloc>(
                  create: (_) => ApartmentBloc(
                        apartmentRepo: ApartmentRepository(),
                      )),
              BlocProvider<FeeBloc>(create: (_) => FeeBloc()),
            ],
            child: FeeOverviewScreen(
              args: args,
            ),
          ),
        );

      case PAYMENT_FEE_CHART_SCREEN:
        var map = params as Map<String, dynamic>;

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
        return DashboardPage();

      /* House xu */
      case HOUSE_XU_PAGE:
        return HouseXuScreen();

      case ROOM_CHAT_DETAIL_SCREEN:
        final args = params as ChatRoomScreenArgument;
        return ChatRoomScreen(param: args);

      // case CHAT_ROOM_SETTING_SCREEN:
      //   final args = params as ChatRoomSettingScreenArgument;

      //   return ChatRoomSettingScreen(
      //     param: args,
      //   );

      /* Poll */
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
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, null)!;
            },
            settings: RouteSettings(name: url)));
  }

  AppRouter.pushReplacement(BuildContext context, String url, dynamic params) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, params)!;
            },
            settings: RouteSettings(name: url)));
  }

  AppRouter.pushNoParams(BuildContext context, String url,
      {bool maintainState: true}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, null)!;
            },
            maintainState: maintainState,
            settings: RouteSettings(name: url)));
  }

  AppRouter.pushNoParamsWithCallback(BuildContext context, String url,
      FutureOr<dynamic> Function(dynamic) callback,
      {bool maintainState: true}) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) {
                  return _getPage(url, null)!;
                },
                maintainState: maintainState,
                settings: RouteSettings(name: url)))
        .then(callback);
  }

  AppRouter.pushAndRemoveUntil(BuildContext context, String url) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, null)!;
            },
            settings: RouteSettings(name: url)),
        (route) => false);
  }
  AppRouter.push(BuildContext context, String url, dynamic params,
      [bool maintainState = true]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _getPage(url, params)!;
        },
        settings: RouteSettings(name: url),
        maintainState: maintainState,
      ),
    );
  }

  AppRouter.pushParamsWithCallback(BuildContext context, String url,
      dynamic params, FutureOr<dynamic> Function(dynamic) callback,
      [bool maintainState = true]) {
    print('[AppRouter] push: $url \t params: $params');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _getPage(url, params)!;
        },
        settings: RouteSettings(name: url),
        maintainState: maintainState,
      ),
    ).then(callback);
  }

  AppRouter.pushDialogNoParams(BuildContext context, String url,
      {bool maintainState: true}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _getPage(url, null)!;
        },
        settings: RouteSettings(name: url),
        fullscreenDialog: true,
        maintainState: maintainState,
      ),
    );
  }
  AppRouter.pushDialogNoParamsWithCallBack(
    BuildContext context,
    String url,
    FutureOr<dynamic> Function(dynamic) callback, {
    bool maintainState: true,
  }) {
    print('[AppRouter] pushDialogNoParamsWithCallBack: $url');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _getPage(url, null)!;
        },
        settings: RouteSettings(name: url),
        fullscreenDialog: true,
        maintainState: maintainState,
      ),
    ).then(callback);
  }

  AppRouter.pushDialog(BuildContext context, String url, dynamic params) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _getPage(url, params)!;
        },
        settings: RouteSettings(name: url),
        fullscreenDialog: true,
      ),
    );
  }

  AppRouter.replaceNoParams(BuildContext context, String url) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, null)!;
            },
            settings: RouteSettings(name: url)));
  }

  AppRouter.replace(BuildContext context, String url, dynamic params) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) {
              return _getPage(url, params)!;
            },
            settings: RouteSettings(name: url)));
  }

  static void navigateToDetailFeed({
    required BuildContext context,
    required FeedMessageModel feed,
  }) async {
    await MailBoxController().readFeed(feed);
    final buildingId =
        feed.options!.singleWhere((e) => e.key == "building_id").value;

    await Sqflite.setCurrentBuildingWithId(buildingId);

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
        AppRouter.push(
          context,
          AppRouter.TICKET_DETAIL,
          TicketScreenArguments(
            refID: feed.refID!,
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
        await (BlocRegistry.get("overlay_bloc") as OverlayBloc)
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
            id: feed.refID!,
          ),
        );
        break;

      default:
        break;
    }
  }
}
