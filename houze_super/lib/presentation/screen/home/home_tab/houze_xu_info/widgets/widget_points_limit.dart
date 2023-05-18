import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/string_util.dart';

import 'package:houze_super/middle/model/houze_point/point_limit_model.dart';

const ICON_SIZE = 36.0;

class FilterActionType {
  String type;
  String content;
  FilterActionType({this.type, this.content});
}

class WidgetPointsLimit extends StatelessWidget {
  final List<PointLimitModel> pointLimit;

  WidgetPointsLimit({this.pointLimit});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        height: constraints.maxHeight,
        color: Colors.white,
        padding: const EdgeInsets.only(top: 5),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                color: Color(0xfff5f5f5),
                child: Text(
                  LocalizationsUtil.of(context).translate(
                      'in_order_to_limit_spamming_with_multiple_activities_houze_xu_will_have_a_maximum_receive_limit_for_each_activity_as_follows'),
                  style: AppFonts.medium14.copyWith(
                    letterSpacing: 0.14,
                    color: Color(0xff808080),
                  ),
                )),
            if (pointLimit.length != 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 20),
                    itemCount: pointLimit.length,
                    itemBuilder: (BuildContext context, int index) {
                      PointLimitModel pointLimitItem = pointLimit[index];
                      var title = '';
                      var imagePath = '';

                      switch (pointLimitItem.action) {
                        case 'fee_bank_transfer_award':
                          imagePath = AppVectors.icBank;
                          title = 'bank_transfer';
                          break;
                        case 'ticket_rating_award':
                          imagePath = AppVectors.ic_rating_medium;
                          title = 'start_review';
                          break;
                        case 'ticket_created_award':
                          imagePath = AppVectors.icIssue;
                          title = 'send_a_request';
                          break;
                        default:
                      }
                      return houzeXuItem(context,
                          imagePath: imagePath,
                          title: title,
                          pointLimitItem: pointLimitItem);
                    }),
              ),
          ],
        )),
      );
    });
  }

  Widget houzeXuItem(BuildContext context,
      {PointLimitModel pointLimitItem, String title, String imagePath}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 42.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SvgPicture.asset(
                  imagePath,
                  width: ICON_SIZE,
                  height: ICON_SIZE,
                ),
              ),
              Text(
                LocalizationsUtil.of(context).translate(title),
                style: AppFonts.bold15.copyWith(letterSpacing: 0.14),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          itemLimit(context, pointLimitItem.dateLimit, 'date_limit'),
          const SizedBox(
            height: 10,
          ),
          itemLimit(context, pointLimitItem.weekLimit, 'week_limit'),
          const SizedBox(
            height: 10,
          ),
          itemLimit(context, pointLimitItem.monthLimit, 'month_limit'),
          const SizedBox(
            height: 10,
          ),
          itemLimit(context, pointLimitItem.yearLimit, 'year_limit'),
        ],
      ),
    );
  }

  Widget itemLimit(BuildContext context, int amount, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocalizationsUtil.of(context).translate(title) + ':',
          style: AppFonts.medium.copyWith(color: Color(0xff808080)),
        ),
        Row(children: [
          Text(
            ' ${StringUtil.numberFormat(amount)}',
            style: AppFonts.semibold13
                .copyWith(color: Color(0xffd68100))
                .copyWith(fontSize: 15),
          ),
          const SizedBox(
            width: 5.0,
          ),
          SvgPicture.asset(AppVectors.icPoint),
        ]),
      ],
    );
  }
}
