import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/common/app_event_bloc.dart';
import 'package:houze_super/middle/api/run_api.dart';
import 'package:houze_super/middle/local/storage.dart';

import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/index.dart';
import 'package:houze_super/presentation/screen/community/run/group/bloc/member_bloc/member_bloc.dart';

import '../index.dart';
import 'index.dart';

typedef void UpdateGroupDetailCallback(
  bool update,
);

class WidgetGroupDetailSection extends StatefulWidget {
  final EventModel eventModel;
  final List<GroupModel> groups;
  final ProgressHUD progressToolkit;

  const WidgetGroupDetailSection({
    required this.eventModel,
    required this.progressToolkit,
    required this.groups,
  });
  @override
  _WidgetGroupDetailState createState() => _WidgetGroupDetailState();
}

class _WidgetGroupDetailState extends State<WidgetGroupDetailSection> {
  late List<GroupModel> _groups;
  late EventModel _eventModel;
  late ProgressHUD _progressToolkit;
  late GroupRepository _groupRepository;

  @override
  void initState() {
    super.initState();
    _groups = widget.groups;
    _eventModel = widget.eventModel;
    _progressToolkit = widget.progressToolkit;
    _groupRepository = context.read<GroupRepository>();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkUserInEventNothing) {
      return EventTeamNothing();
    }

    if (_checkUserUnregisterEvent(
      _groups,
    )) {
      return Builder(builder: (
        context,
      ) {
        return EmptyTeamSection(
          groupTotal: _eventModel.groupTotal ?? 0,
          createTeamCallback: () => _onPressCreateNewGroup(
            context,
          ),
          joinInTeamCallback: () => _onPressJoinInGroupByCode(
            context,
          ),
        );
      });
    }
    final GroupModel? _group = _checkGroupIsValid ? _groups[0] : null;

    if (_checkUserIsWaitingForOwnerApproveJoinGroup(_group!)) {
      return UserWaitingAcceptSection(
        group: _group,
        groupTotal: _eventModel.groupTotal ?? 0,
        callback: (cancel) async {
          if (cancel) {
            await _onPressCancelJoinTeamByCode(_group);
          }
        },
      );
    }

    return Builder(builder: (
      context,
    ) {
      return WidgetBoxesContainer(
        padding: const EdgeInsets.all(20),
        title: _group.name,
        hasLine: false, styleTitle: AppFonts.bold18,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CodeLineWidget(
                code: _group.code ?? '',
              ),
              const SizedBox(height: 23),
              TeamDetailBoxWidget(
                group: _group,
                event: widget.eventModel,
                groupRepository: _groupRepository,
                progressHUD: _progressToolkit,
                removeMemberCallback: (bool success) async {
                  if (success) {
                    await _reloadDataGroup();
                  }
                },
              ),
              const SizedBox(height: 10),
              if (checkUserIsOwnner(_group)) ...[
                BlocProvider(
                  create: (context) => MemberBloc(
                    groupRepository: _groupRepository,
                  ),
                  child: MembersRequestedToJoindTeamSection(
                    groupID: _group.id ?? '',
                    progressToolkit: _progressToolkit,
                    callback: (update) {
                      if (update) {
                        _reloadDataGroup();
                      }
                    },
                  ),
                ),
              ],
              if (_checkShowOnwerCanDeleteTeam(_group)) ...[
                CancelTeamBottom(
                  callback: (update) async {
                    if (update) {
                      await _onPressDeleteMyGroup(_group);
                    }
                  },
                )
              ],
            ],
          ),
        ),
        // ),
      );
    });
  }

/*Kiểm tra user là owner mới được gọi api lấy danh sách người yêu cầu tham gia*/
  bool checkUserIsOwnner(GroupModel group) {
    final currentUserID = Storage.getUserID();
    final ownerID = group.createdBy!.id;
    return (currentUserID == ownerID);
  }

/*Hủy đội chạy*/
  Future<void> _onPressDeleteMyGroup(
    GroupModel group,
  ) async {
    try {
      _progressToolkit.state.show();
      final _deleteSuccessful = await _groupRepository.deleteMyGroup(
        id: group.id ?? '',
      );
      await Future.delayed(Duration(milliseconds: 300)).then((value) {
        if (_deleteSuccessful) {
          _reloadDataGroup();
        } else {
          showDeleteMyGroupFailded();
        }
      });
    } catch (e) {
      showDeleteMyGroupFailded();
    } finally {
      _progressToolkit.state.dismiss();
    }
  }

  void showDeleteMyGroupFailded() {
    DialogCustom.showSuccessDialog(
      context: Storage.scaffoldKey.currentContext!,
      title: 'Hủy đội chạy thất bại',
      buttonText: 'try_again',
      content: 'there_is_an_issue_please_try_again_later_1',
      onPressed: () {
        _reloadDataGroup();
        Navigator.of(Storage.scaffoldKey.currentContext!).pop();
      },
    );
  }

