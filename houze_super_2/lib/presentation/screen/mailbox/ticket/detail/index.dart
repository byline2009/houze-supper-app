import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/ticket/ticket_bloc.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/ticket/ticket_event.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/ticket/ticket_state.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

import '../../../../base/route_aware_state.dart';

//---SCREEN: Phản anh---//

class TicketScreenArguments {
  final String? refID;
  TicketScreenArguments({this.refID});
}

class TicketScreen extends StatefulWidget {
  final TicketScreenArguments args;
  TicketScreen({required this.args});

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends RouteAwareState<TicketScreen> {
  final _ticketBloc = TicketBloc();
  final progressToolkit = Progress.instanceCreateWithNormal();

  Widget _buildRating(TicketDetailModel model) {
    print(model);
    if (model.status == 2) {
      if (model.rating == null) {
        return MakeRatingReview(ticket: model);
      } else {
        return MakeRatingResult(ticket: model);
      }
    }

    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      HomeScaffold(
          title: 'request_0',
          child: SafeArea(
              child: GestureDetector(
            onTap: () {
              bool isKeyboardShowing =
                  MediaQuery.of(context).viewInsets.bottom > 0;
              if (isKeyboardShowing) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              }
            },
            child: CustomScrollView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                        color: Colors.white,
                        child: BlocProvider<TicketBloc>(
                          create: (_) => _ticketBloc,
                          child: BlocBuilder<TicketBloc, TicketState>(builder:
                              (BuildContext context, TicketState ticketState) {
                            if (ticketState is TicketInitial) {
                              _ticketBloc.add(
                                  EventGetTicketByID(id: widget.args.refID!));
                            }
                            if (ticketState is TicketFailure) {
                              if (ticketState.error is NoDataException)
                                return Padding(
                                  child: SomethingWentWrong(true),
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.3),
                                );
                              else
                                return Padding(
                                  child: SomethingWentWrong(),
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.3),
                                );
                            }

                            if (ticketState is GetTicketByIDSuccessfull) {
                              var ticketDetailModel = ticketState.result;

                              return GestureDetector(
                                  onTap: () {
                                    // Click outside and close Keyboard.
                                    bool isKeyboardShowing =
                                        MediaQuery.of(context)
                                                .viewInsets
                                                .bottom >
                                            0;
                                    if (isKeyboardShowing) {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                    }
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      _buildRating(ticketDetailModel!),
                                      TicketInfoSection(
                                          ticket: ticketDetailModel),
                                      WidgetLocation(ticket: ticketDetailModel),
                                      WidgetIssueProgress(
                                          ticket: ticketDetailModel),
                                      WidgetSentBy(ticket: ticketDetailModel),
                                      WidgetFeedback(
                                          ticket: ticketDetailModel,
                                          progressToolkit: progressToolkit)
                                    ],
                                  ));
                            }

                            return Padding(
                                padding: const EdgeInsets.all(20),
                                child: ListSkeleton(
                                  length: 3,
                                  shrinkWrap: true,
                                  config: SkeletonConfig(
                                    bottomLinesCount: 3,
                                    isCircleAvatar: false,
                                    isShowAvatar: false,
                                    theme: SkeletonTheme.Light,
                                  ),
                                ));
                          }),
                        ))
                  ]))
                ]),
          ))),
      progressToolkit
    ]);
  }
}
