import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/common_widgets/stateless/empty_page.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/view/sc_post_thread.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/networking/poll_repo.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_no_data_display.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/discussion_bloc.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/widgets/widget_discussion_item.dart';

/*
 * Screen: Thảo luận
 */

const String avatarHomeKey = 'avatarHomeKey';

class TabItemDiscussion extends StatefulWidget {
  @override
  _TabItemDiscussionState createState() => _TabItemDiscussionState();
}

class _TabItemDiscussionState extends State<TabItemDiscussion> {
  final _discussionBloc = DiscussionBloc();
  final _refreshController = RefreshController(initialRefresh: true);
  final _scrollController = ScrollController();
  int page = 1;
  bool shouldLoadMore = true;
  var _listTemp = <DiscussionModel>[];
  var _list = <DiscussionModel>[];
  final _pollRepository = PollRepository();
  bool _flag = true;

  void _onLoading() {
    if (this.shouldLoadMore && !_discussionBloc.isLoading) {
      this.page++;
      _listTemp.clear();
      _discussionBloc.add(GetDiscusionList(
        page: page,
      ));
    }
    _refreshController.loadComplete();
  }

  void _onRefresh() {
    page = 1;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    _discussionBloc.add(GetDiscusionList(
      page: page,
    ));

    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    _discussionBloc.add(GetDiscusionList());
    super.initState();
  }

  _getUserPermission() async {
    final _userPermission = await _pollRepository.getUserPermission();
    if (_userPermission.canPost) {
      //be able to post
      AppRouter.pushParamsWithCallback(context, AppRouter.POST_THREAD_PAGE,
          PostThreadScreenArgument(isDetailPage: true), _onCallBack);
      this._flag = true;
    } else {
      //stop blocked user from posting discussion
      DialogCustom.showErrorDialog(
          context: context,
          title: "attention",
          errMsg: "block_discussion_content",
          buttonText: "ok",
          callback: () {
            setState(() {
              this._flag = true;
            });
            Navigator.of(context).pop();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      physics: const NeverScrollableScrollPhysics(),
      header: MaterialClassicHeader(),
      footer: CustomFooter(builder: (BuildContext context, LoadStatus mode) {
        Widget body = SizedBox.shrink();

        if (shouldLoadMore == false) {
          mode = LoadStatus.noMore;
        }

        if (_discussionBloc.isNext == false) {
          mode = LoadStatus.noMore;
        }

        if (mode == LoadStatus.loading) {
          body = TabLoading();
        }

        if (mode == LoadStatus.noMore) {
          body = NoDataBottomLine(parentContext: context);
        }

        return SizedBox(
          height: 50.0,
          child: Center(child: body),
        );
      }),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: BlocProvider<DiscussionBloc>(
        create: (_) => _discussionBloc,
        child: BlocBuilder<DiscussionBloc, DiscussionState>(
          builder: (BuildContext context, DiscussionState _discussionState) {
            if (_discussionState == null) {
              return Center(
                  child: Text(LocalizationsUtil.of(context)
                      .translate("lost_connection")));
            }

            if (_discussionState is DiscussionLoading && page == 1) {
              return TabLoading();
            }

            _refreshController.loadComplete();
            _refreshController.refreshCompleted();

            if (_discussionState is DiscussionListSuccess &&
                _listTemp.isEmpty) {
              if (_discussionState.discussionList.length > 0) {
                final List<DiscussionModel> test =
                    _discussionState.discussionList;
                shouldLoadMore = test.length >= AppConstant.limitDefault;
                _listTemp.addAll(test);
                _list.addAll(test.toList());
              }

              if (_list.length == 0) {
                return Column(
                  children: [
                    postDiscussion(context),
                    EmptyPage(
                      svgPath: AppVectors.icChatLight,
                      content: LocalizationsUtil.of(context)
                          .translate('no_discussions_yet'),
                      width: 60,
                      height: 60,
                    ),
                  ],
                );
              }
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  postDiscussion(context),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    itemCount: _list.length + 1,
                    controller: _scrollController,
                    itemBuilder: (contex, index) {
                      if (index < _list.length) {
                        return Column(
                          children: [
                            WidgetDiscussionItem(
                              callback: (value) {
                                if (value) {
                                  _onRefresh();
                                }
                              },
                              discussionBloc: _discussionBloc,
                              isRenderedInDetailPage: false,
                              isDisableHeader: false,
                              discussionModel: _list[index],
                            ),
                            Container(
                              color: Color(0xfff5f5f5),
                              height: 5.0,
                            )
                          ],
                        );
                      }

                      if (_discussionState is DiscussionLoading) {
                        return const Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(child: CupertinoActivityIndicator()),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _onCallBack(dynamic value) {
    // widget.callback(true);
    _onRefresh();
  }

  Widget postDiscussion(BuildContext context) {
    const double size = 30;
    const ratio = size / 2;

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
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
          height: 44.0,
          decoration: const BoxDecoration(
            color: Color(0xfff5f5f5),
            borderRadius: BorderRadius.all(
              Radius.circular(100.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Color(0xffc4c4c4),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(ratio),
                      ),
                      border: Border.all(
                        color: Color(0xffffff),
                        width: 1.0,
                      ),
                    ),
                    child: BaseWidget.avatar(
                        imageUrl: Storage.getAvatar(), size: 48.0),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${LocalizationsUtil.of(context).translate('what_do_you_want_to_discuss')}?...',
                    style: AppFonts.regular15.copyWith(
                      color: Color(0xff838383),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SvgPicture.asset(AppVectors.icAttachImageIssue),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TabLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: ListSkeleton(
        length: 4,
        shrinkWrap: true,
        config: SkeletonConfig(
          isCircleAvatar: false,
          isShowAvatar: false,
          theme: SkeletonTheme.Light,
          bottomLinesCount: 2,
        ),
      ),
    );
  }
}
