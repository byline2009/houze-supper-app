import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/bottom_sheet/index.dart';
import 'package:houze_super/presentation/index.dart';

import 'package:houze_super/utils/index.dart';

import '../index.dart';
import 'index.dart';

typedef void InvitedMemberToLeaveTeamCallback(bool success);

class BottomSheetInvitedToLeaveTeam extends StatelessWidget {
  final MemberModel user;
  final GroupModel group;
  final ProgressHUD progressHUD;
  final InvitedMemberToLeaveTeamCallback callback;
  const BottomSheetInvitedToLeaveTeam({
    Key? key,
    required this.user,
    required this.progressHUD,
    required this.group,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetCornerWidget(
      title: user.fullname ?? '',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _invitedToLeaveTeamAction(context),
          const SizedBox(
            height: 30,
          ),
          _descriptionLine(context),
        ],
      ),
    );
  }

  Widget _descriptionLine(BuildContext context) => Text(
        LocalizationsUtil.of(context).translate(
            'k_the_feature_to_invite_members_out_of_the_team_only_applies_to_members_who_have_not_had_any_running_activities_contributing_to_the_whole_team_Members_who_leave_the_team_can_still_request_to_join_again'), //'''Tính năng mời thành viên ra khỏi đội chỉ áp dụng cho các thành viên chưa có bất cứ hoạt động chạy nào đóng góp cho toàn đội. Thành viên sau khi ra khỏi đội vẫn có thể yêu cầu tham gia lại''',
        style: AppFonts.semibold13.copyWith(
          color: Color(0xff838383),
        ),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      );

  Widget _invitedToLeaveTeamAction(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showConfirmActivityDialog(context);
        },
        child: Container(
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_forever,
                color: Color(0xffc50000),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  LocalizationsUtil.of(context)
                      .translate('k_please_leave_the_team'),
                  style: AppFonts.medium16.copyWith(
                    color: Color(0xffc50000),
                    letterSpacing: 0.26,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void showConfirmActivityDialog(BuildContext context) {
    AppDialog.showContentDialog(
      context: context,
      child: WidgetConfirmDialog(
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
            children: <TextSpan>[
              TextSpan(
                  text: LocalizationsUtil.of(context)
                          .translate('k_are_you_sure_you_want_to_invite') +
                      ' '),
              TextSpan(style: AppFonts.bold15, text: user.fullname),
              TextSpan(
                  text: ' ' +
                      LocalizationsUtil.of(context)
                          .translate('k_out_of_the_running_team')),
            ],
          ),
        ),
        confirmCallback: () {
          callback(true);
          Navigator.of(context).pop();
        },
      ),
      closeShow: false,
      barrierDismissible: true,
    );
  }
}
