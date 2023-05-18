import 'package:flutter/material.dart';

import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

import '../index.dart';
import 'index.dart';

class CancelTeamBottom extends StatelessWidget {
  const CancelTeamBottom({
    Key key,
    @required this.callback,
  }) : super(key: key);

  final UpdateGroupDetailCallback callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
            onPressed: () {
              showConfirmActivityDialog(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.close,
                  color: Color(
                    0xffc50000,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  LocalizationsUtil.of(context)
                      .translate('k_cancel_the_running_team'),
                  style: AppFonts.bold16.copyWith(
                    color: Color(
                      0xffc50000,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          Text(
            LocalizationsUtil.of(context).translate(
              '''k_note_after_canceling_the_running_team_all_the_parameters_you_run_in_this_tournament_will_be_forfeited_this_is_an_action_that_cannot_be_undone''',
            ),
            textAlign: TextAlign.center,
            style: AppFonts.semibold13.copyWith(
              color: Color(0xff838383),
            ),
          ),
        ],
      ),
    );
  }

  void showConfirmActivityDialog(BuildContext context) {
    AppDialog.showContentDialog(
      context: context,
      child: WidgetConfirmDialog(
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppFonts.regular15.copyWith(
              color: Color(
                0xff808080,
              ),
            ),
            children: <TextSpan>[
              TextSpan(
                  text: LocalizationsUtil.of(context)
                          .translate('k_are_you_sure_you_wanna') +
                      ' '),
              TextSpan(
                  style: AppFonts.bold15.copyWith(color: Color(0xffC50000)),
                  text: LocalizationsUtil.of(context)
                          .translate('k_cancel_the_running_team') +
                      "?\n"),
              TextSpan(
                text: LocalizationsUtil.of(context).translate(
                  'k_this_is_an_action_that_cannot_be_undone',
                ),
              ),
            ],
          ),
        ),
        confirmCallback: () {
          callback(true);
          Navigator.pop(context);
        },
      ),
      closeShow: false,
      barrierDismissible: true,
    );
  }
}
