import 'package:flutter/material.dart';
import '../views/index.dart';
import '../widget/index.dart';
import 'package:houze_super/utils/index.dart';

class MedalRectangleItem extends StatelessWidget {
  final MedalItem item;
  final double width;
  const MedalRectangleItem({
    Key key,
    @required this.item,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xfff5f5f5),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: const SizedBox.shrink(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    LocalizationsUtil.of(context).translate(item.model.name),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    style: item.active
                        ? AppFonts.semibold13
                        : AppFonts.semibold13
                            .copyWith(color: Color(0xff9c9c9c)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AchievementItem(
            achievementModel: item.model,
            size: 60,
            active: item.active,
          ),
        ),
      ],
    );
  }
}
