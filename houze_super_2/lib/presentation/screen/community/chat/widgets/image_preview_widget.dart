import 'package:flutter/material.dart';
import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/sc_image_view.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import '../models/index.dart';

typedef void ImagePreviewWidgetRemoveCallback();

class ImagePreviewWidget extends StatelessWidget {
  final ChatImageModel? image;
  final bool isUploading;
  final ImagePreviewWidgetRemoveCallback callbackRemoveImage;
  const ImagePreviewWidget({
    Key? key,
    required this.image,
    required this.isUploading,
    required this.callbackRemoveImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.3;
    return GestureDetector(
      onTap: () {
        if (image?.image?.isNotEmpty == true && !isUploading)
          AppRouter.push(
            context,
            AppRouter.imageViewPage,
            ImageViewPageArgument(
              images: [
                image?.image ?? '',
              ],
            ),
          );
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              right: 15,
              top: 15,
            ),
            width: width,
            child: AspectRatio(
              aspectRatio: 1.6,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: isUploading
                    ? ParkingCardSkeleton(
                        height: 80,
                        width: width,
                      )
                    : CachedImageWidget(
                        height: 80,
                        cacheKey: image?.imageThumb ?? '',
                        imgUrl: image?.imageThumb ?? '',
                        width: width,
                      ),
              ),
            ),
          ),
          Positioned(
            right: 2,
            top: 2,
            child: Visibility(
              visible: !isUploading,
              child: GestureDetector(
                onTap: callbackRemoveImage,
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 12.0,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
