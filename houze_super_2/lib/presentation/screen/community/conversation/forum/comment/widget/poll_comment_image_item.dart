import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';

import '../../../../../../../utils/constant/app_fonts.dart';
import '../../../../../../../utils/localizations_util.dart';
import '../../../../../../app_router.dart';
import '../../../../../../common_widgets/sc_image_view.dart';
import '../../../../../base/base_widget.dart';

class PollCommentImageWidget extends StatelessWidget {
  final double width;
  final double height;
  final String? description;
  final List<ImageModel>? images;

  const PollCommentImageWidget(
      this.width, this.height, this.description, this.images,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      return images!.first.image!.isNotEmpty
          ? Container(
              margin: (description ?? "").isNotEmpty
                  ? EdgeInsets.only(top: 10.0)
                  : EdgeInsets.only(top: 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: GestureDetector(
                    child: CachedImageWidget(
                      cacheKey: avatarHomeKey,
                      imgUrl: images?.first.imageThumb ?? "",
                      width: width,
                      height: height,
                    ),
                    onTap: () {
                      List<String> _imgs = [];
                      images?.forEach(
                          (element) => _imgs.add(element.image ?? ""));
                      AppRouter.pushDialog(
                        context,
                        AppRouter.imageViewPage,
                        ImageViewPageArgument(images: _imgs),
                      );
                    },
                  ),
                ),
              ),
            )
          : const SizedBox.shrink();
    } catch (e) {
      print(e.toString());
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Text(
          LocalizationsUtil.of(context).translate("feedback_msg_error"),
          textAlign: TextAlign.center,
          // style: AppFonts.regular.copyWith(
          //   color: Color(0xff808080),
          // ),
          style: AppFonts.regular14.copyWith(
            color: Color(
              0xff808080,
            ),
          ),
        ),
      );
    }
  }
}
