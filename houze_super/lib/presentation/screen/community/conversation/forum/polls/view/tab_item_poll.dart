import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/common_widgets/stateless/empty_page.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_no_data_display.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/poll_bloc.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/poll_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/poll_state.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/widget/widget_poll_item.dart';
import 'package:houze_super/utils/index.dart';

/*
 * Screen: Bình chọn
 */

class TabItemPoll extends StatefulWidget {
  @override
  _TabItemPollState createState() => _TabItemPollState();
}

class _TabItemPollState extends State<TabItemPoll> {
  final _pollBloc = PollBloc();
  final _refreshController = RefreshController(initialRefresh: true);
  final _scrollController = ScrollController();
  int page = 1;
  bool shouldLoadMore = true;
  var _listTemp = <PollModel>[];
  var _list = <PollModel>[];

  void _onLoading() {
    if (this.shouldLoadMore && !_pollBloc.isLoading) {
      this.page++;
      _listTemp.clear();
      _pollBloc.add(GetPollsEvent(
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
    _pollBloc.add(GetPollsEvent(
      page: page,
    ));

    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    _pollBloc.add(GetPollsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SmartRefresher(
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

          if (_pollBloc.isNext == false) {
            mode = LoadStatus.noMore;
          }

          if (mode == LoadStatus.loading) {
            body = LoadingSkeleton();
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
        child: BlocProvider<PollBloc>(
          create: (_) => _pollBloc,
          child: BlocBuilder<PollBloc, PollState>(
            builder: (BuildContext context, PollState _pollState) {
              if (_pollState == null) {
                return Center(
                    child: Text(LocalizationsUtil.of(context)
                        .translate("lost_connection")));
              }

              if (_pollState is PollLoading && page == 1) {
                return LoadingSkeleton();
              }

              _refreshController.loadComplete();
              _refreshController.refreshCompleted();

              if (_pollState is PollListSuccess && _listTemp.isEmpty) {
                if (_pollState.pollList.length > 0) {
                  final List<PollModel> test = _pollState.pollList;
                  shouldLoadMore = test.length >= AppConstant.limitDefault;
                  _listTemp.addAll(test);
                  _list.addAll(test.toList());
                }

                if (_list.length == 0) {
                  return EmptyPage(
                    svgPath: AppVectors.icFacility,
                    content: 'there_is_no_information',
                  );
                }
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
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
                              WidgetPollItem(
                                pollModel: _list[index],
                                pollBloc: _pollBloc,
                              ),
                              Container(
                                color: Color(0xfff5f5f5),
                                height: 5.0,
                              )
                            ],
                          );
                        }
                        if (_pollState is PollLoading) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: const Center(
                                child: CupertinoActivityIndicator()),
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
      ),
    );
  }
}

class LoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
    );
  }
}
