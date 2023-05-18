import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/report_bloc.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/report_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/report_state.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/discussion_bloc.dart';
import 'package:houze_super/presentation/screen/community/run/group/widget/widget_confirm_dialog.dart';

typedef void CallBackhandler(bool value);

class MoreOptions extends StatefulWidget {
  final DiscussionModel? discussionModel;
  final DiscussionBloc? discussionBloc;
  final CallBackhandler? callback;
  final CallBackhandler? blockUserCallback;
  final bool? isRenderedInDetailPage;
  final bool? isOtherOption;

  MoreOptions(
      {this.discussionBloc,
      this.discussionModel,
      this.callback,
      this.blockUserCallback,
      this.isRenderedInDetailPage,
      this.isOtherOption});

  @override
  State<MoreOptions> createState() => _MoreOptionsState();
}

class _MoreOptionsState extends State<MoreOptions> {
  final _formKey = GlobalKey<FormState>();
  final reportBloc = ReportBloc();
  final TextEditingController _controller = TextEditingController();
  StreamController<ButtonSubmitEvent> _sendButtonController =
      StreamController<ButtonSubmitEvent>.broadcast();
  final focusNode = FocusNode(
    canRequestFocus: true,
  );
  bool? _isActive;
  @override
  void initState() {
    _sendButtonController.sink.add(ButtonSubmitEvent(false));
    super.initState();
  }

