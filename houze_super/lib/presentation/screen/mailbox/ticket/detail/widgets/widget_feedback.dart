import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/comment_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/middle/repo/comment_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateless/textfield_widget.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/comment/sc_ticket_comment.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/comment/widget_comment_item.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/comment/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/widget_input_bottom.dart';
import 'package:houze_super/utils/constants/api_constants.dart';
import 'package:houze_super/utils/index.dart';

class WidgetFeedback extends StatefulWidget {
  final TicketDetailModel ticket;
  final ProgressHUD progressToolkit;
  const WidgetFeedback({
    @required this.ticket,
    @required this.progressToolkit,
  });

  @override
  _WidgetFeedbackState createState() => _WidgetFeedbackState();
}

class _WidgetFeedbackState extends State<WidgetFeedback> {
  CommentRepository commentRepository;

  CommentBloc bloc;
  StreamController<int> totalCommentController;
  TextFieldWidgetController fcomment;

  //Service converter
  Future<String> serviceConverter() async {
    final service = await ServiceConverter.convertTypeBuilding("resident");
    return service;
  }

  CommentImageModel _imgModel;

  @override
  void initState() {
    super.initState();
    commentRepository = CommentRepository();
    bloc = CommentBloc();
    totalCommentController = StreamController<int>();
    fcomment = TextFieldWidgetController();
    bloc.add(EventGetCommentByID(id: widget.ticket.id));
  }

  @override
  void dispose() {
    if (totalCommentController != null) totalCommentController.close();
    bloc.close();
    if (fcomment != null) fcomment.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
      },
      child: Column(
        children: <Widget>[
          WidgetSectionTitle(
            title: 'reply',
            trailing: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                AppRouter.pushDialog(
                  context,
                  AppRouter.TICKET_COMMENT_PAGE,
                  TicketCommentScreenArgument(
                    id: widget.ticket.id,
                    callback: () {
                      bloc.add(
                        EventGetCommentByID(
                          id: widget.ticket.id,
                        ),
                      );
                    },
                  ),
                );
              },
              child: StreamBuilder(
                stream: totalCommentController.stream,
                initialData: 0,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Text(
                    LocalizationsUtil.of(context).translate("see_all") +
                        " (${snapshot.data})",
                    style: AppFonts.medium14.copyWith(
                      color: Color(
                        0xff6001d2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          BlocProvider<CommentBloc>(
            create: (_) => bloc,
            child: BlocBuilder<CommentBloc, CommentState>(
                builder: (BuildContext context, CommentState commentState) {
              if (commentState is GetCommentByIDSuccessful) {
                if (commentState.result.length == 0) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        LocalizationsUtil.of(context).translate(
                          LocalizationsUtil.of(context).translate("it's_empty"),
                        ),
                        style: AppFonts.medium14.copyWith(color: Colors.black),
                      ),
                    ),
                  );
                }
                final CommentModel _commentFirst = commentState.result.first;
                totalCommentController.sink.add(commentState.totalCount);
                return WidgetCommentItem(comment: _commentFirst);
              }

              return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(child: CupertinoActivityIndicator()));
            }),
          ),
          const SizedBox(height: 20),
          const WidgetSectionTitle(title: ''),
          _buildInputBottom(context)
        ],
      ),
    );
  }

  Widget _buildInputBottom(BuildContext context) {
    return WidgetInputBottom(
      hintText: "write_your_reply",
      fcomment: fcomment,
      postImageUrl: APIConstant.postCommentImage,
      callback: () async {
        try {
          widget.progressToolkit.state.show();
          await Future.delayed(Duration(seconds: 2));
          final CommentModel rs = await commentRepository.sendComment(
              widget.ticket.id,
              fcomment.controller.text.trim(),
              this._imgModel);

          if (rs != null) {
            bloc.add(EventGetCommentByID(id: widget.ticket.id));
          }
          fcomment.controller.clear();
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
