import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/agent_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/empty_page.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/src/smart_refresher.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/widget_footer.dart';
import 'package:houze_super/presentation/screen/sell/components/register_button.dart';
import 'package:houze_super/presentation/screen/sell/list/widget_sell_item.dart';
import 'package:houze_super/presentation/screen/sell/sc_sell_create.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/index.dart';

class SellListPage extends StatefulWidget {
  @override
  _SellListPageState createState() => _SellListPageState();
}

class _SellListPageState extends State<SellListPage> {
  final _agentBloc = AgentBloc();

  ScrollController scrollController;
  final listTemp = <SellModel>[];
  final list = <SellModel>[];

  final refreshController = RefreshController();
  int page = 0;
  bool shouldLoadMore = true;

  void _onRefresh() {
    page = 0;
    listTemp.clear();
    list.clear();
    shouldLoadMore = true;
    _agentBloc.add(
      AgentResellLoadList(
        page: page,
      ),
    );
    refreshController.refreshCompleted();
    refreshController.loadComplete();
  }

  void _onLoading() {
    if (this.shouldLoadMore) {
      this.page++;
      listTemp.clear();
      _agentBloc.add(
        AgentResellLoadList(
          page: page,
        ),
      );
      refreshController.loadComplete();
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    refreshController.dispose();
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: 'for_sell_lease',
      child: BlocProvider<AgentBloc>(
        create: (_) => _agentBloc,
        child: BlocBuilder<AgentBloc, AgentState>(
          builder: (_, AgentState state) {
            if (state is AgentInitial)
              _agentBloc.add(
                AgentResellLoadList(
                  page: page,
                ),
              );

            if (state is AgentResellLoading && page == 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: ListSkeleton(
                  shrinkWrap: true,
                  length: 4,
                  config: SkeletonConfig(
                    theme: SkeletonTheme.Light,
                    isShowAvatar: true,
                    isCircleAvatar: true,
                    bottomLinesCount: 2,
                  ),
                ),
              );
            }

            if (state is AgentResellListFailure &&
                state.error.error is! NoDataToLoadMoreException) {
              if (state.error.error is NoDataException)
                return SomethingWentWrong(true);
              else
                return SomethingWentWrong();
            }

            if (state is AgentResellListSuccessful && listTemp.isEmpty) {
              final List<SellModel> test = (state.results.results as List)
                  .map((e) => SellModel.fromJson(e))
                  .toList();

              shouldLoadMore = test.length >= AppConstant.limitDefault;
              listTemp.addAll(test);
              list.addAll(
                test.toList(),
              );
              if (list.length == 0) {
                return const EmptyPage(
                  svgPath: AppVectors.sellAndRent,
                  content:
                      'listing_for_sell_or_for_lease_your_apartment_the_trustworthy_agents_from_houze_agent',
                );
              }
            }

            return SmartRefresher(
              enablePullUp: true,
              header: MaterialClassicHeader(),
              controller: refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              footer: WidgetFooter(
                datasource: list,
                shouldLoadMore: shouldLoadMore,
              ),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return WidgetSellItem(item: list[index]);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Container(
                  height: 1,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Color(0xffdcdcdc)),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: RegisterButtonWidget(
        callback: (type) {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) {
                    return SellCreatePage(type: type);
                  },
                  settings: RouteSettings(name: AppRouter.SELL_CREATE)))
              .then(
            (val) {
              if (val != null) this._onRefresh();
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
