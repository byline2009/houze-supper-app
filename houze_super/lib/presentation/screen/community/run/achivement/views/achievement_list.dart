import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/index.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/model/index.dart';
import '../widget/achievement_item.dart';

class AchievementListWidget extends StatelessWidget {
  const AchievementListWidget({
    @required this.achivements,
  });
  final List<AchievementUserModel> achivements;
  @override
  Widget build(BuildContext context) {
    final List<AchievementUserModel> data = achivements;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderSection(
          icon: AppVectors.icBadgeSmall,
          title:
              LocalizationsUtil.of(context).translate('k_medal'), //'Danh hiệu',
          isViewAll: true,
          callback: () {
            AppRouter.pushNoParams(
              context,
              AppRouter.MEDAL_RECTANGLE_PAGE,
            );
          },
        ),
        data == null || data.length == 0
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
                width: ScreenUtil.screenWidth,
                child: CustomScrollView(
                  scrollDirection: Axis.horizontal,
                  cacheExtent: MailboxStyle.heightItem,
                  slivers: <SliverList>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, int index) {
                          double _right =
                              (index == data.length - 1) ? 20.0 : 0.0;
                          final AchievementModel item = data[index].achievement;
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: _right ?? 0,
                              top: 0,
                            ),
                            child: AchievementItem(
                              achievementModel: item,
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
        const SizedBox(height: 20)
      ],
    );
  }
}
