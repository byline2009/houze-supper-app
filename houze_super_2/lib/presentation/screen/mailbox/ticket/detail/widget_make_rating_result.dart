import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/login/widget_title.dart';
import 'package:houze_super/utils/index.dart';

class MakeRatingResult extends StatelessWidget {
  final TicketDetailModel? ticket;
  MakeRatingResult({this.ticket});

  @override
  Widget build(BuildContext context) {
    return BaseWidget.makeContentWrapper(
        child: Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TitleWidget(ticket!.getTitleRating())),
        RatingBar(
          initialRating: ticket!.rating!.rating!.toDouble(),
          direction: Axis.horizontal,
          ignoreGestures: true,
          itemPadding: const EdgeInsets.symmetric(horizontal: 10.0),
          allowHalfRating: false,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: SvgPicture.asset(AppVectors.ic_star),
            empty: SvgPicture.asset(AppVectors.ic_star_unrate),
            half: SvgPicture.asset(AppVectors.ic_star_unrate),
          ),
          onRatingUpdate: (double value) {},
        )
      ],
    ));
  }
}
