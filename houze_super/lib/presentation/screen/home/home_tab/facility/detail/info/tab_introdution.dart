import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/stateless/sc_image_view.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_slide_animation.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

const String tabIntroductionImageKey = 'tabIntroductionImageKey';

class TabIntroduction extends StatelessWidget {
  final String content;
  final List<ImageModel> images;

  TabIntroduction({this.images, this.content});

  Widget _buildTitleSection(String title, BuildContext context) => Container(
        margin: EdgeInsets.only(bottom: 10, top: 20),
        child: Text(
          LocalizationsUtil.of(context).translate(title),
          style: AppFonts.bold.copyWith(fontSize: 16),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: <Widget>[
        _buildTitleSection('description', context),
        content.length > 0
            ? Text(content, style: AppFonts.regular14)
            : Text(
                LocalizationsUtil.of(context)
                    .translate("there_is_no_information"),
                style: AppFonts.regular14),
        _buildTitleSection('images', context),
        images.length > 0
            ? Column(
                children: <Widget>[
                  for (var index = 0; index < images.length; index++)
                    WidgetSlideAnimation(
                      position: index,
                      child: GestureDetector(
                        onTap: () {
                          var _imgs = <String>[];
                          images.forEach((element) => _imgs.add(element.image));
                          AppRouter.pushDialog(
                            context,
                            AppRouter.imageViewPage,
                            ImageViewPageArgument(
                                images: _imgs, initImg: index),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: CachedImageWidget(
                            imgUrl: images[index].image,
                            height: 180,
                            width: AppConstant.screenWidth.toDouble(),
                            cacheKey: images[index].id,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : Text(
                LocalizationsUtil.of(context)
                    .translate("there_is_no_information"),
                style: AppFonts.regular14),
      ],
    );
  }
}
