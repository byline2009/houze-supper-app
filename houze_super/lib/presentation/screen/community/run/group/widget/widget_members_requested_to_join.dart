import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/run/group/bloc/member_bloc/member_bloc.dart';
import 'package:houze_super/presentation/screen/community/run/group/bloc/member_bloc/member_event.dart';
import 'package:houze_super/presentation/screen/community/run/group/bloc/member_bloc/member_state.dart';
import '../index.dart';

enum TypeRequestEvent { approve, reject }
typedef void ConfirmMemberRequestedToJoindTeam(bool hadConfirm);

/*Danh sách yêu cầu tham gia*/
class MembersRequestedToJoindTeamSection extends StatelessWidget {
  final String groupID;
  final ProgressHUD progressToolkit;
  final ConfirmMemberRequestedToJoindTeam callback;

  const MembersRequestedToJoindTeamSection({
    Key key,
    @required this.groupID,
    @required this.progressToolkit,
    @required this.callback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(
      builder: (_, state) {
        if (state is MemberInitial) {
          context.read<MemberBloc>().add(
                GroupLoadMembersRequestJoinTeam(
                  groupID: groupID,
                ),
              );
        }

        if (state is MemberLoading) {
          return ListSkeleton(
            shrinkWrap: true,
            length: 2,
            config: SkeletonConfig(
              theme: SkeletonTheme.Light,
              isShowAvatar: true,
              isCircleAvatar: true,
              bottomLinesCount: 0,
            ),
          );
        }
        if (state is GroupLoadMembersRequestJoinTeamFailure) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                LocalizationsUtil.of(context)
                    .translate('there_is_an_issue_please_try_again_later_0'),
                textAlign: TextAlign.center,
                style: AppFonts.regular15.copyWith(
                  color: Color(
                    0xff808080,
                  ),
                ),
              ),
            ),
          );
        }
        if (state is GroupLoadMembersRequestJoinTeamSuccessful) {
          final List<RequestModel> data = state.result;
          if (data.length > 0)
            return WidgetBoxesContainer(
              hasLine: false,
              padding: const EdgeInsets.symmetric(vertical: 20),
              title: LocalizationsUtil.of(context)
                      .translate('k_number_of_requests_to_join') +
                  ' (${data.length})',
              styleTitle: AppFonts.bold18,
              child: ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    return MemberRequestedToJoindTeamItem(
                      requestModel: data[i],
                      progressToolkit: progressToolkit,
                      /*Member đã được duyệt hoặc bị từ chối
                      update: cần load lại danh sách hay không?
                      */
                      callback: (update) {
                        callback(update);
                      },
                    );
                  }),
            );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class MemberRequestedToJoindTeamItem extends StatelessWidget {
  final RequestModel requestModel;
  final ConfirmMemberRequestedToJoindTeam callback;
  final ProgressHUD progressToolkit;

  const MemberRequestedToJoindTeamItem({
    Key key,
    @required this.requestModel,
    this.callback,
    @required this.progressToolkit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _repo = context.read<GroupRepository>(); //GroupRepository();
    final MemberModel member = requestModel.user;
    return Column(
      children: [
        Row(
          children: [
            BaseWidget.avatar(
              imageUrl: member.imageThumb,
              fullname: member.fullname,
              size: 40,
            ),
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      member.fullname,
                      style: AppFonts.medium14.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    // SizedBox(width: 5),
                    // Text('0333427217', style: AppFonts.semibold13.copyWith(color: Color(0xff838383),))
                  ]),
            ),
          ],
        ),
        const SizedBox(width: 15),
        Container(
          height: 44,
          margin: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: WidgetButton.outlineButton(
                    text: LocalizationsUtil.of(context).translate('rejected_0'),
                    style: AppFonts.bold15.copyWith(color: Color(0xffC50000)),
                    callback: () {
                      putConfirmRequestJoinTeam(
                        TypeRequestEvent.reject,
                        _repo,
                      );
                    }),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: WidgetButton.pinkButton(
                  text: LocalizationsUtil.of(context).translate('k_accept'),
                  style: AppFonts.bold15.copyWith(color: Color(0xff7a1dff)),
                  callback: () {
                    putConfirmRequestJoinTeam(
                      TypeRequestEvent.approve,
                      _repo,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void putConfirmRequestJoinTeam(
    TypeRequestEvent type,
    GroupRepository repo,
  ) async {
    progressToolkit.state.show();
    try {
      final result = await repo.putConfirmRequestJoinTeam(
        type: type,
        requestID: requestModel.id,
      );
      await Future.delayed(const Duration(milliseconds: 500));

      if (callback != null) callback(result);
    } catch (e) {
      print(e.toString());
    }
    if (callback != null) callback(false);
  }
}
