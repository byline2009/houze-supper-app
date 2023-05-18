import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/sc_image_view.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';

import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/widget_row.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/widget_section_title.dart';
import 'package:houze_super/utils/index.dart';

enum TicketStatus { todo, in_progress, complete }

class WidgetIssueProgress extends StatelessWidget {
  final TicketDetailModel ticket;
  WidgetIssueProgress({required this.ticket});

  @override
  Widget build(BuildContext context) {
    Color _getStatusColor(TicketDetailModel ticket, int status) {
      return ticket.status == status ? AppColor.purple_7a1dff : AppColor.black;
    }

    return Column(
      children: <Widget>[
        WidgetSectionTitle(title: 'progress'),
        BaseWidget.makeContentWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              WidgetRow(
                label: 'request_received_with_colon',
                value: DateUtil.format(
                    "dd/MM/yyyy - HH:mm", ticket.assignTime ?? ""),
                color: _getStatusColor(
                  ticket,
                  TicketStatus.todo.index,
                ),
              ),
              WidgetRow(
                label: 'in_progress_with_colon',
                value:
                    DateUtil.format("dd/MM/yyyy - HH:mm", ticket.doingAt ?? ""),
                color: _getStatusColor(
                  ticket,
                  TicketStatus.in_progress.index,
                ),
              ),
              WidgetRow(
                label: 'completed_with_colon',
                value: DateUtil.format(
                    "dd/MM/yyyy - HH:mm", ticket.completedAt ?? ""),
                color: _getStatusColor(
                  ticket,
                  TicketStatus.complete.index,
                ),
              ),
              SizedBox(height: 19),
              if (ticket.note != null)
                BaseWidget.containerRounder(Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    width: double.infinity,
                    child: Text(
                      ticket.note ?? "",
                      textAlign: TextAlign.justify,
                      style: AppFonts.medium14,
                    ))),
              SizedBox(
                height: ticket.confirmImages!.length == 0 ? 0 : 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: ticket.confirmImages!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10, top: 20),
                      child: SizedBox(
                        height: ticket.confirmImages!.length == 0 ? 0 : 100,
                        width: ticket.confirmImages!.length == 0 ? 0 : 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(
                            clipBehavior: Clip.hardEdge,
                            children: <Widget>[
                              GestureDetector(
                                child: CachedImageWidget(
                                  imgUrl: ticket.confirmImages![index]["url"],
                                  height: double.infinity,
                                  width: double.infinity,
                                  cacheKey: ticket.confirmImages![index]['id'],
                                ),
                                onTap: () {
                                  List<String> _imgs = [];

                                  ticket.confirmImages!.forEach(
                                      (element) => _imgs.add(element["url"]));

                                  AppRouter.pushDialog(
                                    context,
                                    AppRouter.imageViewPage,
                                    ImageViewPageArgument(
                                        images: _imgs, initImg: index),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
