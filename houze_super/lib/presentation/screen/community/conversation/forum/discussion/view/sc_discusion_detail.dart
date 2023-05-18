import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/stateless/textfield_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_something_went_wrong.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/bloc/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/widget/widget_input_comment_bottom.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/networking/poll_comment_repo.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/widget/widget_poll_comment_item.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/widget/widget_poll_item.dart';
import 'package:houze_super/utils/constants/api_constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/widgets/widget_more_options.dart';

import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/widgets/widget_discussion_item.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/discussion_bloc.dart';

typedef void CallBackhandler(bool value);

class DiscussionDetailScreenArgument extends Equatable {
  const DiscussionDetailScreenArgument({
    @required this.isDetailPage,
    @required this.discussionModel,
  });
  final bool isDetailPage;
  final DiscussionModel discussionModel;

  @override
  List<Object> get props => [discussionModel];
}

class DiscussionDetailScreen extends StatefulWidget {
  final DiscussionDetailScreenArgument argument;
  final CallBackhandler callback;
  const DiscussionDetailScreen({Key key, this.argument, this.callback})
      : super(key: key);

  @override
  _DiscussionDetailScreenState createState() => _DiscussionDetailScreenState();
}

class _DiscussionDetailScreenState extends State<DiscussionDetailScreen> {
  final fcomment = TextFieldWidgetController();
  final _bloc = PollCommentBloc();
  final scrollController = ScrollController();
  final DiscussionBloc discussionBloc = DiscussionBloc();
  int page = 0;
  bool shouldLoadMore = true;
  var _listTemp = <PollCommentModel>[];
  var _list = <PollCommentModel>[];
  StreamController<int> totalCommentController = StreamController.broadcast();
  ScrollController _scrollController = ScrollController();
  int currentIndex = 1;
  String imageID;
  List<CommentActionType> _listAction = [];
  final _repo = PollCommentRepository();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int totalComments = 0;
  String currentUserId = Storage.getUserID();
  bool isLoading = false;

