import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/stateless/textfield_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_no_data_display.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_scaffold_presentation.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/bloc/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/networking/poll_comment_repo.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/widget/widget_input_comment_bottom.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/widget/widget_poll_comment_item.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/networking/poll_repo.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

/*
 * Screen: Bình luận
 */
class SocialCommentScreenArgument {
  final String threadId;
  final Function callback;
  final bool renderedInDiscussion;
  const SocialCommentScreenArgument(
      {@required this.threadId, this.callback, this.renderedInDiscussion});
}

class SocialCommentScreen extends StatefulWidget {
  final SocialCommentScreenArgument args;

  const SocialCommentScreen({Key key, this.args}) : super(key: key);

  @override
  SocialCommentScreenState createState() => SocialCommentScreenState();
}

class SocialCommentScreenState extends State<SocialCommentScreen> {
  SocialCommentScreenArgument args;
  final _repo = PollCommentRepository();
  final _bloc = PollCommentBloc();
  int page = 0;
  bool shouldLoadMore = true;
  var _listTemp = <PollCommentModel>[];
  var _list = <PollCommentModel>[];
  List<CommentActionType> _listAction = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();
  final fcomment = TextFieldWidgetController();
  bool _didTap = false;
  bool _flag = true;
  ScrollController _scrollController = ScrollController();
  StreamController<int> totalCommentController = StreamController.broadcast();
  int currentIndex = 1;
  String imageID;
  int commentQuantity = 0;
  final _pollRepository = PollRepository();

  _getUserPermission() async {
    final _userPermission = await _pollRepository.getUserPermission();

    if (!args.renderedInDiscussion && _userPermission.canCommentPoll) {
      //be able to comment in poll/voting
      _showModalBottomSheet();
      //enable input bottom tapping
      setState(() {
        this._flag = true;
      });
      return;
    }
    if (args.renderedInDiscussion && _userPermission.canPost) {
      //be able to comment in discussion
      _showModalBottomSheet();
      //enable input bottom tapping
      setState(() {
        this._flag = true;
      });
      return;
    }

    //stop blocked user from commenting
    DialogCustom.showErrorDialog(
        context: context,
        title: "attention",
        errMsg: "block_comment_content",
        buttonText: "ok",
        callback: () {
          //enable input bottom tapping
          setState(() {
            this._flag = true;
          });
          Navigator.of(context).pop();
        });
  }

  @override
  void initState() {
    super.initState();
    this._listAction = [
      CommentActionType(displayType: 0, text: "Hiện tên thật"),
      CommentActionType(
          displayType: 1, text: Storage.getPhoneNumber().toString())
    ];

    args = widget.args;
    if (args.threadId.isNotEmpty)
      _bloc.add(EventGetPollCommentList(
          id: args.threadId, page: page, ordering: "-created"));
  }

