import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/translator_vi_to_en.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/widget/poll_comment_image_item.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/report_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../common_widgets/app_dialog.dart';
import '../../../../run/group/widget/widget_confirm_dialog.dart';
import '../../discussion/bloc/report_bloc.dart';
import '../../polls/widget/report_bottomsheet.dart';

typedef void ReportCommentCallback(PollCommentModel comment);

class WidgetPollCommentItem extends StatefulWidget {
  final PollCommentModel comment;
  final ReportCommentCallback? reportDoneCallback;
  const WidgetPollCommentItem({required this.comment, this.reportDoneCallback});

  @override
  _WidgetPollCommentItemState createState() => _WidgetPollCommentItemState();
}

class _WidgetPollCommentItemState extends State<WidgetPollCommentItem> {
  final reportBloc = ReportBloc();

  dynamic _checkInvalidUrl(dynamic url) {
    if (url.toString().toLowerCase().substring(0, 5).contains('http')) {
      url = url;
    } else if (url.toString().toLowerCase().substring(0, 6).contains('https')) {
      url = url;
    } else if (!url.toString().toLowerCase().substring(0, 5).contains('http')) {
      url = 'https://' + url;
    } else if (!url
        .toString()
        .toLowerCase()
        .substring(0, 6)
        .contains('https')) {
      url = 'https://' + url;
    }
    return url;
  }

  void _launchURL(dynamic url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    final getLanguage = Storage.getLanguage();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final commentId = widget.comment.id;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        String? currentUserId = Storage.getUserID();

        if (currentUserId != null && currentUserId != widget.comment.userId) {
          showModalBottomSheet(
            isDismissible: true,
            context: context,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            isScrollControlled: true,
            builder: (BuildContext context) {
              return SafeArea(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  GestureDetector(
                    onTap: () {
                      {
                        Navigator.of(context).pop();

                        showModalBottomSheet(
                          context: context,
                          isDismissible: false,
                          isScrollControlled: true,
                          builder: (context) {
                            return ReportBottomSheet(reportBloc,
                                callback: (reportContent) async {
                              reportBloc.add(ReportCommentSend(commentId ?? "",
                                  description: reportContent));

                              await Future.delayed(
                                  Duration(microseconds: 1000));
                            });
                          },
                        );
                      }
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocalizationsUtil.of(context).translate("report"),
                              style: TextStyle(
                                  fontFamily: AppFont.font_family_display,
                                  fontSize: 15,
                                  color: Colors.red),
                            ),
                          ],
                        )),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () async {
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
                            String? currentUserId = Storage.getUserID();
                            await Sqflite.insertBlackListUser(BlackListModel(
                                userId: widget.comment.userId ?? "",
                                myId: currentUserId ?? ""));

                            Navigator.pop(context);

                            widget.reportDoneCallback?.call(widget.comment);
                          },
                        ),
                        closeShow: false,
                        barrierDismissible: true,
                      );
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocalizationsUtil.of(context)
                                  .translate("block_this_user"),
                              style: TextStyle(
                                  fontFamily: AppFont.font_family_display,
                                  fontSize: 15,
                                  color: Colors.red),
                            ),
                          ],
                        )),
                  ),
                ]),
              );
            },
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xffc4c4c4),
                borderRadius: BorderRadius.all(new Radius.circular(20)),
                border: Border.all(
                  color: Color(0xfff2f2f2),
                  width: 1.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.comment.user?.imageThumb != null
                    ? CachedImageWidget(
                        cacheKey: avatarHomeKey,
                        imgUrl: widget.comment.user?.imageThumb ?? "",
                        width: 48.0,
                        height: 48.0,
                      )
                    : Center(
                        child: Text(
                          widget.comment.user?.fullname?[0].toUpperCase() ?? "",
                          //style: AppFonts.bold20.copyWith(color: Colors.white),
                          style: AppFont.BOLD_WHITE_20,
                        ),
                      ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                widget.comment.displayType == 0
                    ? Text(
                        widget.comment.user?.fullname ?? "",
                        //style: AppFonts.bold15,
                        style: AppFont.BOLD_BLACK_15,
                      )
                    : Text(
                        "0" +
                            (widget.comment.user?.phoneNumber ?? "")
                                .toString()
                                .substring(0, 6) +
                            "***",
                        //style: AppFonts.bold15,
                        style: AppFont.BOLD_BLACK_15,
                      ),
                SizedBox(height: 5),
                (widget.comment.description != null &&
                        widget.comment.description!.isNotEmpty)
                    ? Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color(0xfff5f5f5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateUtil.format(
                                  "dd/MM/yyyy - HH:mm",
                                  widget.comment.created?.toIso8601String() ??
                                      "",
                                ),
                                // style: AppFonts.medium10.copyWith(
                                //   color: Color(0xff808080),
                                // ),
                                style: AppFont.MEDIUM_GRAY_808080_10,
                              ),
                              SizedBox(height: 5),
                              (widget.comment.description != null &&
                                      widget.comment.description!.isNotEmpty)
                                  ? Container(
                                      constraints: BoxConstraints(
                                          maxWidth: screenWidth * 0.5),
                                      child: ParsedText(
                                        text: widget.comment.description!,
                                        parse: <MatchText>[
                                          MatchText(
                                            type: ParsedType.URL,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14,
                                            ),
                                            onTap: (url) {
                                              final validURL =
                                                  _checkInvalidUrl(url);
                                              _launchURL(validURL
                                                  .toString()
                                                  .toLowerCase());
                                            },
                                          ),
                                        ],
                                        // style: AppFonts.regular14,
                                        style: AppFonts.regular14,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              getLanguage.name != 'Tiếng Việt'
                                  ? Container(
                                      child:
                                          (widget.comment.description != null &&
                                                  widget.comment.description!
                                                      .isNotEmpty)
                                              ? TranslatorViToEn(
                                                  widget.comment.description!,
                                                  getLanguage.locale!)
                                              : const SizedBox.shrink(),
                                    )
                                  : Center(),
                              (widget.comment.images != null &&
                                      (widget.comment.images?.isNotEmpty ??
                                          false))
                                  ? PollCommentImageWidget(
                                      screenWidth * 0.18,
                                      screenHeight * 0.13,
                                      widget.comment.description,
                                      widget.comment.images)
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateUtil.format(
                                  "dd/MM/yyyy - HH:mm",
                                  widget.comment.created?.toIso8601String() ??
                                      ""),
                              // style: AppFonts.medium10.copyWith(
                              //   color: Color(0xff808080),
                              style: AppFont.MEDIUM_GRAY_808080_10,
                            ),
                            SizedBox(height: 5),
                            PollCommentImageWidget(
                                screenWidth * 0.25,
                                screenHeight * 0.15,
                                widget.comment.description,
                                widget.comment.images),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
