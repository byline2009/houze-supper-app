import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/middle/repo/statistic_repo.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/index.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/widget/widget_vertical_divider.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/index.dart';
import 'package:houze_super/presentation/screen/community/run/widgets/widget_community_failure.dart';

import '../blocs/bloc/statistics_by_year_bloc.dart';
import '../index.dart';
import '../widget/summary_statistic_section_in_progress.dart';

//Screen: Thống kê chạy
class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => StatisticRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => StatisticsByYearBloc(
                statisticRepository:
                    RepositoryProvider.of<StatisticRepository>(context)),
          ),
        ],
        child: RunDashboardScreen(),
      ),
    );
  }
}

class RunDashboardScreen extends StatefulWidget {
  @override
  _RunDashboardScreenState createState() => _RunDashboardScreenState();
}

class _RunDashboardScreenState extends State<RunDashboardScreen>
    with TickerProviderStateMixin {
  late int pickYear;
  final tabNameList = <String>[
    'k_7_days',
    'k_12_weeks',
    'k_12_months',
  ];
  late TabController _nestedTabController;

  int _currentTab = 0;
  @override
  void dispose() {
    _nestedTabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pickYear = DateTime.now().year;

    _currentTab = 0;
    _nestedTabController = TabController(
      length: 3,
      vsync: this,
    );
    fetchData();
  }

  Future<void> fetchData() async {
    context.read<StatisticsByYearBloc>().add(StatisticsByYearPicked(
          pickYear,
          _currentTypeDistance,
        ));
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
          fetchData();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: HeaderDashboardPickYear(
                currentYear: pickYear,
                callback: (value) {
                  pickYear = value;
                  context
                      .read<StatisticsByYearBloc>()
                      .add(StatisticsByYearPicked(
                        value,
                        _currentTypeDistance,
                      ));
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<StatisticsByYearBloc, StatisticsByYearState>(
                  buildWhen: ((previous, current) =>
                      previous.overview != current.overview &&
                      previous.distanceDateModel != current.distanceDateModel),
                  builder: (BuildContext context, StatisticsByYearState state) {
                    if (state.status == StatisticsByYearStatus.initial) {
                      context.read<StatisticsByYearBloc>().add(
                            StatisticsByYearPicked(
                              pickYear,
                              _currentTypeDistance,
                            ),
                          );
                    }
                    if (state.status == StatisticsByYearStatus.failure)
                      return CommunitySomethingWentWrong();

                    if (state.status == StatisticsByYearStatus.success) {
                      final StatisticOverviewModel result = state.overview!;

                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          StatisticOverviewByYear(
                            model: result,
                            year: pickYear,
                          ),
                          const SizedBox(height: 30),
                          filterByTime(),
                          const SizedBox(height: 15),
                        ],
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: StatisticInProgress(),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: BlocBuilder<StatisticsByYearBloc, StatisticsByYearState>(
                    buildWhen: ((previous, current) =>
                        previous.distanceDateModel !=
                        current.distanceDateModel),
                    builder: (context, StatisticsByYearState state) {
                      switch (state.status) {
                        case StatisticsByYearStatus.success:
                          switch (_currentTypeDistance) {
                            case TypeDistanceDate.days7:
                              return TabCurrentWeekChart(
                                distanceDate: state.distanceDateModel!,
                              );
                            case TypeDistanceDate.weeks12:
                              return Tab12WeeksChart(
                                distanceDate: state.distanceDateModel!,
                              );
                            case TypeDistanceDate.months12:
                              return Tab12MonthsChart(
                                distanceDate: state.distanceDateModel!,
                              );
                          }
                        case StatisticsByYearStatus.failure:
                          return SomethingWentWrong();

                        default:
                          return Column(
                            children: [
                              ParkingCardSkeleton(
                                  width: ScreenUtil.defaultSize.width,
                                  height: 16),
                              const SizedBox(height: 10),
                              ParkingCardSkeleton(
                                  width: ScreenUtil.defaultSize.width,
                                  height: 16),
                              const SizedBox(height: 10),
                              ParkingCardSkeleton(
                                  width: ScreenUtil.defaultSize.width,
                                  height: 16),
                              const SizedBox(height: 10),
                              ParkingCardSkeleton(
                                  width: ScreenUtil.defaultSize.width,
                                  height: 16),
                            ],
                          );
                      }
                    }),
              ),
            )
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
              _currentTab = tabIndex;
              fetchData();
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

  TypeDistanceDate get _currentTypeDistance {
    if (_currentTab == 0) {
      return TypeDistanceDate.days7;
    }
    if (_currentTab == 1) {
      return TypeDistanceDate.weeks12;
    }
    return TypeDistanceDate.months12;
  }

  Container buildAccumulation(BuildContext context) {
    Flexible buildColumn(BuildContext context, {required bool isDistance}) {
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

  Widget _buildTabItem({
    required String title,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border:
              Border.all(color: Colors.transparent, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      child: SizedBox(
        height: 34,
        child: Tab(
          iconMargin: EdgeInsets.zero,
          text: LocalizationsUtil.of(context).translate(title),
        ),
      ),
    );
  }
}