  void _onRefresh() {
    page = 0;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    _bloc.add(EventGetPollCommentList(
        id: args.threadId, page: page, ordering: "-created"));
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  void _onLoading() {
    if (this.shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      _bloc.add(EventGetPollCommentList(
          id: args.threadId, page: page, ordering: "-created"));
      _refreshController.loadComplete();
    }
  }

  Widget _buildInputBottom(BuildContext context) {
    return AbsorbPointer(
      absorbing: !this._flag, // prevent multiple tap
      child: GestureDetector(
        onTap: () {
          setState(() {
            this._flag = false;
          });
          _getUserPermission();
        },
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 10.0, right: 20.0),
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
                          LocalizationsUtil.of(context)
                                  .translate("write_your_comment") +
                              "...",
                          style: AppFonts.medium
                              .copyWith(color: Color(0xff808080)),
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
                          disabledColor: Colors.white,
                          onPressed: null,
                          child: Text(
                              LocalizationsUtil.of(context).translate("send"),
                              style: AppFonts.medium12
                                  .copyWith(color: Color(0xff808080))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
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
                          "0" +
                              Storage.getPhoneNumber()
                                  .toString()
                                  .substring(0, 6) +
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
      isDismissible: false,
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
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    height: 30.0,
                                    width: 30.0,
                                    child: Center(
                                      child: SvgPicture.asset(
                                        AppVectors.icClose,
                                        height: 14.0,
                                        width: 14.0,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          15.0,
                                        ),
                                      ),
                                    ),
                                  ),
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
                              WidgetInputCommentBottom(
                                didTap: _didTap,
                                hintText: "write_your_comment",
                                fcomment: fcomment,
                                postImageUrl: PollPath.postImage,
                                callback: !this._didTap
                                    ? () async {
                                        setState(() {
                                          this._didTap = true;
                                        });
                                        try {
                                          PollCommentModel rs =
                                              await _repo.sendComment(
                                            fcomment.controller.text,
                                            this.currentIndex,
                                            args.threadId,
                                            this.imageID,
                                          );
                                          fcomment.controller.clear();
                                          setState(() {
                                            if (rs != null) {
                                              totalCommentController.sink
                                                  .add(commentQuantity + 1);
                                              _list.insert(0, rs);
                                              this._didTap = false;
                                            }
                                          });
                                          Navigator.of(context).pop();
                                        } catch (error) {
                                          final body = json.decode(error);
                                          if (body['detail'] ==
                                              "You do not have permission to comment on poll.") {
                                            DialogCustom.showErrorDialog(
                                                context: context,
                                                title: "attention",
                                                errMsg: "block_comment_content",
                                                buttonText: "ok",
                                                callback: () {
                                                  if (this.imageID != null) {
                                                    this.imageID = null;
                                                  }
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                });
                                          } else {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  content: Text(
                                                    LocalizationsUtil.of(
                                                            context)
                                                        .translate(
                                                            'there_is_an_issue_please_try_again_later_0'),
                                                    style: TextStyle(
                                                        fontFamily: AppFonts
                                                            .font_family_display),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      onPressed: () {
                                                        if (this.imageID !=
                                                            null) {
                                                          this.imageID = null;
                                                        }
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        LocalizationsUtil.of(
                                                                context)
                                                            .translate('ok'),
                                                        style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .font_family_display),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        } finally {
                                          setState(() {
                                            _bloc.add(EventGetPollCommentList(
                                                id: args.threadId,
                                                page: this.page,
                                                ordering: "-created"));
                                            this.imageID = null;
                                          });
                                        }
                                        setState(() {
                                          _bloc.add(EventGetPollCommentList(
                                              id: args.threadId,
                                              page: this.page));
                                          _scrollController.animateTo(0.0,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeOut);
                                        });
                                      }
                                    : () {},
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

  Widget _buildBody() => Container(
          child: BlocProvider<PollCommentBloc>(
        create: (_) => _bloc,
        child: BlocBuilder<PollCommentBloc, PollCommentState>(
          builder: (_, PollCommentState state) {
            if (state is PollCommentInitial) {
              _bloc.add(EventGetPollCommentList(
                  id: args.threadId, page: page, ordering: "-created"));
            }

            if (state is PollCommentLoading && page == 0) {
              return CommentLoading();
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
                return Expanded(
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                              LocalizationsUtil.of(context)
                                  .translate("it's_empty"),
                              style: AppFonts.medium14
                                  .copyWith(color: Colors.black)))),
                );
              }
              totalCommentController.sink.add(state.totalCount);
            }

            return Expanded(
              child: Container(
                color: Colors.white,
                child: SmartRefresher(
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
                    return SizedBox(height: 30, child: Center(child: body));
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
                      return WidgetPollCommentItem(comment: _list[index]);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ));

  onPressLeading() {
    if (args.callback != null) {
      args.callback(count: commentQuantity);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (args.callback != null) {
          args.callback(count: commentQuantity);
        }
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Stack(
        children: <Widget>[
          BaseScaffoldPresent(
              title: 'all_comment',
              onPressLeading: onPressLeading != null ? onPressLeading : null,
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
                                    commentQuantity = snapshot.data;
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
                                            style: AppFonts.bold.copyWith(
                                                color: Color(0xff808080)),
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
      ),
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

class CommentActionType {
  final int displayType;
  final String text;
  const CommentActionType({this.displayType, this.text});
}

class CommentLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: ListSkeleton(
          length: 4,
          shrinkWrap: true,
          config: SkeletonConfig(
            isCircleAvatar: true,
            isShowAvatar: true,
            theme: SkeletonTheme.Light,
            bottomLinesCount: 2,
          ),
        ),
      ),
    );
  }
}
