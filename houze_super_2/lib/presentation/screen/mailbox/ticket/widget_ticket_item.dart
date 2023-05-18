import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';

class WidgetTicketItem extends StatelessWidget {
  final int status;
  final FeedMessageModel model;

  const WidgetTicketItem({required this.status, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(model.id!),
      height: MailboxStyle.heightItem,
      decoration:
          BaseWidget.dividerBottom(height: 1, color: AppColor.gray_dcdcdc),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderItem(
            model: model,
            status: status,
          ),
          SizedBox(height: 10),
          WidgetDescription(model),
          SizedBox(height: 10),
          WidgetBottom(model: model)
        ],
      ),
    );
  }

  onTabItem(BuildContext context) {
    // if (model.isRead == false) {
    //   FeedBloc().add(FeedRead(id: model.id));
    // }
    AppRouter.push(context, AppRouter.TICKET_DETAIL,
        TicketScreenArguments(refID: model.refID));
  }
}

class WidgetDescription extends StatelessWidget {
  final FeedMessageModel model;
  const WidgetDescription(this.model);

  @override
  Widget build(BuildContext context) {
    Map<String, String> options = {};

    for (var j = 0; j < model.options!.length; ++j) {
      final f = model.options![j];
      options[f.key] = f.value;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: model.fields!.map((f) {
        return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 90 / 100,
                ),
                child: Text(
                  // LocalizationsUtil.of(context).translate("lbl_" + f.key) +
                  f.value.replaceAll("&nbsp;", " "),
                  overflow: TextOverflow.ellipsis,
                  maxLines: options.containsKey("max_line")
                      ? int.parse(options["max_line"]!)
                      : 1,
                  softWrap: false,
                  style: model.isRead!
                      ? AppFont.REGULAR_GRAY_838383_13
                      : AppFonts.semibold13.copyWith(
                          color: Color(
                            0xff838383,
                          ),
                        ),
                )));
      }).toList(),
    );
  }
}

class WidgetBottom extends StatelessWidget {
  final FeedMessageModel? model;

  const WidgetBottom({this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            DateUtil.format("dd/MM/yyyy - HH:mm", model!.createdAt!),
            style: model!.isRead!
                ? AppFont.SEMIBOLD_PURPLE_6001d2_13
                : AppFont.BOLD_PURPLE_6001d2.copyWith(fontSize: 13),
          ),
        ),
        Text(
          LocalizationsUtil.of(context).translate('more'),
          style: model!.isRead!
              ? AppFont.SEMIBOLD_PURPLE_6001d2_13
              : AppFont.BOLD_PURPLE_6001d2.copyWith(fontSize: 13),
        ),
        SizedBox(width: 10),
        SvgPicture.asset(AppVectors.ic_arrow_right),
      ],
    );
  }
}

class HeaderItem extends StatelessWidget {
  final int? status;
  final FeedMessageModel? model;

  const HeaderItem({this.model, this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SvgPicture.asset(
          getIconByStatus(),
        ),
        SizedBox(width: 10),
        Flexible(
          child: Text(
            model?.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: model!.isRead! ? AppFonts.regular15 : AppFont.BOLD_BLACK_15,
          ),
        ),
      ],
    );
  }

  String getIconByStatus() {
    switch (status) {
      case 0:
        return AppVectors.ic_sendissue;

      case 1:
        return AppVectors.ic_sendissue_process;

      case 2:
        return AppVectors.ic_sendissue_done;
    }
    return '';
  }
}
