import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/utils/index.dart';

import 'widget_section_title.dart';

class WidgetSentBy extends StatelessWidget {
  final TicketDetailModel ticket;
  const WidgetSentBy({@required this.ticket});

  @override
  Widget build(BuildContext context) {
    final Assignee rs = ticket.assignee;

    return Column(
      children: <Widget>[
        const WidgetSectionTitle(title: 'assigned_staff'),
        Container(
          color: Colors.white,
          child: rs != null
              ? ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  onTap: () {
                    if (rs.phoneNumber != null) {
                      Utils.makePhoneCall(
                          phone: rs.intlCode == 84
                              ? '0' + rs.phoneNumber.toString()
                              : ('+' +
                                  rs.intlCode.toString() +
                                  rs.phoneNumber.toString()));
                    }
                  },
                  leading: BaseWidget.avatar(
                    fullname: rs.fullname,
                    size: 40,
                    imageUrl: rs.imageThumb,
                  ),
                  title: Text(
                    rs.fullname,
                    style: TextStyle(
                        fontFamily: AppFonts.font_family_display,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                  subtitle: Text(
                    LocalizationsUtil.of(context).translate("support_staff"),
                    style: AppFonts.semibold13.copyWith(
                      color: Color(0xff838383),
                    ),
                  ),
                  trailing: rs?.phoneNumber != null
                      ? SvgPicture.asset(AppVectors.ic_call)
                      : SvgPicture.asset(
                          AppVectors.ic_call,
                          color: Colors.transparent,
                        ))
              : Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    LocalizationsUtil.of(context).translate("not_assigned_yet"),
                    textAlign: TextAlign.left,
                    style: AppFonts.medium14.copyWith(color: Colors.black),
                  ),
                ),
        ),
      ],
    );
  }
}
