import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/sc_image_view.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';

import '../../../../app_router.dart';

class ImageOnMessage extends StatelessWidget {
  final String image;
  const ImageOnMessage({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final Size sizeSystem = MediaQuery.of(context).size;
    final double _imageWidth = sizeSystem.width * 0.18;
    final double _imageHeight = sizeSystem.height * 0.13;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: GestureDetector(
          child: CachedImageWidget(
            cacheKey: image,
            imgUrl: image,
            width: _imageWidth,
            height: _imageHeight,
          ),
          onTap: () {
            if ((image).isNotEmpty)
              AppRouter.push(
                Storage.scaffoldKey.currentContext!,
                AppRouter.imageViewPage,
                ImageViewPageArgument(
                  images: [
                    image,
                  ],
                ),
              );
          },
        ),
      ),
    );
  }
}
