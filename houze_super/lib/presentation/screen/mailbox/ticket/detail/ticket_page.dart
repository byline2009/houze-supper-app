import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/progresshub.dart';

import 'bloc/ticket/ticket_event.dart';
import 'bloc/ticket/ticket_state.dart';
import 'bloc/ticket/ticket_bloc.dart';
import 'widgets/widgets.dart';

class TicketScreenArguments {
  final String refID;
  const TicketScreenArguments({
    this.refID,
  });
}

class TicketPage extends StatefulWidget {
  final TicketScreenArguments args;

  const TicketPage({
    Key key,
    @required this.args,
  }) : super(key: key);

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  ProgressHUD progressToolkit;
  TicketBloc _ticketBloc;

  @override
  void initState() {
    super.initState();
    progressToolkit = Progress.instanceCreateWithNormal();
    _ticketBloc = TicketBloc();
  }

  @override
  void dispose() {
    if (_ticketBloc != null) _ticketBloc.close();
    if (progressToolkit != null) progressToolkit.state.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        HomeScaffold(
          title: 'request_0',
          child: SafeArea(
            child: CustomScrollView(
              key: PageStorageKey<String>('TicketPage'),
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                BlocProvider<TicketBloc>(
                  create: (_) => _ticketBloc,
                  child: SliverToBoxAdapter(
                    child: BlocBuilder<TicketBloc, TicketState>(
                      builder: (BuildContext context, TicketState ticketState) {
                        if (ticketState is TicketInitial) {
                          _ticketBloc.add(
                            EventGetTicketByID(
                              id: widget.args.refID,
                            ),
                          );
                        }

                        if (ticketState is TicketFailure) {
                          if (ticketState.error is NoDataException)
                            return SomethingWentWrong(true);
                          else
                            return SomethingWentWrong();
                        }

                        if (ticketState is GetTicketByIDSuccessfull) {
                          final TicketDetailModel _ticketDetailModel =
                              ticketState.result;
                          return GestureDetector(
                            onTap: () {
                              bool isKeyboardShowing =
                                  MediaQuery.of(context).viewInsets.bottom > 0;
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
                                _buildRating(_ticketDetailModel),
                                TicketInfoSection(ticket: _ticketDetailModel),
                                WidgetLocation(ticket: _ticketDetailModel),
                                WidgetIssueProgress(ticket: _ticketDetailModel),
                                WidgetSentBy(ticket: _ticketDetailModel),
                                WidgetFeedback(
                                  ticket: _ticketDetailModel,
                                  progressToolkit: progressToolkit,
                                )
                              ],
                            ),
                          );
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
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        progressToolkit,
      ],
    );
  }

  Widget _buildRating(TicketDetailModel model) {
    if (model.status == 2) {
      if (model.rating == null) {
        return MakeRatingReview(ticket: model);
      } else {
        return MakeRatingResult(ticket: model);
      }
    }

    return const SizedBox.shrink();
  }
}
