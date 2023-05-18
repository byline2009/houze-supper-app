import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/presentation/common_widgets/expansion_card/src/card.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/utils/settings/fee.dart';

import 'extended/widget_fee_list.dart';

class FeeListOverviewScreen extends StatefulWidget {
  final List<FeeMessageModel> fees;
  final String buildingId;
  final String apartmentId;

  FeeListOverviewScreen({
    @required this.fees,
    @required this.buildingId,
    @required this.apartmentId,
  });

  @override
  State<StatefulWidget> createState() => _FeeListOverviewState();
}

class _FeeListOverviewState extends State<FeeListOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.fees.length,
      itemBuilder: (BuildContext context, int index) {
        var feeInfo = FeeSettings.feeTypes
            .firstWhere((item) => item.type == widget.fees[index].type);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: BaseWidget.containerRounderRegular(
            ExpansionCard(
              toggleBuilder: (_iconTurns, onTap) {
                return GestureDetector(
                  onTap: () {
                    onTap();
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: RotationTransition(
                      turns: _iconTurns,
                      child: Icon(
                        Icons.expand_more,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
              leading:
                  SvgPicture.asset("assets/svg/fee/ic-fee-${feeInfo.type}.svg"),
              title: Container(
                  child: Text(
                      LocalizationsUtil.of(context).translate(feeInfo.title),
                      style: AppFonts.medium14.copyWith(color: Colors.black))),
              subtitle: Text(
                  "đ ${StringUtil.numberFormat(widget.fees[index].total)}",
                  style: widget.fees[index].total != 0
                      ? AppFonts.medium13.copyWith(color: Color(0xff6001d2))
                      : AppFonts.semibold13.copyWith(color: Color(0xff808080))),
              children: [
                HistoryFeeList(
                  fee: feeInfo,
                  buildingId: widget.buildingId,
                  apartmentId: widget.apartmentId,
                ),
              ], //
            ),
          ),
        );
      },
    );
  }
}
