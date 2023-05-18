import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/middle/api/run_api.dart';
import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/presentation/index.dart';

import '../../../../../common_widgets/bottom_sheet/header_bottom_sheet.dart';
import 'input_text_filed_widget.dart';

typedef void JoinByTeamCodeCallBack(JoinTeamState status, String code);

class BottomSheetJoinByTeamCode {
  static void show({
    @required BuildContext context,
    @required JoinByTeamCodeCallBack callback,
  }) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      builder: (context) {
        return SafeArea(
          maintainBottomViewPadding: true,
          bottom: true,
          key: Key('BottomSheetJoinByTeamCode'),
          child: Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  HeaderBottomSheet(
                    parentContext: context,
                    title: LocalizationsUtil.of(context)
                        .translate('k_join_the_running_team'),
                  ),
                  SizedBox(height: 30),
                  Text(
                      LocalizationsUtil.of(context)
                          .translate('k_enter_team_code'),
                      style: AppFonts.semibold13.copyWith(
                        color: Color(0xff838383),
                      )),
                  SizedBox(height: 5),
                  EnterTeamNameTextFiled(
                    type: FieldType.code,
                    titleButton: LocalizationsUtil.of(context)
                        .translate('k_submit_a_request_to_join'),
                    callback: (code) async {
                      HapticFeedback.lightImpact();
                      final repo = GroupRepository();

                      final JoinTeamState result = await repo.joinGroupByCode(
                        code: code.trim(),
                      );
                      if (callback != null) callback(result, code);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
