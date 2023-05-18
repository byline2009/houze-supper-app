import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/app/blocs/bloc_registry.dart';
import 'package:houze_super/app/blocs/overlay/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/middle/repo/ticket_repository.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/model/point_earn_model.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/networking/repository/point_earn_repo.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/widgets/widget_points_info.dart';
import 'package:houze_super/presentation/common_widgets/textfield_widget.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/login/widget_title.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/rating/widget_staff_header.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';

//---SCREEN: Đánh giá dịch vụ---//
class RatingServiceScreen extends StatefulWidget {
  final TicketDetailModel ticket;

  const RatingServiceScreen({Key? key, required this.ticket}) : super(key: key);

  @override
  RatingServiceScreenState createState() => RatingServiceScreenState();
}

class RatingServiceScreenState extends RouteAwareState<RatingServiceScreen> {
  List<TicketRatingTitleModel> listRatingStar = RatingSettings.listRating5Star;
  List<bool> isSelectIndexRating = [false, false, false, false];
  String titleRatingStar = "please_choose_your_rating";
  late GridView gridViewRating;
  var ratingModel = RatingModel();
  final fdescription = TextFieldWidgetController();
  ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();
  final rpTicket = TicketRepository();
  final _sendButtonController = StreamController<ButtonSubmitEvent>.broadcast();

  final String buildingId = Sqflite.currentBuildingID;
  final rpXu = PointEarnRepository();
  PointEarnModel? _xuEarn;

  Future<void> getXuEarnInfo() async {
    var xu = await rpXu.getXuEarnInfo(buildingId);

    setState(() {
      _xuEarn = xu;
    });
  }

  @override
  void initState() {
    getXuEarnInfo();
    super.initState();
  }