  @override
  void dispose() {
    _sendButtonController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
                        widget.isOtherOption != null && widget.isOtherOption!
                            ? Column(
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
                              )
                            : Column(
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
                                                LocalizationsUtil.of(context)
                                                    .translate(
                                                        "k_this_is_an_action_that_cannot_be_undone"),
                                                style:
                                                    AppFonts.regular15.copyWith(
                                                  color: Color(
                                                    0xff808080,
                                                  ),
                                                ),
                                              ),
                                              confirmCallback: () async {
                                                Navigator.pop(context);
                                                if (widget.discussionBloc !=
                                                    null) {
                                                  widget.discussionBloc!.add(
                                                      DeleteDiscussion(
                                                          id: widget
                                                                  .discussionModel
                                                                  ?.id ??
                                                              ""));

                                                  Navigator.pop(context);
                                                  if (widget.callback != null)
                                                    widget.callback!(true);
                                                  if (widget.isRenderedInDetailPage !=
                                                          null &&
                                                      widget
                                                          .isRenderedInDetailPage!) {
                                                    Navigator.pop(context);
                                                  }
                                                }
                                              },
                                            ),
                                            closeShow: false,
                                            barrierDismissible: true,
                                          );
                                        },
                                        leading: Icon(Icons.delete_forever,
                                            color: Color(0xff000000)),
                                        title: Align(
                                          child: Text(
                                            LocalizationsUtil.of(context)
                                                .translate("delete_discussion"),
                                            style: AppFont.BOLD_GRAY_838383_15,
                                          ),
                                          alignment: Alignment(-1.2, 0),
                                        )),
                                  ),
                                ],
                              ),
                        widget.isOtherOption != null && widget.isOtherOption!
                            ? Column(
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
                                                LocalizationsUtil.of(context)
                                                    .translate(
                                                        "k_this_is_an_action_that_cannot_be_undone"),
                                                style:
                                                    AppFonts.regular15.copyWith(
                                                  color: Color(
                                                    0xff808080,
                                                  ),
                                                ),
                                              ),
                                              confirmCallback: () async {
                                                Navigator.pop(context);
                                                String? currentUserId =
                                                    Storage.getUserID();
                                                await Sqflite
                                                    .insertBlackListUser(
                                                        BlackListModel(
                                                            userId: widget
                                                                .discussionModel!
                                                                .user!
                                                                .id!,
                                                            myId:
                                                                currentUserId ??
                                                                    ""));
                                                if (widget.blockUserCallback !=
                                                    null)
                                                  widget
                                                      .blockUserCallback!(true);
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
                                          color: Color(0xff000000),
                                        ),
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
                            : const SizedBox.shrink()
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
    var _screenSize = MediaQuery.of(context).size;
    if (mounted) {
      focusNode.requestFocus();
    }
    if (_controller.text.trim().length > 0) {
      setState(() {
        this._isActive = true;
      });
    } else {
      this._isActive = null;
    }
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        focusNode.requestFocus();
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return GestureDetector(
              onTap: () {
                //FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                color: Color(0xff737373),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  height: (300 / 667) * _screenSize.height,
                  child: BlocBuilder(
                    bloc: reportBloc,
                    builder: (context, reportState) {
                      if (reportState is ReportInitial) {
                        return AnimatedContainer(
                          curve: Curves.easeOutQuad,
                          duration: Duration(milliseconds: 250),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  _bottomModalHeader(),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text(
                                      LocalizationsUtil.of(context)
                                          .translate("report_content"),
                                      style: AppFonts.medium16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Form(
                                      key: _formKey,
                                      child: TextField(
                                        autofocus: true,
                                        focusNode: focusNode,
                                        controller: _controller,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              LocalizationsUtil.of(context)
                                                  .translate(
                                                      "input_description_here"),
                                          hintStyle: AppFont
                                              .MEDIUM_GRAY_9C9C9C_11
                                              .copyWith(
                                                  fontSize:
                                                      18.0), //MEDIUM_GRAY_9C9C9C_18,
                                          labelStyle: AppFonts.medium18
                                              .copyWith(
                                                  letterSpacing: 0.29,
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5,
                                        onChanged: (String value) {
                                          if (value.trim().isEmpty == false) {
                                            _formKey.currentState!.validate();
                                            _sendButtonController.sink
                                                .add(ButtonSubmitEvent(true));
                                          } else {
                                            _sendButtonController.sink
                                                .add(ButtonSubmitEvent(false));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      alignment: Alignment.bottomCenter,
                                      child: ButtonWidget(
                                        callback: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            reportBloc.add(ReportPostSend(
                                                postId: widget
                                                        .discussionModel?.id ??
                                                    "",
                                                desc: _controller.text));
                                            await Future.delayed(
                                                Duration(microseconds: 1000));
                                          }
                                        },
                                        defaultHintText:
                                            LocalizationsUtil.of(context)
                                                .translate("send_report"),
                                        isSimple: true,
                                        controller: _sendButtonController,
                                        isActive: this._isActive ?? false,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                              _closeButton()
                            ],
                          ),
                        );
                      }
                      if (reportState is ReportLoading) {
                        return Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                _bottomModalHeader(),
                                Container(
                                  height: 1,
                                  width: _screenSize.width,
                                  color: Color(0xffdcdcdc),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: const CupertinoActivityIndicator(),
                                ),
                              ],
                            ),
                            _closeButton()
                          ],
                        );
                      }
                      if (reportState is ReportSuccessful) {
                        return Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                _bottomModalHeader(),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                SvgPicture.asset(
                                    'assets/svg/community/ic-report-post.svg',
                                    height: 40,
                                    width: 40,
                                    color: Color(0xff000000)),
                                Text(
                                    LocalizationsUtil.of(context)
                                        .translate("send_report_successfully"),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            _closeButton()
                          ],
                        );
                      }
                      if (reportState is ReportFailure) {
                        return Stack(
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                _bottomModalHeader(),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                SvgPicture.asset(
                                    'assets/icons/ic-report-post.svg',
                                    height: 40,
                                    width: 40,
                                    color: Color(0xff000000)),
                                Text(
                                    LocalizationsUtil.of(context).translate(
                                        'there_is_an_issue_please_try_again_later_0'),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            _closeButton()
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _bottomModalHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            LocalizationsUtil.of(context).translate("report"),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _closeButton() {
    return Positioned(
      top: 0,
      left: 0,
      child: ElevatedButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0.0)),
          overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.transparent),
          backgroundColor:
              MaterialStateProperty.resolveWith((states) => Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: SvgPicture.asset(AppVectors.icClose),
      ),
    );
  }
}
