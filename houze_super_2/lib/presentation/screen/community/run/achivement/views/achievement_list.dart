import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/index.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/model/index.dart';
import 'package:houze_super/presentation/screen/community/run/blocs/run_bloc.dart';
import '../../../../../common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import '../../blocs/run_state.dart';
import '../widget/achievement_item.dart';

class AchievementListWidget extends StatelessWidget {
  const AchievementListWidget();
  @override
  Widget build(BuildContext context) {
    List<AchievementUserModel> data = [];

    return BlocBuilder<RunBloc, RunState>(
      buildWhen: (p, c) => p.achivements != c.achivements,
      builder: (context, state) {
        if (state.achivements != null) {
          data = state.achivements!;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection(
                icon: AppVectors.icBadgeSmall,
                title: LocalizationsUtil.of(context)
                    .translate('k_medal'), //'Danh hiệu',
                isViewAll: true,
                callback: () {
                  AppRouter.pushNoParams(
                    context,
                    AppRouter.MEDAL_RECTANGLE_PAGE,
                  );
                },
              ),
              data.length == 0
                  ? SizedBox(
                      height: 80,
                      width: 100,
                      child: SvgPicture.asset(
                        AppVectors.icMedal1Disabled,
                        alignment: Alignment.centerRight,
                      ),
                    )
                  : SizedBox(
                      height: 80,
                      width: double.maxFinite,
                      child: CustomScrollView(
                        scrollDirection: Axis.horizontal,
                        cacheExtent: MailboxStyle.heightItem,
                        slivers: <SliverList>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, int index) {
                                final double _right =
                                    (index == data.length - 1) ? 20.0 : 0.0;
                                final AchievementModel? item =
                                    data[index].achievement;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: _right,
                                    top: 0,
                                  ),
                                  child: AchievementItem(
                                    achievementModel: item!,
                                    size: 80.0,
                                    active: true,
                                  ),
                                );
                              },
                              childCount: data.length,
                            ),
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 20,
              )
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ParkingCardSkeleton(
                height: 16,
                width: ScreenUtil.defaultSize.width,
              ),
              const SizedBox(height: 5),
              ParkingCardSkeleton(
                height: 16,
                width: ScreenUtil.defaultSize.width,
              ),
            ],
          ),
        );
      },
    );
  }
}
