import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/utils/index.dart';

class MakeRatingReview extends StatelessWidget {
  final TicketDetailModel ticket;
  const MakeRatingReview({
    this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return BaseWidget.containerBody(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BaseWidget.makeContentWrapper(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffd2d4d6),
                      offset: Offset(0, 0),
                      blurRadius: 10,
                    )
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SvgPicture.asset(AppVectors.ic_rating_medium),
                          const SizedBox(width: 15),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                      LocalizationsUtil.of(context)
                                          .translate('request_was_resolved'),
                                      style: AppFonts.bold15),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    LocalizationsUtil.of(context).translate(
                                        'please_review_and_rate_our_service_to_help_us_improve_the_quality'),
                                    style: AppFonts.semibold13.copyWith(
                                      color: const Color(0xff838383),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      WidgetButton.pink(
                        LocalizationsUtil.of(context)
                            .translate('rating_and_review'),
                        callback: () => AppRouter.pushDialog(
                            context, AppRouter.RATING_SERVICE_PAGE, ticket),
                      ),
                    ],
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
