import 'package:flutter/material.dart';
import '../views/index.dart';
import 'package:houze_super/utils/index.dart';

class MedalRectangleItemWidget extends StatelessWidget {
  final RaceBadgeItem item;
  const MedalRectangleItemWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width - 55) / 2;

    return Stack(
      fit: StackFit.passthrough,
      overflow: Overflow.visible,
      children: <Widget>[
        SizedBox(
          height: 112,
          width: width,
        ),
        Positioned(
          top: 20,
          right: 0,
          bottom: 0,
          child: Container(
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
            height: 102,
            width: width,
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Container(
            alignment: Alignment.center,
            height: 100,
            width: 85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Image(
                    image: AssetImage(
                      item.image,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Text(
                    LocalizationsUtil.of(context).translate(
                      item.name,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: item.active
                        ? AppFonts.semibold13
                        : AppFonts.semibold13
                            .copyWith(color: Color(0xff9c9c9c)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
