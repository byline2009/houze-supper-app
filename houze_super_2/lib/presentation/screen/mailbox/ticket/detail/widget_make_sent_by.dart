import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/widget_section_title.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';
import 'package:houze_super/utils/index.dart';

class WidgetSentBy extends StatelessWidget {
  final TicketDetailModel ticket;
  WidgetSentBy({required this.ticket});

  @override
  Widget build(BuildContext context) {
    Assignee? rs = ticket.assignee;

    return Column(
      children: <Widget>[
        WidgetSectionTitle(title: 'assigned_staff'),
        Container(
          color: Colors.white,
          child: rs != null
              ? ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: () {
                    Utils.makePhoneCall(url: rs.phoneNumber.toString());
                    // Firebase analytics
                    GetIt.instance<FBAnalytics>().sendEventCallAssignedStaff(
                        userID: Storage.getUserID() ?? "");
                  },
                  leading: BaseWidget.avatar(
                    fullname: rs.fullname,
                    size: 40,
                    imageUrl: rs.imageThumb,
                  ),
                  title: Text(
                    rs.fullname,
                    style: TextStyle(
                        fontFamily: AppFont.font_family_display,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  subtitle: Text(
                    LocalizationsUtil.of(context).translate("support_staff"),
                    style: AppFonts.semibold13.copyWith(
                      color: Color(
                        0xff838383,
                      ),
                    ),
                  ),
                  trailing: SvgPicture.asset(AppVectors.ic_call))
              : Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    LocalizationsUtil.of(context).translate("not_assigned_yet"),
                    textAlign: TextAlign.left,
                    style: AppFonts.medium14,
                  ),
                ),
        ),
      ],
    );
  }
}
