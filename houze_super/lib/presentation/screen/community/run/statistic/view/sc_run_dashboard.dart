import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/src/indicators/apple_refresh_indicator.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/index.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/blocs/dashboard/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/blocs/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/widget/widget_vertical_divider.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/index.dart';
import 'package:houze_super/presentation/screen/community/run/widgets/widget_community_failure.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';
import '../index.dart';

class RunDashboardScreen extends StatefulWidget {
  @override
  _RunDashboardScreenState createState() => _RunDashboardScreenState();
}

class _RunDashboardScreenState extends State<RunDashboardScreen>
    with TickerProviderStateMixin {
  int pickYear;
  final tabNameList = <String>[
    'k_7_days',
    'k_12_weeks',
    'k_12_months',
  ];
  TabController _nestedTabController;

  StreamController<int> _tabController = StreamController<int>.broadcast();
  DashboardBloc _dashboardBloc;
  StatisticChartBloc _statisticChartBloc;
  int _currentTab;
  @override
  void dispose() {
    _tabController.close();
    _nestedTabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dashboardBloc = context.read<DashboardBloc>();
    _statisticChartBloc = context.read<StatisticChartBloc>();
    pickYear = pickYear ?? DateTime.now().year;
    _currentTab = 0;
    _nestedTabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  Future<void> fetchDataByYear({
    @required int year,
  }) async {
    _dashboardBloc.add(
      DashboadLoadByYearEvent(year: pickYear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: 'running_statistic',
      child: CustomRefreshIndicator(
        leadingGlowVisible: false,
        trailingGlowVisible: false,
        indicatorBuilder: (BuildContext context, CustomRefreshIndicatorData d) {
          if (d.isDraging) {
            return Positioned(
              top: 20,
              right: 0,
              left: 0,
              child: Center(
                child: DraggingActivityIndicator(
                  percentageComplete: d.value,
                  radius: 12,
                ),
              ),
            );
          }

          if (d.isArmed) {
            return Positioned(
              top: 20,
              right: 0,
              left: 0,
              child: CupertinoActivityIndicator(radius: 12),
            );
          }

          return const SizedBox.shrink();
        },
        onRefresh: () async {
          await fetchDataByYear(
            year: pickYear,
          );
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: HeaderDashboardPickYear(
                currentYear: pickYear,
                callback: (value) {
                  pickYear = value;
                  fetchDataByYear(
                    year: value,
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                cubit: _dashboardBloc,
                builder: (BuildContext context, DashboardState state) {
                  if (state.isInitial)
                    fetchDataByYear(
                      year: pickYear,
                    );

                  if (state.isLoading)
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  if (state.hasError) {
                    return CommunitySomethingWentWrong();
                  }
                  if (state.hasData) {
                    final StatisticOverviewModel result =
                        state.statisticOverview;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          StatisticOverviewByYear(
                            model: result,
                            year: pickYear,
                          ),
                          const SizedBox(height: 30),
                          filterByTime(),
                          const SizedBox(height: 15),
                          StreamBuilder<int>(
                            initialData: _currentTab,
                            stream: _tabController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final TypeDistanceDate type =
                                    loadChartByType(snapshot.data);
                                context.read<StatisticChartBloc>().add(
                                      StatisticChartEvent(
                                        type: type,
                                        year: pickYear,
                                      ),
                                    );

                                return BlocBuilder<StatisticChartBloc,
                                        StatisticChartState>(
                                    cubit: _statisticChartBloc,
                                    builder:
                                        (context, StatisticChartState state) {
                                      if (state.isInitial) {
                                        _statisticChartBloc.add(
                                          StatisticChartEvent(
                                            type: type,
                                            year: pickYear,
                                          ),
                                        );
                                      }
                                      if (state.hasError) {
                                        return Center(
                                          child: SomethingWentWrong(),
                                        );
                                      }
                                      if (state.hasData) {
                                        if (snapshot.data == 0)
                                          return TabCurrentWeekChart(
                                            distanceDate: state.distanceDate,
                                          );
                                        if (snapshot.data == 1)
                                          return Tab12WeeksChart(
                                            distanceDate: state.distanceDate,
                                          );
                                        if (snapshot.data == 2)
                                          return Tab12MonthsChart(
                                            distanceDate: state.distanceDate,
                                          );
                                      }
                                      return CupertinoActivityIndicator();
                                    });
                              }
                              return CupertinoActivityIndicator();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterByTime() {
    return DecoratedBox(
      decoration: MailboxStyle.issueTabbarDecor,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: TabBar(
            onTap: (tabIndex) {
              _tabController.sink.add(tabIndex);
            },
            controller: _nestedTabController,
            labelPadding: const EdgeInsets.all(0),
            indicatorPadding: const EdgeInsets.all(0),
            indicatorColor: Colors.transparent,
            labelStyle: AppFonts.semibold.copyWith(
              fontSize: 13,
            ),
            indicator: MailboxStyle.indicatorDecor,
            labelColor: Colors.black,
            unselectedLabelStyle:
                AppFonts.semibold13.copyWith(color: Color(0xff9c9c9c)),
            unselectedLabelColor: Color(0xff9c9c9c),
            isScrollable: false,
            tabs: tabNameList
                .map((e) => _buildTabItem(
                    title: LocalizationsUtil.of(context).translate(e)))
                .toList()),
      ),
    );
  }

  TypeDistanceDate loadChartByType(int index) {
    _currentTab = index;
    if (index == 0) {
      return TypeDistanceDate.days7;
    }
    if (index == 1) {
      return TypeDistanceDate.weeks12;
    }
    return TypeDistanceDate.months12;
  }

  Container buildAccumulation(BuildContext context) {
    Flexible buildColumn(BuildContext context, {@required bool isDistance}) {
      final String title =
          isDistance ? 'accumulation_distance' : 'accumulation_time';
      final String unit = isDistance ? 'km' : 'hour';

      return Flexible(
        fit: FlexFit.tight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationsUtil.of(context).translate(title),
              style: AppFonts.semibold13.copyWith(
                color: Color(0xff838383),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              "864.4 ${LocalizationsUtil.of(context).translate(unit)}",
              style: AppFonts.bold18,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(top: 16.0, bottom: 32.0),
      child: Row(
        children: [
          buildColumn(context, isDistance: true),
          VerticalDividerWidget(32.0, 30.0),
          buildColumn(context, isDistance: false),
        ],
      ),
    );
  }

  Widget _buildTabItem({String title}) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
          color: Colors.transparent,
          border:
              Border.all(color: Colors.transparent, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: Tab(
        iconMargin: EdgeInsets.zero,
        text: LocalizationsUtil.of(context).translate(title),
      ),
    );
  }
}
