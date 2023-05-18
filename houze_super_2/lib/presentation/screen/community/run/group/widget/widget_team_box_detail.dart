import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/middle/ws/chat_controller.dart';
import 'package:houze_super/presentation/screen/community/chat/models/last_message_model.dart';
import 'package:houze_super/presentation/screen/community/chat/models/user_model.dart';
import 'package:houze_super/presentation/screen/community/chat/views/sc_chat_room.dart';
import 'package:houze_super/presentation/screen/community/index.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';

import 'index.dart';

class TeamDetailBoxWidget extends StatelessWidget {
  final GroupModel group;
  final EventModel event;
  final ProgressHUD progressHUD;
  final GroupRepository groupRepository;
  final InvitedMemberToLeaveTeamCallback removeMemberCallback;

  const TeamDetailBoxWidget({
    Key? key,
    required this.group,
    required this.event,
    required this.progressHUD,
    required this.removeMemberCallback,
    required this.groupRepository,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<JoinedModel> members = group.joined!;
    return DottedBorder(
      padding: const EdgeInsets.all(0),
      borderType: BorderType.RRect,
      radius: Radius.circular(5),
      strokeCap: StrokeCap.square,
      color: Color(0xffd0d0d0),
      strokeWidth: 2,
      dashPattern: [1, 1],
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StackAvatarHorizontal(
                    users: members,
                  ),
                  chatBubble(context),
                ],
              ),
              const SizedBox(height: 20),
              DistanceAndTimeStatistic(
                distance: group.distance?.toDouble() ?? 0.0,
                accumulationTime: group.totalTime?.toDouble() ?? 0,
              ),
              const SizedBox(height: 20),
              linearProgressBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: RichText(
                        text: TextSpan(
                          style: AppFonts.semibold13,
                          children: <TextSpan>[
                            TextSpan(
                              text: LocalizationsUtil.of(context)
                                      .translate('k_remain') +
                                  ': ',
                              style: AppFonts.semibold13.copyWith(
                                color: Color(0xff838383),
                              ),
                            ),
                            TextSpan(
                                text: event.getDaysLeft(context)! +
                                    " " +
                                    LocalizationsUtil.of(context)
                                        .translate('k_day'),
                                style: AppFont.SEMIBOLD_BLACK_13)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(
                            style: AppFonts.semibold13,
                            children: <TextSpan>[
                              TextSpan(
                                text: LocalizationsUtil.of(context)
                                        .translate('k_target') +
                                    ': ',
                                style: AppFonts.semibold13.copyWith(
                                  color: Color(0xff838383),
                                ),
                              ),
                              TextSpan(text: event.targetRunUnit),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              displayProgressTargetLine(),
              membersInTeam(members),
              _checkShowInviteMemberToGroup
                  ? InvitedMemberByCode(
                      code: group.code ?? '',
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Widget chatBubble(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ChatController().userRequestJoinRoomFromTeam(
          refID: group.id ?? '',
          title: group.name ?? '',
        );
        List<UserModel> users = [];
        if (group.joined!.length > 0) {
          users = group.joined!
              .map(
                (e) => UserModel(
                  userId: e.user?.id,
                  userAvatar: e.user?.imageThumb ?? '',
                  userFullName: e.user?.fullname ?? '',
                ),
              )
              .toList();
        }
        AppRouter.push(
          context,
          AppRouter.ROOM_CHAT_DETAIL_SCREEN,
          ChatRoomScreenArgument(
            roomID: '',
            groupRefID: group.id!,
            roomName: group.name!,
            lastMessageModel: LastMessageModel(
              users: users,
            ),
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xff5b00e4),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SvgPicture.asset(
              AppVectors.icBubbleChat,
            ),
          ),
        ),
      ),
    );
  }

  Widget membersInTeam(List<JoinedModel> members) {
    return ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: members.length,
        itemBuilder: (c, i) {
          return DecoratedBox(
            decoration: (i != members.length - 1)
                ? BaseWidget.dividerBottom(
                    color: Color(0xfff5f5f5),
                    height: 2,
                  )
                : BoxDecoration(),
            child: WidgetMemberItem(
              event: event,
              group: group,
              joined: members[i],
              progressHUD: progressHUD,
              groupRepository: groupRepository,
              callback: (removeSuccess) {
                removeMemberCallback(removeSuccess);
              },
            ),
          );
        });
  }

  Widget linearProgressBar() {
    double value = group.distanceKm / (event.targetRun ?? 0).toDouble();

    return LinearProgressBar(
      height: 20.0,
      value: value,
      backgroundColor: event.backgroundLineBarColor(group, event),
      foregroundColor: event.foregroundColorLineBar(group, event),
    );
  }

  Widget displayProgressTargetLine() {
    if (_completedState) return const CompletedTargetLine();
    if (_uncompletedState) return const UncompletedTargetLine();
    return const SizedBox.shrink();
  }

/*Team đã hoàn thành mục tiêu*/
  bool get _completedState => group.statusRun == 1;

  /*Team không hoàn thành mục tiêu và giải chạy đã kết thúc*/
  bool get _uncompletedState => event.isExpired! && group.statusRun == 0;

  /*
  Điều kiện để dòng chữ "Hãy mời thêm bạn thông qua mã code":
  - Giải chưa kết thúc
  - Nhóm chưa hoàn thành mục tiêu
  - Số lượng thành viên chưa đạt tối đa
  */
  bool get _checkShowInviteMemberToGroup =>
      event.isExpired == false &&
      group.statusRun == 0 &&
      group.joined!.length < event.maximumMember!;
}
