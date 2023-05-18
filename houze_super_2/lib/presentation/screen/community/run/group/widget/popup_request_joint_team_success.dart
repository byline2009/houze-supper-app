import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/group/widget/index.dart';

class PopupJoinTeam {
  static void showSuccess({
    required BuildContext context,
    required String code,
    required UpdateGroupDetailCallback callback,
  }) {
    AppDialog.showContentDialog(
        context: context,
        child: Container(
          height: 329,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(AppVectors.icSaleRent),
              const SizedBox(height: 15),
              Text(LocalizationsUtil.of(context).translate('k_sent_request'),
                  textAlign: TextAlign.center,
                  style: AppFonts.bold.copyWith(fontSize: 18)),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
                  children: <TextSpan>[
                    TextSpan(
                        text: LocalizationsUtil.of(context)
                                .translate('k_request_sent_to_the_group') +
                            ' '),
                    TextSpan(text: code, style: AppFonts.bold15),
                    TextSpan(
                        text: '\n' +
                            LocalizationsUtil.of(context).translate(
                                'k_you_will_have_to_wait_for_the_captain_to_review')),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              WidgetButton.pink(
                LocalizationsUtil.of(context).translate('k_back_to_main_page'),
                callback: () {
                  Navigator.of(context).popUntil(
                    (route) {
                      if (route.settings.name ==
                          AppRouter.RUN_EVENT_DETAIL_PAGE) {
                        callback(true);
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
        barrierDismissible: false);
  }

  static void showNotFound({
    required BuildContext context,
    required String code,
  }) {
    String _code = code.length > 10 ? '${code.substring(0, 10)}...' : code;
    AppDialog.showContentDialog(
        context: context,
        child: Container(
          height: 329,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(AppVectors.icFoundNotTeam),
              SizedBox(height: 15),
              Text(
                  LocalizationsUtil.of(context)
                      .translate('k_the_group_could_not_be_found'),
                  textAlign: TextAlign.center,
                  style: AppFonts.bold.copyWith(fontSize: 18)),
              SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
                  children: <TextSpan>[
                    TextSpan(
                        text: LocalizationsUtil.of(context).translate(
                                'k_the_system_could_not_find_the_group') +
                            ' '),
                    TextSpan(text: _code, style: AppFonts.bold15),
                    TextSpan(
                        text: '\n' +
                            LocalizationsUtil.of(context).translate(
                                'k_please_double_check_the_team_code')),
                  ],
                ),
              ),
              SizedBox(height: 40),
              WidgetButton.pink(
                  LocalizationsUtil.of(context).translate('try_again'),
                  callback: () {
                Navigator.of(context).pop();
              }),
            ],
          ),
        ),
        closeShow: false,
        barrierDismissible: false);
  }

  static void showUserCannotJoin({
    required BuildContext context,
    required String code,
  }) {
    AppDialog.showContentDialog(
        context: context,
        child: Container(
          height: 329,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(AppVectors.icFoundNotTeam),
              SizedBox(height: 15),
              Text(LocalizationsUtil.of(context).translate('k_can_not_join'),
                  textAlign: TextAlign.center,
                  style: AppFonts.bold.copyWith(fontSize: 18)),
              SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
                  children: <TextSpan>[
                    TextSpan(
                        text: LocalizationsUtil.of(context)
                                .translate('k_currently_the_group') +
                            ' '),
                    TextSpan(text: code, style: AppFonts.bold15),
                    TextSpan(
                        text: ' ' +
                            LocalizationsUtil.of(context).translate(
                                'k_the_goal_has_been_reached_you_cannot_request_to_join')),
                  ],
                ),
              ),
              SizedBox(height: 40),
              WidgetButton.pink(
                  LocalizationsUtil.of(context).translate('try_again'),
                  callback: () {
                Navigator.of(context).pop();
              }),
            ],
          ),
        ),
        closeShow: false,
        barrierDismissible: false);
  }

  static void showError({
    required BuildContext context,
    required String code,
  }) {
    AppDialog.showContentDialog(
        context: context,
        child: Container(
          height: 329,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(AppVectors.icFoundNotTeam),
              SizedBox(height: 15),
              Text(LocalizationsUtil.of(context).translate('k_can_not_join'),
                  textAlign: TextAlign.center,
                  style: AppFonts.bold.copyWith(fontSize: 18)),
              SizedBox(height: 20),
              Text(LocalizationsUtil.of(context)
                  .translate('there_is_an_issue_please_try_again_later_0')),
              SizedBox(height: 40),
              WidgetButton.pink(
                  LocalizationsUtil.of(context).translate('try_again'),
                  callback: () {
                Navigator.of(context).pop();
              }),
            ],
          ),
        ),
        closeShow: false,
        barrierDismissible: false);
  }

  static void showTeamFull({
    required BuildContext context,
    required String code,
  }) {
    AppDialog.showContentDialog(
        context: context,
        child: Container(
          height: 329,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(AppVectors.icFoundNotTeam),
              SizedBox(height: 15),
              Text(LocalizationsUtil.of(context).translate('k_can_not_join'),
                  textAlign: TextAlign.center,
                  style: AppFonts.bold.copyWith(fontSize: 18)),
              SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
                  children: <TextSpan>[
                    TextSpan(
                        text: LocalizationsUtil.of(context)
                                .translate('k_currently_the_group') +
                            ' '),
                    TextSpan(text: code, style: AppFonts.bold15),
                    TextSpan(
                        text: ' ' +
                            LocalizationsUtil.of(context).translate(
                                'k_enough_members._You_cannot_request_to_join')),
                  ],
                ),
              ),
              SizedBox(height: 40),
              WidgetButton.pink(
                  LocalizationsUtil.of(context).translate('try_again'),
                  callback: () {
                Navigator.of(context).pop();
              }),
            ],
          ),
        ),
        closeShow: false,
        barrierDismissible: false);
  }
}
