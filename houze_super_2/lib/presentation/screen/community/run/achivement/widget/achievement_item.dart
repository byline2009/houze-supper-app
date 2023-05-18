import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/screen/community/run/achivement/model/achivement_model.dart';

class AchievementItem extends StatelessWidget {
  final AchievementModel achievementModel;
  final bool active;
  final double size;

  const AchievementItem(
      {Key? key,
      required this.achievementModel,
      required this.size,
      this.active = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      achievementModel.medalIcon(
        active: active,
      ),
      width: size,
      height: size,
    );
  }
}
