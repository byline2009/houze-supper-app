import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/widgets/widget_section_title.dart';
import 'package:houze_super/utils/constants/constants.dart';

class WidgetStaffHeader extends StatelessWidget {
  final TicketDetailModel ticket;
  const WidgetStaffHeader({@required this.ticket});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        WidgetSectionTitle(
          title: 'assigned_staff',
          trailing: Text(
            LocalizationsUtil.of(context).translate('request_0') +
                    ' ' +
                    ticket?.codeIssue ??
                '',
            style: AppFonts.medium.copyWith(color: Color(0xff808080)),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: ticket.assignee != null
              ? Row(
                  children: <Widget>[
                    BaseWidget.avatar(
                        fullname: ticket.assignee.fullname,
                        size: 40,
                        imageUrl: ticket.assignee.imageThumb),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ticket.assignee.fullname,
                          style:
                              AppFonts.medium14.copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          LocalizationsUtil.of(context)
                              .translate('support_staff'),
                          style: AppFonts.regular12,
                        )
                      ],
                    )
                  ],
                )
              // : Padding(
              //     padding: const EdgeInsets.only(top: 10, bottom: 10),
              //     child: Text(
              //       LocalizationsUtil.of(context).translate("not_assigned_yet"),
              //       textAlign: TextAlign.left,
              //       style: AppFonts.medium14.copyWith(color: Colors.black),
              //     ),
              //   ),
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
