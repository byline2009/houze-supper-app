import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/index.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/widget/event_description_line.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';

class HeaderEventInformation extends StatelessWidget {
  final EventModel item;
  const HeaderEventInformation({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return WidgetBoxesContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            eventNameLine(),
            timeToRunLine(context),
            EventDescriptionLineWidget(
              description: item.description ?? '',
              maxline: 3,
              style: AppFonts.bold18,
            ),
            targetLine(),
          ],
        ),
      ),
    );
  }

  Widget eventNameLine() => Text(
        item.name ?? '',
        style: AppFonts.bold18,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );

  Widget timeToRunLine(BuildContext ctx) => Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.all(
            Radius.circular(
              2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 2,
          ),
          child: Text(
            item.timeToRun(ctx) ?? '',
            style: AppFonts.semibold13,
          ),
        ),
      );

  Widget targetLine() => Builder(builder: (
        context,
      ) {
        return GestureDetector(
          onTap: () {
            AppRouter.push(
              context,
              AppRouter.AWARD_INFORMATION_SCREEN,
              AwardInformationScreenArgument(
                eventModel: item,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xffedf3ff),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocalizationsUtil.of(context).translate('k_target') +
                        ': ' +
                        LocalizationsUtil.of(context).translate('k_reach') +
                        ' ${item.targetRunUnit} ' +
                        LocalizationsUtil.of(context).translate(
                            'k_with_your_team'), //'cùng đội của bạn',
                    style: AppFonts.semibold13.copyWith(
                      color: Color(
                        0xff0044c2,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    AppVectors.ic_arrow_right,
                    color: Color(
                      0xff0044c2,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
