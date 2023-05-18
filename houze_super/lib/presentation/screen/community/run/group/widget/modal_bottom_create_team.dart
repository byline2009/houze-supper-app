import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/presentation/index.dart';

import '../index.dart';
import 'input_text_filed_widget.dart';

typedef void CreateTeamCallBackHandler(GroupModel result);

class BottomSheetCreateTeam {
  static void show({
    @required BuildContext context,
    @required String eventID,
    @required ProgressHUD progressHub,
    @required GroupRepository groupRepository,
    CreateTeamCallBackHandler callback,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            25.0,
          ),
        ),
      ),
      builder: (context) {
        return SafeArea(
          maintainBottomViewPadding: true,
          bottom: true,
          key: Key('BottomSheetCreateTeam'),
          child: Container(
            color: Colors.transparent,
            child: DecoratedBox(
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
                          .translate('k_create_a_running_team')),
                  const SizedBox(height: 30),
                  Text(
                      LocalizationsUtil.of(context)
                              .translate('k_your_team_name') +
                          ': ',
                      style: AppFonts.semibold13.copyWith(
                        color: Color(0xff838383),
                      )),
                  const SizedBox(height: 5),
                  EnterTeamNameTextFiled(
                    titleButton: LocalizationsUtil.of(context).translate(
                      'k_initialization',
                    ),
                    callback: (value) async {
                      await HapticFeedback.lightImpact();
                      Navigator.of(context).pop();
                      progressHub.state.show();
                      try {
                        final result = await groupRepository.createNewGroup(
                          name: value,
                          eventID: eventID,
                        );
                        await Future.delayed(
                          Duration(
                            milliseconds: 600,
                          ),
                        );

                        if (callback != null) callback(result);
                      } catch (error) {
                        print(error.toString());
                        if (callback != null) callback(null);
                      }
                    },
                    type: FieldType.create,
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