  @override
  void dispose() {
    _sendButtonController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: GestureDetector(
          onTap: () {
            bool isKeyboardShowing =
                MediaQuery.of(context).viewInsets.bottom > 0;
            if (isKeyboardShowing) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            }
          },
          child: _buildBody()),
    );
  }

  _buildAppbar() => AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: AppColor.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          LocalizationsUtil.of(context).translate('please_rate_our_service'),
          style: AppFonts.medium16.copyWith(letterSpacing: -0.3),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      );

  _buildBody() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              if (_xuEarn != null && _xuEarn!.ticketRatingAward != 0)
                WidgetXuInfo(
                  textContent:
                      '${LocalizationsUtil.of(context).translate('get_it_now')} ${StringUtil.numberFormat(_xuEarn!.ticketRatingAward)} ${LocalizationsUtil.of(context).translate('points_for_every_review')}',
                  disabledChangeBuilding: true,
                ),
              WidgetStaffHeader(ticket: widget.ticket),
              makeRatingTitle(),
              makeRatingStar(),
              makeComment(),
              makeSendButton()
            ],
          ),
          progressToolkit
        ],
      ),
    );
  }

  makeRatingTitle() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: TitleWidget(titleRatingStar)));
  }

  Widget makeRatingStar() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: RatingBar(
                initialRating: 0,
                glow: false,
                glowColor: Colors.yellow[100],
                direction: Axis.horizontal,
                itemPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                allowHalfRating: false,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: SvgPicture.asset(AppVectors.ic_star),
                  empty: SvgPicture.asset(AppVectors.ic_star_unrate),
                  half: SvgPicture.asset(AppVectors.ic_star_unrate),
                ),
                onRatingUpdate: (rating) {
                  isSelectIndexRating = [false, false, false, false];
                  switch (rating.toInt()) {
                    case 0:
                      setState(() {
                        listRatingStar = RatingSettings.listRating1Star;
                        titleRatingStar = LocalizationsUtil.of(context)
                            .translate("please_choose_your_rating");
                        ratingModel.rating = 0;
                        _sendButtonController.add(ButtonSubmitEvent(false));
                      });
                      break;
                    case 1:
                      setState(() {
                        listRatingStar = RatingSettings.listRating1Star;
                        titleRatingStar =
                            LocalizationsUtil.of(context).translate("poor");
                        ratingModel.rating = 1;
                        _sendButtonController.add(ButtonSubmitEvent(true));
                      });
                      break;
                    case 2:
                      setState(() {
                        listRatingStar = RatingSettings.listRating2Star;
                        titleRatingStar =
                            LocalizationsUtil.of(context).translate("fair");
                        ratingModel.rating = 2;
                        _sendButtonController.add(ButtonSubmitEvent(true));
                      });
                      break;
                    case 3:
                      setState(() {
                        listRatingStar = RatingSettings.listRating3Star;
                        titleRatingStar =
                            LocalizationsUtil.of(context).translate("good");
                        ratingModel.rating = 3;
                        _sendButtonController.add(ButtonSubmitEvent(true));
                      });
                      break;
                    case 4:
                      setState(() {
                        listRatingStar = RatingSettings.listRating4Star;
                        titleRatingStar = LocalizationsUtil.of(context)
                            .translate("very_good");
                        ratingModel.rating = 4;
                        _sendButtonController.add(ButtonSubmitEvent(true));
                      });
                      break;
                    case 5:
                      setState(() {
                        listRatingStar = RatingSettings.listRating5Star;
                        titleRatingStar = LocalizationsUtil.of(context)
                            .translate("excellent");
                        ratingModel.rating = 5;
                        _sendButtonController.add(ButtonSubmitEvent(true));
                      });
                      break;
                  }
                })));
  }

  Widget makeComment() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(LocalizationsUtil.of(context).translate("feedback_with_colon"),
              style: AppFonts.regular14),
          SizedBox(height: 10),
          TextFieldWidget(
            controller: fdescription,
            defaultHintText: 'write_your_feedback',
            keyboardType: TextInputType.multiline,
            callback: (String value) {
              ratingModel.review = value;
//            this.checkValidation();
            },
          ),
        ],
      ),
    );
  }

  Widget makeSendButton() {
    return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
          child: ButtonWidget(
              defaultHintText:
                  LocalizationsUtil.of(context).translate('send_your_rating'),
              isActive: false,
              controller: _sendButtonController,
              callback: () {
                sendRatingReview(context);
              }),
        ));
  }

  Future<void> sendRatingReview(BuildContext context) async {
    progressToolkit.state.show();
    progressToolkit.state.update(0);

    TicketDetailModel ticket = widget.ticket;
    ratingModel.ticketID = ticket.id;
    ratingModel.quickReview = [];
    if (ratingModel.rating == null) ratingModel.rating = 5;
    for (var i = 0; i < isSelectIndexRating.length; ++i) {
      if (isSelectIndexRating[i] == true) ratingModel.quickReview!.add(i + 1);
    }
    if (ratingModel.quickReview!.length == 0) ratingModel.quickReview = null;
    try {
      final result = await rpTicket.sendRatingReview(ratingModel);
      if (result == true) {
        ratingModel = RatingModel();
        showSuccessfulDialog(context);
      }
    } catch (e) {
      AppDialog.showAlertDialog(
        context,
        null,
        'there_is_an_issue_please_try_again_later_1',
      );
    } finally {
      progressToolkit.state.dismiss();
    }
  }

  void showSuccessfulDialog(BuildContext context) {
    AppDialog.showContentDialog(
      context: context,
      child: Container(
        height: 329,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            SvgPicture.asset(AppVectors.ic_review),
            SizedBox(height: 15),
            Text(
                LocalizationsUtil.of(context)
                    .translate('thank_you_for_your_rating'),
                textAlign: TextAlign.center,
                style: AppFonts.bold18
                    .copyWith(fontFamily: AppFont.font_family_display)),
            SizedBox(height: 20),
            Text(
                LocalizationsUtil.of(context).translate(
                    "building_management_will_continually_improve_to_bring_a_better_experience"),
                textAlign: TextAlign.center,
                style: AppFonts.regular15
                    .copyWith(
                      color: Color(
                        0xff808080,
                      ),
                    )
                    .copyWith(
                        letterSpacing: 0.24,
                        fontFamily: AppFont.font_family_display)),
            SizedBox(height: 40),
            WidgetButton.pink(
              LocalizationsUtil.of(context).translate('back_to_home_page'),
              callback: () {
                // Firebase analytics
                GetIt.instance<FBAnalytics>().sendEventSendRatingReview(
                    userID: Storage.getUserID() ?? "");
                Navigator.of(context).popUntil(
                  (route) {
                    print(route.settings.name);
                    if (route.settings.name == AppRouter.ROOT) {
                      (BlocRegistry.get("overlay_bloc") as OverlayBloc)
                          .pageController
                          .jumpToPage(AppTabbar.home);
                      return true;
                    }
                    return false;
                  },
                );
              },
            ),
          ],
        ),
      ),
      closeShow: false,
      barrierDismissible: true,
    );
  }
}
