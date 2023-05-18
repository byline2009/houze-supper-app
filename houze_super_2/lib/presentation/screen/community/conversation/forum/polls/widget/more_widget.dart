import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/report_bloc.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/widget/report_bottomsheet.dart';
import 'package:houze_super/presentation/screen/community/run/group/widget/widget_confirm_dialog.dart';

import '../../discussion/bloc/report_event.dart';

typedef void CallBackhandler(bool value);

class MoreReportOptions extends StatefulWidget {
  final PollModel? pollModel;
  final CallBackhandler? callback;

  MoreReportOptions({
    this.pollModel,
    this.callback,
  });

  @override
  State<MoreReportOptions> createState() => _MoreReportOptionsState();
}

class _MoreReportOptionsState extends State<MoreReportOptions> {
  final reportBloc = ReportBloc();
  final focusNode = FocusNode(
    canRequestFocus: true,
  );

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      icon: Icon(
        Icons.more_horiz,
      ),
      onPressed: () {
        _showModalBottomSheet(context);
      },
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(StyleHomePage.borderRadius),
                          topRight: Radius.circular(StyleHomePage.borderRadius),
                        )),
                    height: MediaQuery.of(context).size.height * 0.42,
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    primary: Colors.transparent,
                                    elevation: 0,
                                    tapTargetSize: MaterialTapTargetSize.padded,
                                    padding: EdgeInsets.all(0),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: SvgPicture.asset(AppVectors.icClose),
                                )
                              ],
                            )),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _onTapReport(context);
                                  },
                                  leading: SvgPicture.asset(
                                    'assets/svg/community/ic-report-post.svg',
                                    width: 25,
                                    height: 25,
                                    color: Color(0xff000000),
                                  ),
                                  title: Align(
                                    child: Text(
                                      LocalizationsUtil.of(context)
                                          .translate("report_post"),
                                      style: AppFont.BOLD_GRAY_838383_15,
                                    ),
                                    alignment: Alignment(-1.2, 0),
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    _onTapReport(context);
                                  },
                                  leading: SvgPicture.asset(
                                      'assets/svg/community/user-report.svg',
                                      width: 25,
                                      height: 25,
                                      color: Color(0xff000000)),
                                  title: Align(
                                    child: Text(
                                      LocalizationsUtil.of(context)
                                          .translate("report_user"),
                                      style: AppFont.BOLD_GRAY_838383_15,
                                    ),
                                    alignment: Alignment(-1.2, 0),
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: ListTile(
                                  onTap: () {
                                    AppDialog.showContentDialog(
                                      context: context,
                                      child: WidgetConfirmDialog(
                                        height: 200,
                                        content: Text(
                                          LocalizationsUtil.of(context).translate(
                                              "k_this_is_an_action_that_cannot_be_undone"),
                                          style: AppFonts.regular15.copyWith(
                                            color: Color(
                                              0xff808080,
                                            ),
                                          ),
                                        ),
                                        confirmCallback: () async {
                                          Navigator.pop(context);
                                          String? currentUserId =
                                              Storage.getUserID();
                                          await Sqflite.insertBlackListUser(
                                              BlackListModel(
                                                  userId: widget
                                                      .pollModel!.user!.id!,
                                                  myId: currentUserId ?? ""));
                                          if (widget.callback != null)
                                            widget.callback!(true);
                                          Navigator.pop(context);
                                        },
                                      ),
                                      closeShow: false,
                                      barrierDismissible: true,
                                    );
                                  },
                                  leading: SvgPicture.asset(
                                      "assets/svg/community/block-user.svg",
                                      width: 24,
                                      height: 24,
                                      color: Color(0xff000000)),
                                  title: Align(
                                    child: Text(
                                      LocalizationsUtil.of(context)
                                          .translate("block_this_user"),
                                      style: AppFont.BOLD_GRAY_838383_15,
                                    ),
                                    alignment: Alignment(-1.2, 0),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _onTapReport(BuildContext context) {
    if (mounted) {
      focusNode.requestFocus();
    }

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        focusNode.requestFocus();
        return ReportBottomSheet(reportBloc, callback: (reportContent) async {
          reportBloc.add(ReportPostSend(
              postId: widget.pollModel?.id ?? "", desc: reportContent));
          await Future.delayed(Duration(microseconds: 1000));
        });
      },
    );
  }
}