  @override
  void initState() {
    if (widget.argument.discussionModel.id.isNotEmpty) {
      _bloc.add(EventGetPollCommentList(
        id: widget.argument.discussionModel.id,
        page: page,
        ordering: 'created',
      ));
    }

    this._listAction = [
      CommentActionType(displayType: 0, text: "Hiện tên thật"),
      CommentActionType(
          displayType: 1, text: Storage.getPhoneNumber().toString())
    ];

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent - scrollController.offset <
          20) {
        _onLoading();
      }
    });

    super.initState();
  }

  void _onRefresh() {
    page = 0;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    _bloc.add(EventGetPollCommentList(
      id: widget.argument.discussionModel.id,
      page: page,
      ordering: 'created',
    ));
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  void _onLoading() {
    if (this.shouldLoadMore && !isLoading) {
      this.page++;
      _listTemp.clear();
      _bloc.add(EventGetPollCommentList(
        id: widget.argument.discussionModel.id,
        page: page,
        ordering: 'created',
      ));
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: _appBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(children: [
                StreamBuilder(
                    stream: totalCommentController.stream,
                    initialData: 0,
                    builder: (context, snap) {
                      return WidgetDiscussionItem(
                        callback: (value) {
                          if (widget.callback != null) {
                            widget.callback(true);
                          }
                          _onRefresh();
                        },
                        isRenderedInDetailPage: true,
                        discussionModel: widget.argument.discussionModel,
                        isDisableHeader: true,
                        totalComments: snap.data,
                      );
                    }),
                _commentSection(),
              ]),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          _buildInputBottom(context),
        ],
      ),
    );
  }

  Widget _commentSection() {
    return BlocProvider<PollCommentBloc>(
      create: (_) => _bloc,
      child: BlocBuilder<PollCommentBloc, PollCommentState>(
        builder: (_, PollCommentState state) {
          if (state is PollCommentLoading) {
            isLoading = true;
          } else {
            isLoading = false;
          }

          if (state is PollCommentInitial) {
            _bloc.add(EventGetPollCommentList(
                id: widget.argument.discussionModel.id,
                page: page,
                ordering: 'created'));
          }

          if (state is PollCommentLoading && page == 0) {
            return Padding(
              padding:const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: CupertinoActivityIndicator()),
            );
          }
          if (state is PollCommentFailure) return SomethingWentWrong();

          if (state is GetPollCommentListSuccessful && _listTemp.isEmpty) {
            final List<PollCommentModel> test = state.result;

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
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: Text(
                          LocalizationsUtil.of(context).translate("it's_empty"),
                          style: AppFonts.medium14
                              .copyWith(color: Colors.black))));
            }
            this.totalComments = state.totalCount;
            totalCommentController.sink.add(totalComments);
          }

          return Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: _list.length + 1,
              padding: const EdgeInsets.all(0),
              reverse: false,
              shrinkWrap: true,
              primary: false,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                if (index < _list.length) {
                  return WidgetPollCommentItem(comment: _list[index]);
                }

                if (state is PollCommentLoading) {
                  return Center(
                    child: Opacity(
                      opacity: 1.0,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );

          // return Expanded(
          //   child: SmartRefresher(
          //     controller: _refreshController,
          //     enablePullDown: true,
          //     enablePullUp: true,
          //     footer: CustomFooter(
          //         builder: (BuildContext context, LoadStatus mode) {
          //       Widget body = CupertinoActivityIndicator();
          //       if (shouldLoadMore == false) {
          //         mode = LoadStatus.noMore;
          //       }

          //       if (mode == LoadStatus.idle || mode == LoadStatus.loading) {
          //         body = CupertinoActivityIndicator();
          //       } else {
          //         body = NoDataBottomLine(parentContext: context);
          //       }
          //       return SizedBox(height: 30, child: Center(child: body));
          //     }),
          //     onRefresh: () {
          //       _onRefresh();
          //     },
          //     onLoading: () {
          //       if (mounted) {
          //         _onLoading();
          //       }
          //     },
          //     child: Container(
          //       color: Colors.white,
          //       child: ListView.builder(
          //         itemCount: _list.length,
          //         padding: const EdgeInsets.all(0),
          //         reverse: false,
          //         shrinkWrap: true,
          //         primary: false,
          //         controller: _scrollController,
          //         itemBuilder: (BuildContext context, int index) {
          //           return WidgetPollCommentItem(comment: _list[index]);
          //         },
          //       ),
          //     ),
          //   ),
          // );
        },
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: false,
      leading: null,
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0),
            child: Container(
                child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Stack(
                overflow: Overflow.clip,
                children: <Widget>[
                  CachedImageWidget(
                    cacheKey: pollKey,
                    imgUrl: widget.argument.discussionModel.user.imageThumb,
                    width: 40.0,
                    height: 40.0,
                  ),
                ],
              ),
            )),
          ),
          Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.argument.discussionModel.displayType ==
                                AppConstant.DISPLAY_NAME
                            ? widget.argument.discussionModel.user.fullname
                            : widget.argument.discussionModel.user.phoneNumber
                                    .toString()
                                    .substring(0, 6) +
                                '****',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (currentUserId == widget.argument.discussionModel.userId)
                    MoreOptions(
                      callback: widget.callback,
                      isRenderedInDetailPage: true,
                      discussionBloc: discussionBloc,
                      discussionModel: widget.argument.discussionModel,
                    ),
                ]),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBottom(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showModalBottomSheet();
      },
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 20.0, left: 10.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
                    child: SvgPicture.asset(AppVectors.icAttachImageIssue),
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        '${LocalizationsUtil.of(context).translate("write_your_comment")}...',
                        style:
                            AppFonts.medium.copyWith(color: Color(0xff808080)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 12.0),
                    child: ButtonTheme(
                      minWidth: 60.0,
                      height: 30.0,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xff808080)),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        textColor: Color(0xff808080),
                        color: Colors.white,
                        onPressed: () {},
                        child: Text(
                          LocalizationsUtil.of(context).translate("send"),
                          style: AppFonts.medium12.copyWith(
                            color: Color(0xff808080),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commentDisplayType() {
    return StatefulBuilder(builder: (BuildContext context, setState) {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: currentIndex != 1
                          ? Color(0xfff5f5f5)
                          : Color(0xff6001d2),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                          activeColor: Color(0xff6001d2),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          hoverColor: Color(0xff6001d2),
                          focusColor: Color(0xff6001d2),
                          value: _listAction[1].displayType,
                          groupValue: _listAction[currentIndex].displayType,
                          onChanged: (_) {
                            setState(() {
                              currentIndex = 1;
                            });
                          }),
                      BaseWidget.avatar(
                          imageUrl: Storage.getAvatar(), size: 27.0),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                          Storage.getPhoneNumber().toString().substring(0, 6) +
                              "***",
                          style: currentIndex == 1
                              ? AppFonts.semibold13
                              : AppFonts.semibold13.copyWith(
                                  color: Color(0xff838383),
                                ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: currentIndex != 0
                          ? Color(0xfff5f5f5)
                          : Color(0xff6001d2),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                          activeColor: Color(0xff6001d2),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          hoverColor: Color(0xff6001d2),
                          focusColor: Color(0xff6001d2),
                          value: _listAction[0].displayType,
                          groupValue: _listAction[currentIndex].displayType,
                          onChanged: (_) {
                            setState(() {
                              currentIndex = 0;
                            });
                          }),
                      BaseWidget.avatar(
                          imageUrl: Storage.getAvatar(), size: 27.0),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        LocalizationsUtil.of(context).translate("show_name"),
                        style: currentIndex == 0
                            ? AppFonts.semibold13
                            : AppFonts.semibold13.copyWith(
                                color: Color(0xff838383),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Container(
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
                    height: MediaQuery.of(context).size.height * 0.46,
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(20),
                            margin: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: SvgPicture.asset(AppVectors.icClose),
                                ),
                                Expanded(
                                    child: Text(
                                  LocalizationsUtil.of(context)
                                      .translate("write_comment"),
                                  textAlign: TextAlign.center,
                                  style: AppFonts.medium18
                                      .copyWith(letterSpacing: 0.29),
                                )),
                              ],
                            )),
                        Expanded(
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      LocalizationsUtil.of(context)
                                          .translate("comment_display_type"),
                                      style: AppFonts.bold15
                                          .copyWith(color: Color(0xff838383)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _commentDisplayType(),
                                ],
                              ),
                              WidgetInputCommentBottom(
                                hintText: LocalizationsUtil.of(context)
                                    .translate("write_your_comment"),
                                fcomment: fcomment,
                                postImageUrl: PollPath.postImage,
                                callback: () async {
                                  try {
                                    PollCommentModel rs =
                                        await _repo.sendComment(
                                      fcomment.controller.text,
                                      this.currentIndex,
                                      widget.argument.discussionModel.id,
                                      this.imageID,
                                    );
                                    setState(() {
                                      if (rs != null) {
                                        this.totalComments++;
                                        totalCommentController.sink
                                            .add(this.totalComments);
                                        _list.add(rs);
                                      }
                                      fcomment.controller.clear();
                                      Navigator.of(context).pop();
                                    });
                                  } catch (error) {
                                    print(error.toString());
                                  } finally {
                                    setState(() {
                                      _bloc.add(EventGetPollCommentList(
                                          ordering: 'created',
                                          id: widget
                                              .argument.discussionModel.id,
                                          page: this.page));
                                      this.imageID = null;
                                      //_scrollToBottom();
                                    });
                                  }
                                },
                                pollCommentImageCallback: (val) {
                                  if (val != null) {
                                    setState(() {
                                      this.imageID = val.id;
                                    });
                                  } else {
                                    setState(() {
                                      this.imageID = null;
                                    });
                                  }
                                },
                              )
                            ],
                          ),
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

  // _scrollToBottom() {
  //   // Make sure the frames are rendered properly
  //   if (_scrollController.hasClients) {
  //     Future.delayed(Duration(milliseconds: 500), () {
  //       SchedulerBinding.instance?.addPostFrameCallback((_) {
  //         _scrollController.animateTo(
  //             _scrollController.position.maxScrollExtent,
  //             duration: const Duration(milliseconds: 400),
  //             curve: Curves.easeOut);
  //       });
  //     });
  //   }
  // }

  @override
  void dispose() {
    totalCommentController.close();
    _scrollController.dispose();
    super.dispose();
  }
}

class CommentActionType {
  final int displayType;
  final String text;
  const CommentActionType({this.displayType, this.text});
}
