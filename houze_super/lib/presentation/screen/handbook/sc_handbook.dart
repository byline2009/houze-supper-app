import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/handbook_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/empty_page.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/pull_to_refresh.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/flutter_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/handbook/bloc/handbook_bloc.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/widget_footer.dart';
import 'package:houze_super/presentation/screen/sell/list/widget_create_date_seemore_bottom.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/index.dart';

import 'bloc/handbook_event.dart';
import 'bloc/handbook_state.dart';

class HandbookScreen extends StatefulWidget {
  @override
  _HandbookScreenState createState() => _HandbookScreenState();
}

class _HandbookScreenState extends State<HandbookScreen> {
  final _bloc = HandbookBloc();

  final _scrollController = ScrollController();
  final _listTemp = <Handbook>[];
  final _list = <Handbook>[];

  int _page = 0;
  final _refreshController = RefreshController();
  bool shouldLoadMore = true;
  Future _service;

  void _onRefresh() {
    _page = 0;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    _bloc.add(HandbookGetList(page: _page));
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  void _onLoading() {
    if (this.shouldLoadMore) {
      this._page++;
      _listTemp.clear();
      _bloc.add(HandbookGetList(page: _page));
      _refreshController.loadComplete();
    }
  }

  @override
  void initState() {
    _service = ServiceConverter.getTextToConvert("building_handbook");
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _service,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return HandbookLoadingSkeleton();
          }
          return HomeScaffold(
            title: snap.data,
            child: BlocProvider<HandbookBloc>(
              create: (_) => _bloc,
              child: BlocBuilder<HandbookBloc, HandbookState>(
                  builder: (_, HandbookState state) {
                if (state is HandbookInitial) {
                  _bloc.add(HandbookGetList(page: _page));
                }

                if (state is HandbookGetLoading && _page == 0) {
                  return HandbookLoadingSkeleton();
                }

                if (state is HandbookGetFailure &&
                    state.error.error is! NoDataToLoadMoreException) {
                  if (state.error.error is NoDataException)
                    return SomethingWentWrong(true);
                  else
                    return SomethingWentWrong();
                }

                if (state is HandbookListGetSuccessful && _listTemp.isEmpty) {
                  final List<Handbook> test = (state.handbooks.results as List)
                      .map((e) => Handbook.fromJson(e))
                      .toList();

                  shouldLoadMore = test.length >= AppConstant.limitDefault;
                  _listTemp.addAll(test);
                  _list.addAll(test.toList());
                  if (_list.length == 0) {
                    return const EmptyPage(
                      svgPath: AppVectors.handbook,
                      content: 'there_is_no_information',
                    );
                  }
                }
                return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: MaterialClassicHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    footer: WidgetFooter(
                      datasource: _list,
                      shouldLoadMore: shouldLoadMore,
                    ),
                    child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        itemCount: _list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return buildItem(index, context);
                        }));
              }),
            ),
          );
        });
  }

  InkWell buildItem(int index, BuildContext context) {
    var e = _list[index];
    return InkWell(
      onTap: () => AppRouter.push(context, AppRouter.HANDBOOK_DETAIL, e),
      child: Container(
        key: Key(e.id),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: Color(0xffdcdcdc),
                  width: 1,
                  style: BorderStyle.solid)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 15.0),
            Row(
              children: <Widget>[
                ClipOval(
                    child: SvgPicture.asset(AppVectors.handbook,
                        width: 40.0, height: 40.0)),
                const SizedBox(width: 8.0),
                Expanded(child: Text(e.title, style: AppFonts.regular15)),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              LocalizationsUtil.of(context).translate('view_documents_detail'),
              style: AppFonts.regular13,
            ),
            const SizedBox(height: 8.0),
            CreateDateSeemoreBottom(created: e.created),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class HandbookLoadingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListSkeleton(
          shrinkWrap: true,
          length: 4,
          config: SkeletonConfig(
            theme: SkeletonTheme.Light,
            isShowAvatar: true,
            isCircleAvatar: true,
            bottomLinesCount: 2,
          )),
    );
  }
}
