import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/comment_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/repo/comment_repository.dart';
import 'package:houze_super/presentation/common_widgets/textfield_widget.dart';
import 'package:houze_super/presentation/common_widgets/widget_no_data_display.dart';
import 'package:houze_super/presentation/custom_ui/widget_scaffold_presentation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/comment/widget_comment_item.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/comment/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/widget_input_bottom.dart';

import '../../../../base/route_aware_state.dart';

class TicketCommentScreenArgument {
  final String id;
  final CallBackHandlerVoid? callback;
  const TicketCommentScreenArgument({required this.id, this.callback});
}

class TicketCommentScreen extends StatefulWidget {
  final TicketCommentScreenArgument? args;

  const TicketCommentScreen({Key? key, this.args}) : super(key: key);

  @override
  TicketCommentScreenState createState() => TicketCommentScreenState();
}

class TicketCommentScreenState extends RouteAwareState<TicketCommentScreen> {
  TicketCommentScreenArgument? args;
  final repo = CommentRepository();

  final bloc = CommentBloc();
  int page = 0;
  bool shouldLoadMore = true;
  var _listTemp = <CommentModel>[];
  var _list = <CommentModel>[];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();

  final fcomment = TextFieldWidgetController();

  ScrollController _scrollController = ScrollController();

  //Comment Bloc

  var messagesList = <CommentModel>[];
  StreamController<int> totalCommentController = StreamController.broadcast();

  CommentImageModel? _imgModel;

  @override
  void initState() {
    super.initState();

    args = widget.args;
    if (args!.id.isNotEmpty)
      bloc.add(EventGetCommentList(id: args!.id, page: page));
  }

  void _onRefresh() {
    page = 0;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    bloc.add(EventGetCommentList(id: args!.id, page: page));
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  void _onLoading() {
    if (this.shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      bloc.add(EventGetCommentList(id: args!.id, page: page));
      _refreshController.loadComplete();
    }
  }

  Widget _buildInputBottom(BuildContext context) {
    return WidgetInputBottom(
      fcomment: fcomment,
      callback: () async {
        try {
          progressToolkit.state.show();
          await Future.delayed(Duration(milliseconds: 300));
          CommentModel? rs = this._imgModel != null
              ? await repo.sendComment(
                  args!.id, fcomment.controller.text.trim(), this._imgModel!)
              : await repo.sendComment(
                  args!.id, fcomment.controller.text.trim(), null);
          int total = _list.length + 1;
          totalCommentController.sink.add(total);
          _list.insert(0, rs);
          fcomment.controller.clear();
        } catch (e) {
          print(e.toString());
        } finally {
          bloc.add(EventGetCommentList(id: args!.id, page: page));
          if (args?.callback != null) args!.callback!();
          progressToolkit.state.dismiss();
          this._imgModel = null;
        }
        bloc.add(EventGetCommentList(id: args!.id, page: page));
        _scrollController.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      },
      imgCallback: (val) {
        setState(() {
          this._imgModel = val;
        });
      },
    );
  }

  Widget _buildBody() => Flexible(
      child: BlocProvider<CommentBloc>(
          create: (_) => bloc,
          child: BlocBuilder<CommentBloc, CommentState>(
              builder: (_, CommentState commentState) {
            if (commentState is CommentInitial)
              bloc.add(EventGetCommentList(id: args!.id, page: page));

            if (commentState is CommentLoading && page == 0) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColor.purple_5b00e4)));
            }

            if (commentState is CommentFailure) return SomethingWentWrong();

            if (commentState is GetCommentByIDSuccessful && _listTemp.isEmpty) {
              final List<CommentModel> test = commentState.result!;

              shouldLoadMore = test.length >= 10;
              _listTemp.addAll(test);
              if (_list.length == 1) {
                test.clear();
                _list.addAll(test.toList());
              } else {
                _list.addAll(test.toList());
              }
              if (_list.length == 0) {
                return Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                            LocalizationsUtil.of(context)
                                .translate("it's_empty"),
                            style: AppFonts.medium14)));
              }
              totalCommentController.sink.add(commentState.totalCount!);
            }

            return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: MaterialClassicHeader(),
                footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                  Widget body = CupertinoActivityIndicator();
                  if (shouldLoadMore == false) {
                    mode = LoadStatus.noMore;
                  }

                  if (mode == LoadStatus.idle || mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else {
                    body = NoDataBottomLine(parentContext: context);
                  }
                  return SizedBox(height: 80, child: Center(child: body));
                }),
                onRefresh: () {
                  _onRefresh();
                },
                onLoading: () {
                  if (mounted) {
                    _onLoading();
                  }
                },
                child: ListView.builder(
                    itemCount: _list.length,
                    padding: const EdgeInsets.all(0),
                    reverse: true,
                    shrinkWrap: true,
                    primary: false,
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: index == 0
                            ? const EdgeInsets.only(bottom: 10.0)
                            : const EdgeInsets.only(bottom: 0.0),
                        child: WidgetCommentItem(comment: _list[index]),
                      );
                    }));
          })));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BaseScaffoldPresent(
            title: 'all_comment',
            body: GestureDetector(
                onTap: () {
                  bool isKeyboardShowing =
                      MediaQuery.of(context).viewInsets.bottom > 0;
                  if (isKeyboardShowing) {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  }
                },
                child: SafeArea(
                    child: Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            StreamBuilder(
                                stream: totalCommentController.stream,
                                initialData: 0,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  return Container(
                                    color: Color(0xfff5f7f8),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: horizontalPadding,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          LocalizationsUtil.of(context)
                                                  .translate('reply') +
                                              " (${snapshot.data})",
                                          style: AppFont.BOLD_BLACK.copyWith(
                                              color: AppColor.gray_808080),
                                        ),
                                        SizedBox(),
                                      ],
                                    ),
                                  );
                                }),
                            _buildBody(),
                            Divider(height: 1.0),
                            _buildInputBottom(context)
                          ],
                        ))))),
        progressToolkit
      ],
    );
  }

  @override
  void dispose() {
    totalCommentController.close();
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
