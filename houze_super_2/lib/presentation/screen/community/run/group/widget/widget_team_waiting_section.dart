import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';

import '../index.dart';
import 'index.dart';

typedef CancelRequestJoinTeam(bool);

class UserWaitingAcceptSection extends StatelessWidget {
  final GroupModel group;
  final int groupTotal;
  final CancelRequestJoinTeam callback;
  const UserWaitingAcceptSection({
    required this.groupTotal,
    required this.group,
    required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    return WidgetBoxesContainer(
      hasLine: false,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationsUtil.of(context)
                      .translate('k_request_to_join_has_been_sent_to') +
                  ' :',
              style: AppFonts.semibold13.copyWith(
                color: Color(
                  0xffd68100,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xfff5f5f5),
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    5.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    group.name ?? '',
                    style: AppFonts.bold18,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppFonts.bold18,
                      children: [
                        TextSpan(
                          text: 'Code: ',
                          style: AppFonts.bold18.copyWith(
                            color: Color(0xff838383),
                          ),
                        ),
                        TextSpan(text: group.code),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            WidgetButton.outline(
                LocalizationsUtil.of(context).translate('k_cancel_request'),
                callback: () {
              callback(true);
            }),
            TotalTeamBottom(
              groupTotal: groupTotal,
            ),
          ],
        ),
      ),
    );
  }
}
