import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/sell/list/widget_create_date_seemore_bottom.dart';

/*Annoucement item detail*/
class WidgetAnnouncementItem extends StatelessWidget {
  final FeedMessageModel data;
  const WidgetAnnouncementItem({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, String> options = {};

    for (var j = 0; j < data.options!.length; ++j) {
      final f = data.options![j];
      options[f.key] = f.value;
    }
    return DecoratedBox(
      key: Key(data.id!),
      decoration: BaseWidget.dividerBottom(
        height: 1,
        color: AppColor.gray_dcdcdc,
      ),
      child: SizedBox(
        height: MailboxStyle.heightItem,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildHeader(context, options),
              const SizedBox(height: 10),
              _buildDescription(context, options),
              const SizedBox(height: 10),
              CreateDateSeemoreBottom(
                created: data.createdAt.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(
    BuildContext context,
    Map<String, String> options,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.fields!.map(
        (f) {
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 90 / 100,
              ),
              child: Text(f.value.replaceAll("&nbsp;", " "),
                  overflow: TextOverflow.ellipsis,
                  maxLines: options.containsKey("max_line")
                      ? int.parse(options["max_line"]!)
                      : 1,
                  softWrap: false,
                  style: data.isRead!
                      ? AppFont.REGULAR_GRAY_838383_13
                      : AppFont.SEMIBOLD_BLACK_13),
            ),
          );
        },
      ).toList(),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, String> options) {
    String img = "assets/svg/feed/ic_${data.type!.split('_2').first}.svg";
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                img,
                height: 40.0,
                width: 40.0,
              ),
            ),
            options['tags'] != "" && options['tags'] == AppStrings.important
                ? Positioned(
                    child: SvgPicture.asset(AppVectors.ic_stars_circle),
                    right: 0,
                    bottom: -2)
                : Center()
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            LocalizationsUtil.of(context).translateReplace('notification_title',
                data.title!), //'Thông báo về lịch tập PCCC toà ABCDEFGH',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: data.isRead! ? AppFonts.regular15 : AppFont.BOLD_BLACK_15,
          ),
        ),
      ],
    );
  }
}