/*Hủy yêu cầu tham gia nhóm sau khi nhập mã code*/
  Future<void> _onPressCancelJoinTeamByCode(GroupModel group) async {
    _progressToolkit.state.show();
    try {
      RequestModel request = group.requests!
          .firstWhere((element) => element.user!.id == Storage.getUserID());
      final bool result = await _groupRepository.putCancelRequestJoinTeam(
          requestID: request.id!);
      await Future.delayed(
        Duration(
          milliseconds: 300,
        ),
      );
      if (result) {
        _reloadDataGroup();
      } else {
        showCancellationFailedRequest();
      }
    } catch (e) {
      showCancellationFailedRequest();
    } finally {
      _progressToolkit.state.dismiss();
    }
  }

  void showCancellationFailedRequest() {
    DialogCustom.showSuccessDialog(
      context: Storage.scaffoldKey.currentContext!,
      title: 'Hủy yêu cầu thất bại',
      buttonText: 'try_again',
      content: 'reload',
      onPressed: () {
        _reloadDataGroup();
        Navigator.of(Storage.scaffoldKey.currentContext!).pop();
      },
    );
  }

  /*Lập đội chạy của bạn*/
  void _onPressCreateNewGroup(BuildContext subContext) {
    BottomSheetCreateTeam.show(
      context: subContext,
      groupRepository: _groupRepository,
      progressHub: _progressToolkit,
      eventID: _eventModel.id!,
      callback: (GroupModel value) {
        if (value.id!.length > 0) {
          _reloadDataGroup();
        } else {
          showCreateNewGroupFailed();
        }
      },
    );
  }

  void showCreateNewGroupFailed() {
    _progressToolkit.state.dismiss();
    DialogCustom.showSuccessDialog(
      context: Storage.scaffoldKey.currentContext!,
      title: 'Lập đội chạy thất bại',
      buttonText: 'try_again',
      content: 'reload',
      onPressed: () {
        _reloadDataGroup();
        Navigator.of(Storage.scaffoldKey.currentContext!).pop();
      },
    );
  }

  /*Tham gia đội theo mã code*/
  void _onPressJoinInGroupByCode(
    BuildContext ctx,
  ) {
    BottomSheetJoinByTeamCode.show(
      context: ctx,
      callback: (status, code) {
        switch (status) {
          case JoinTeamState.success:
            return PopupJoinTeam.showSuccess(
                context: ctx,
                code: code,
                callback: (updated) {
                  if (updated) {
                    _reloadDataGroup();
                  }
                  _progressToolkit.state.dismiss();
                });

          case JoinTeamState.isFull:
            return PopupJoinTeam.showTeamFull(
              context: ctx,
              code: code,
            );

          case JoinTeamState.notFound:
            return PopupJoinTeam.showNotFound(
              context: ctx,
              code: code,
            );

          case JoinTeamState.cannotJoin:
            return PopupJoinTeam.showUserCannotJoin(
              context: ctx,
              code: code,
            );

          default:
            return PopupJoinTeam.showError(
              context: ctx,
              code: code,
            );
        }
      },
    );
  }

  /*
  Gửi event thông báo cần reload lại giải chạy sau khi 1 hành động xảy ra thành công
  */
  Future<void> _reloadDataGroup() async {
    AppEventBloc().emitEvent(
      BlocEvent(
        EventName.challengeUpdateDetail,
        _eventModel.id,
      ),
    );

    await Future.delayed(
        Duration(
          milliseconds: 500,
        ), () {
      _progressToolkit.state.dismiss();
    });
  }

  /*
  * User tham gia 1 nhóm bởi mã code
  * Đang chờ owner duyệt hoặc hủy yêu cầu của mình
  * Trong khi chưa được Duyệt/ bị Từ chối thì user có quyền hủy yêu cầu tham gia nhóm này
  */
  bool _checkUserIsWaitingForOwnerApproveJoinGroup(GroupModel? group) =>
      group!.isWaitingAccept! && checkUserIsOwnner(group) == false;

  bool get _checkGroupIsValid => _groups.length > 0;

  /*
  * Giải chạy đang diễn ra
  * User chưa tham gia nhóm nào trong giải chạy này
  */
  bool _checkUserUnregisterEvent(List<GroupModel> groups) =>
      _checkGroupIsValid == false;

  /*
  * Giải chạy đã kết thúc và user này chưa từng tham gia vào đội nhóm nào
  */
  bool get _checkUserInEventNothing =>
      _eventModel.isExpired! && _checkGroupIsValid == false;

/* Điều kiện để 1 user có thể thấy và có quyền Hủy đội
 * - User là owner
 * - Nhóm chưa có thành viên nào ngoại trừ trưởng nhóm
 * - Giải chạy chưa kết thúc
 * - Nếu tất cả thành viên (trừ owner) chưa có đóng góp
 * - Check hoàn thành mục tiêu thì ẩn
 */
  bool _checkShowOnwerCanDeleteTeam(GroupModel group) {
    if (_eventModel.isExpired == false) {
      if (!checkUserIsOwnner(group)) return false;
      if (group.statusRun == 1) return false;

      return (group.joined!.length <= 1);
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

/* Giải chạy đã kết thúc và user chưa từng tham gia nhóm để chạy
 - Bạn không có dữ liệu tại giải chạy này
*/
class EventTeamNothing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetBoxesContainer(
      padding: const EdgeInsets.all(0),
      hasLine: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            SvgPicture.asset(
              AppVectors.icRunLarge,
              width: 80.0,
              height: 80.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              LocalizationsUtil.of(context)
                  .translate('k_you_have_no_data_for_this_race'),
              style: AppFonts.regular15.copyWith(
                color: Color(0xff838383),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
