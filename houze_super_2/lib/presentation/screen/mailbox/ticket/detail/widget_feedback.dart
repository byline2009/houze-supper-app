import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/comment_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/middle/repo/comment_repository.dart';
import 'package:houze_super/presentation/common_widgets/textfield_widget.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/comment/sc_ticket_comment.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/comment/widget_comment_item.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/comment/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/widget_input_bottom.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';

class WidgetFeedback extends StatefulWidget {
  final TicketDetailModel ticket;
  final ProgressHUD progressToolkit;
  const WidgetFeedback({required this.ticket, required this.progressToolkit});

  @override
  _WidgetFeedbackState createState() => _WidgetFeedbackState();
}

class _WidgetFeedbackState extends State<WidgetFeedback> {
  var commentRepository = CommentRepository();
  final bloc = CommentBloc();
  final totalCommentController = StreamController<int>();
  final fcomment = TextFieldWidgetController();
  //Service converter
  Future<String> serviceConverter() {
    final service = ServiceConverter.convertTypeBuilding("resident");
    return service;
  }

  CommentImageModel? _imgModel;

  @override
  void initState() {
    super.initState();

    bloc.add(EventGetCommentByID(id: widget.ticket.id!));
  }

  @override
  void dispose() {
    totalCommentController.close();
    bloc.close();
    fcomment.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      },
      child: Column(children: <Widget>[
        WidgetSectionTitle(
          title: 'reply',
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.padded,
              padding: EdgeInsets.all(0),
            ),
            onPressed: () {
              AppRouter.pushDialog(
                  context,
                  AppRouter.TICKET_COMMENT_PAGE,
                  TicketCommentScreenArgument(
                      id: widget.ticket.id!,
                      callback: () {
                        bloc.add(EventGetCommentByID(id: widget.ticket.id!));
                      }));
            },
            child: StreamBuilder(
              stream: totalCommentController.stream,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Text(
                    LocalizationsUtil.of(context).translate("see_all") +
                        " (${snapshot.data})",
                    style: AppFont.MEDIUM_PURPLE_6001d2_14);
              },
            ),
          ),
        ),
        BlocProvider<CommentBloc>(
          create: (_) => bloc,
          child: BlocBuilder<CommentBloc, CommentState>(
              builder: (BuildContext context, CommentState commentState) {
            if (commentState is GetCommentByIDSuccessful) {
              if (commentState.result!.length == 0) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      LocalizationsUtil.of(context).translate(
                        LocalizationsUtil.of(context).translate("it's_empty"),
                      ),
                      style: AppFonts.medium14,
                    ),
                  ),
                );
              }
              CommentModel _commentFirst = commentState.result!.first;
              totalCommentController.sink.add(commentState.totalCount!);

              return WidgetCommentItem(comment: _commentFirst);
            }

            return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(child: CupertinoActivityIndicator()));
          }),
        ),
        SizedBox(height: 20),
        WidgetSectionTitle(title: ''),
        _buildInputBottom(context)
      ]),
    );
  }

  Widget _buildInputBottom(BuildContext context) {
    CommentRepository repo = CommentRepository();
    return WidgetInputBottom(
      fcomment: fcomment,
      callback: () async {
        try {
          widget.progressToolkit.state.show();
          Future.delayed(Duration(seconds: 2));
          await repo.sendComment(widget.ticket.id!,
              fcomment.controller.text.trim(), this._imgModel);

          bloc.add(EventGetCommentByID(id: widget.ticket.id!));
          fcomment.controller.clear();
          // Firebase analytics
          GetIt.instance<FBAnalytics>()
              .sendEventSendMessageRequest(userID: Storage.getUserID() ?? "");
        } catch (e) {
          print(e.toString());
        } finally {
          widget.progressToolkit.state.dismiss();
          this._imgModel = null;
        }
      },
      imgCallback: (val) {
        setState(() {
          this._imgModel = val;
        });
      },
    );
  }
}
