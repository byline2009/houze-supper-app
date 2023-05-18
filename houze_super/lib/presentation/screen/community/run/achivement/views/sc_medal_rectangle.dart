import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:houze_super/middle/repo/achievement_repo.dart';
import 'package:houze_super/presentation/index.dart';

import 'package:houze_super/presentation/screen/community/run/achivement/model/index.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/widget/medal_rectange_item.dart';
import 'package:houze_super/presentation/screen/community/run/widgets/index.dart';
import 'package:houze_super/presentation/screen/community/index.dart';

import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/pull_to_refresh.dart';

import 'package:houze_super/utils/index.dart';

import '../bloc/index.dart';

//---SCREEN: Danh hiệu---//

class MedalItem {
  final AchievementModel model;
  final bool active;

  const MedalItem({
    @required this.model,
    this.active = false,
  });
}

class RaceBadgeItem {
  final String name;
  final String image;
  final bool active;

  const RaceBadgeItem({
    @required this.name,
    @required this.image,
    this.active = false,
  });
}

class MedalRectangleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MedalRectangleScreenState();
}

class _MedalRectangleScreenState extends State<MedalRectangleScreen> {
  RefreshController _refreshController;
  AchievementBloc _achievementBloc;
  List<MedalItem> unactiveList;
  @override
  void initState() {
    super.initState();
    unactiveList = RunConstant.medals;

    _refreshController = RefreshController();
    _achievementBloc = AchievementBloc(
      repo: AchievementRepository(),
    );
  }

  @override
  void dispose() {
    if (_refreshController != null) _refreshController.dispose();
    if (_achievementBloc != null) _achievementBloc.close();
    super.dispose();
  }

  void _onRefresh() {
    if (_achievementBloc != null) {
      _achievementBloc.add(
        AchievementsLoaded(
          page: 0,
        ),
      );
      _refreshController.refreshCompleted();
    }
  }

  void _onLoading() {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final sizeSys = MediaQuery.of(context).size;
    final double _widthItem = (sizeSys.width - 60) / 3;

    return HomeScaffold(
      title: 'k_medal',
      child: BlocProvider(
        create: (context) => _achievementBloc,
        child: BlocBuilder<AchievementBloc, AchievementState>(
          builder: (BuildContext context, AchievementState achievementState) {
            if (achievementState is AchievementInitial) {
              _achievementBloc.add(
                AchievementsLoaded(
                  page: 0,
                ),
              );
            }

            if (achievementState is AchievementLoadFailure) {
              return SomethingWentWrong();
            }

            if (achievementState is AchievementsLoadSuccess) {
              final List<AchievementUserModel> data =
                  achievementState.achivements;
              List<MedalItem> _result = [];

              _result = unactiveList.map(
                (medal) {
                  if (data.any((activeItem) =>
                      activeItem.achievement.target == medal.model.target)) {
                    medal = MedalItem(model: medal.model, active: true);
                  } else {
                    medal = MedalItem(model: medal.model, active: false);
                  }

                  return medal;
                },
              ).toList();

              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: MaterialClassicHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      headerSection(
                        LocalizationsUtil.of(context)
                            .translate('k_medals_all_activated'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MedalRectangleItem(
                              item: _result.first,
                              width: _widthItem,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            MedalRectangleItem(
                              item: _result[1],
                              width: _widthItem,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            MedalRectangleItem(
                              item: _result[2],
                              width: _widthItem,
                            ),
                          ],
                        ),
                        height: 132,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MedalRectangleItem(
                              item: _result[3],
                              width: _widthItem,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            MedalRectangleItem(
                              item: _result[4],
                              width: _widthItem,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            MedalRectangleItem(
                              item: _result[5],
                              width: _widthItem,
                            ),
                          ],
                        ),
                        height: 132,
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget headerSection(String header) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color(0xfff5f5f5),
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      child: Text(
        header,
        style: AppFonts.medium.copyWith(color: Color(0xff808080)),
      ),
    );
  }
}
