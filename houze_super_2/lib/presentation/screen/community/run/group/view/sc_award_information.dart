import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/sc_image_view.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/widget_slide_animation.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/index.dart';
import 'package:houze_super/presentation/index.dart';

class AwardInformationScreenArgument {
  final EventModel eventModel;
  const AwardInformationScreenArgument({required this.eventModel});
}

class AwardInformationScreen extends StatelessWidget {
  final AwardInformationScreenArgument argument;

  const AwardInformationScreen({Key? key, required this.argument})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<ImagesDetail> images =
        argument.eventModel.imagesDetail!.toList();

    return HomeScaffold(
      title: 'prize_information',
      child: SafeArea(
        child: CustomScrollView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
                child: WidgetBoxesContainer(
              hasLine: false,
              child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  color: Color(0xfff5f5f5),
                  child: Text(
                    LocalizationsUtil.of(context).translate('k_rules'),
                    style: AppFonts.medium.copyWith(color: Color(0xff808080)),
                  )),
            )),
            SliverToBoxAdapter(
              child: WidgetBoxesContainer(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                hasLine: false,
                title: LocalizationsUtil.of(context).translate('k_reach') +
                    ' ${argument.eventModel.targetRunUnit} ' +
                    LocalizationsUtil.of(context).translate('k_with_your_team'),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Text(
                    argument.eventModel.descriptionDetail ?? '',
                    style: AppFonts.regular14,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: images.length > 0
                    ? WidgetBoxesContainer(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        hasLine: false,
                        title:
                            LocalizationsUtil.of(context).translate('images'),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              for (var i = 0; i < images.length; i++)
                                WidgetSlideAnimation(
                                  position: i,
                                  child: GestureDetector(
                                    onTap: () {
                                      var _imgs = <String>[];
                                      images.forEach((element) =>
                                          _imgs.add(element.image));
                                      AppRouter.pushDialog(
                                        context,
                                        AppRouter.imageViewPage,
                                        ImageViewPageArgument(images: _imgs),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: CachedImageWidget(
                                        imgUrl: images[i].image,
                                        height: 180,
                                        width:
                                            AppConstant.screenWidth.toDouble(),
                                        cacheKey: images[i].id,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink())
          ],
        ),
      ),
    );
  }
}
