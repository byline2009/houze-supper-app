import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/agent_model.dart';
import 'package:houze_super/presentation/screen/sell/list/widget_create_date_seemore_bottom.dart';
import 'package:intl/intl.dart';

import '../../../index.dart';

class WidgetSellItem extends StatelessWidget {
  final SellModel item;
  const WidgetSellItem({required this.item});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRouter.push(context, AppRouter.SELL_DETAIL, item),
      child: Container(
        color: Colors.white,
        key: Key(item.id!),
        padding: const EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(icon),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    LocalizationsUtil.of(context).translate(title) +
                        ' ' +
                        (item.apartmentName ?? ''),
                    style: AppFonts.regular15,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: status(context),
                )
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              LocalizationsUtil.of(context).translate(subtitle) +
                  ' ${NumberFormat('#,###').format(int.parse(item.sellPrice!))} VND.',
              style: AppFonts.regular13.copyWith(
                color: Color(
                  0xff808080,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            CreateDateSeemoreBottom(created: item.created.toString()),
          ],
        ),
      ),
    );
  }

  String get icon => item.type == 0 ? AppVectors.icSell : AppVectors.icRent;

  String get title => item.type == 0 ? 'sell_apartment' : 'lease_apartment';
  String get subtitle => item.type == 0
      ? 'desired_selling_price_with_colon'
      : 'the_proposed_leasing_price_with_colon';
  Color get color =>
      item.statusPosted != 0 ? Color(0xFFf5f5f5) : Color(0xFF38d6ac);

  Center status(BuildContext context) => item.statusPosted != 0
      ? Center(
          child: Text(LocalizationsUtil.of(context).translate('offline'),
              style: AppFonts.medium14),
        )
      : Center(
          child: Text(
            LocalizationsUtil.of(context).translate('online'),
            style: AppFonts.medium14.copyWith(color: Colors.white),
          ),
        );
}
