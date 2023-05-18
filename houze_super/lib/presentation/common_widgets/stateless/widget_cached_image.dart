import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';

class CachedImageWidget extends StatelessWidget {
  final String cacheKey;
  final String imgUrl;
  final double width;
  final double height;

  const CachedImageWidget({
    @required this.cacheKey,
    @required this.imgUrl,
    this.width,
    this.height,
  });

  @override
  CachedNetworkImage build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      cacheManager: CacheManager(
        Config(
          cacheKey,
          stalePeriod: const Duration(
            days: 7,
          ),
        ),
      ),
      placeholder: (context, url) => ParkingCardSkeleton(
        height: height,
        width: width,
      ),
      errorWidget: (context, url, error) {
        print(error);
        return Icon(
          Icons.error_outline,
          color: Color(0xff5b00e4),
        );
      },
      width: width,
      height: height,
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );
  }
}
