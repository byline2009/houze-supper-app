import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/repo/group_repo.dart';

import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';

import '../index.dart';

class WidgetMemberItem extends StatelessWidget {
  final GroupModel group;
  final GroupRepository groupRepository;
  final EventModel event;
  final JoinedModel joined;
  final ProgressHUD progressHUD;
  final InvitedMemberToLeaveTeamCallback callback;

  const WidgetMemberItem({
    @required this.group,
    @required this.joined,
    @required this.groupRepository,
    @required this.progressHUD,
    @required this.callback,
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    final MemberModel member = joined.user;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BaseWidget.avatar(
            imageUrl: member.imageThumb,
            fullname: member.fullname,
            size: 40,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.fullname,
                  style: AppFonts.medium14.copyWith(color: Colors.black),
                  maxLines: 2,
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: AppFonts.semibold13
                            .copyWith(color: Color(0xff6001d2)),
                        children: <TextSpan>[
                          TextSpan(
                            text: StringUtil.kilometerDisplay(
                                    joined.distance.toDouble()) +
                                ' ',
                          ),
                          TextSpan(
                            text: 'km',
                            style: AppFonts.semibold13.copyWith(
                              color: Color(0xff838383),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 5, left: 5),
                      width: 2,
                      height: 13,
                      decoration: BoxDecoration(
                        color: Color(0xff838383),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            2,
                          ),
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: AppFonts.semibold13
                            .copyWith(color: Color(0xff6001d2)),
                        children: <TextSpan>[
                          TextSpan(
                              text: StringUtil.hourDisplay(
                                      joined.totalTime.toDouble()) +
                                  ' '),
                          TextSpan(
                              text: LocalizationsUtil.of(context)
                                  .translate('k_hour'), //'tiếng',
                              style: AppFonts.semibold13.copyWith(
                                color: Color(0xff838383),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _checkInviteLeaveToGroup
              ? GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      elevation: 0.0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      builder: (context) {
                        return BottomSheetInvitedToLeaveTeam(
                          user: member,
                          progressHUD: progressHUD,
                          callback: (success) async {
                            Navigator.of(context).pop();
                            if (success) {
                              progressHUD.state.show();
                              try {
                                final respone =
                                    await groupRepository.putGroupRemoveMember(
                                  userID: member.id,
                                  groupID: group.id,
                                );
                                await Future.delayed(
                                  Duration(
                                    milliseconds: 500,
                                  ),
                                );
                                if (callback != null) {
                                  callback(respone);
                                }
                              } catch (e) {
                                if (callback != null) {
                                  callback(false);
                                }
                              }
                            }
                          },
                          group: group,
                        );
                      },
                    );
                  },
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: SvgPicture.asset(
                          AppVectors.icMoreVert,
                        ),
                      ),
                    ),
                  ),
                )
              : (_checkTeamCompletedTarget)
                  ? displayHouzePoint(event.externalTarget.toString())
                  : const SizedBox.shrink()
        ],
      ),
    );
  }

/* Điều kiện để mời member ra khỏi đội
- User đang login là owner
- Chỉ hiển thị nút mời ra khỏi nhóm với member
- Member có distance = 0.00
- Group chưa hoàn thành mục tiêu
- Giải chạy chưa kết thúc
*/
  bool get _checkInviteLeaveToGroup =>
      group.createdBy.id == Storage.getUserID() &&
      group.createdBy.id != joined.user.id &&
      StringUtil.kilometerDisplay(joined.distance.toDouble()) == '0.00' &&
      joined.user.id != Storage.getUserID() &&
      group.statusRun == 0 &&
      !event.isExpired;

  bool get _checkTeamCompletedTarget => group.statusRun == 1;

  Widget displayHouzePoint(String point) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '+ ' + point,
            style: AppFonts.semibold13.copyWith(color: Color(0xffe3a500)),
          ),
          SizedBox(width: 5),
          SvgPicture.asset(AppVectors.icSmallHouzePoint),
        ],
      );
}
