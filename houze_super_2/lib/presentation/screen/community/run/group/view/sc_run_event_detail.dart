//Old
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/app/common/app_event_bloc.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/index.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_stretchy.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/index.dart';

import '../index.dart';

class RunEventDetailScreenArgument {
  final EventModel eventModel;

  const RunEventDetailScreenArgument({
    required this.eventModel,
  });
}

class RunEventDetailScreen extends StatefulWidget {
  final RunEventDetailScreenArgument argument;
  const RunEventDetailScreen({
    required this.argument,
  });

  @override
  _RunEventDetailScreenState createState() => new _RunEventDetailScreenState();
}

class _RunEventDetailScreenState extends RouteAwareState<RunEventDetailScreen> {
  late EventModel _eventModel;
  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();
  late ScrollController _controller;
  late StreamSubscription<BlocEvent> _subChallengeUpdateDetailByID;

  double _headerSize = 0.0;
  late RunningState _currentRunningState;
  late GroupBloc _groupBloc;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _eventModel = widget.argument.eventModel;
    _currentRunningState = _eventModel.runningState;
    _groupBloc = BlocProvider.of<GroupBloc>(context);
    if ((_eventModel.id!).isNotEmpty) {
      _groupBloc.add(
        EventLoadGroupDetail(
          eventID: _eventModel.id!,
        ),
      );
    }

    _subChallengeUpdateDetailByID = AppEventBloc().listenEvent(
      eventName: EventName.challengeUpdateDetail,
      handler: _handlechallengeUpdateDetail,
    );
  }

  void _handlechallengeUpdateDetail(BlocEvent evt) {
    final value = evt.value;

    if (mounted && value is String && value == _eventModel.id) {
      _groupBloc.add(
        EventLoadGroupDetail(
          eventID: value,
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_currentRunningState != _eventModel.runningState) {
      AppEventBloc().emitEvent(
        BlocEvent(
          EventName.challengeUpdateItem,
          _eventModel,
        ),
      );
    }
    _subChallengeUpdateDetailByID.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddingSys = MediaQuery.of(context).padding;
    final sizeSys = MediaQuery.of(context).size;
    _headerSize = (sizeSys.height - paddingSys.top - paddingSys.bottom) / 4;

    return Stack(
      children: [
        CustomRefreshIndicator(
          leadingGlowVisible: false,
          trailingGlowVisible: false,
          indicatorBuilder:
              (BuildContext context, CustomRefreshIndicatorData d) {
            if (d.isDraging) {
              return Positioned(
                top: 120,
                right: 0,
                left: 0,
                child: Center(
                  child: DraggingActivityIndicator(
                    percentageComplete: d.value,
                    radius: 12,
                  ),
                ),
              );
            }

            if (d.isArmed) {
              return Positioned(
                top: 120,
                right: 0,
                left: 0,
                child: CupertinoActivityIndicator(radius: 12),
              );
            }

            return const SizedBox.shrink();
          },
          onRefresh: () async {
            _groupBloc.add(
              EventLoadGroupDetail(
                eventID: _eventModel.id!,
              ),
            );
          },
          child: Builder(builder: (
            context,
          ) {
            return Scaffold(
              body: BlocBuilder<GroupBloc, GroupState>(
                  builder: (BuildContext context, GroupState state) {
                if (state is StateLoadEventDetailFailure) {
                  return const SomethingWentWrong();
                }

                if (state is StateLoadEventDetailSuccessful) {
                  _eventModel = state.eventModel!;

                  final List<GroupModel> _groups = state.groups!.toList();
                  final List<Widget> _containers = [
                    HeaderEventInformation(
                      item: state.eventModel!,
                    ),
                    WidgetGroupDetailSection(
                      groups: _groups,
                      eventModel: state.eventModel!,
                      progressToolkit: progressToolkit,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ];

                  return CustomScrollView(
                    controller: _controller,
                    slivers: [
                      SliverAppBar(
                        leading: WidgetButton.backCircleButton(
                          context,
                          callback: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        pinned: true,
                        stretch: true,
                        expandedHeight: _headerSize,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: false,
                          titlePadding: const EdgeInsets.only(
                            bottom: 10,
                            left: 20,
                          ),
                          title: SizedBox(
                            child: RunnningStateCategory(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              state: _eventModel.runningState,
                              fontSize: 10,
                            ),
                          ),
                          stretchModes: const <StretchMode>[
                            StretchMode.zoomBackground,
                            StretchMode.fadeTitle,
                          ],
                          background: Image.network(
                            _eventModel.imageThumb!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _containers[index],
                          childCount: _containers.length,
                        ),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    ParkingCardSkeleton(
                      width: double.infinity,
                      height: _headerSize,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListSkeleton(
                        length: 2,
                        shrinkWrap: true,
                        config: SkeletonConfig(
                          isCircleAvatar: false,
                          isShowAvatar: false,
                        ),
                      ),
                    )
                  ],
                );
              }),
            );
          }),
        ),
        progressToolkit,
      ],
    );
  }

  Widget backgroundCover() {
    return Stack(
      children: [
        SizedBox(
          child: ClipRect(
            clipper: HeaderClipper(_headerSize),
            child: CachedImageWidget(
              cacheKey: _eventModel.imageThumb!,
              imgUrl: _eventModel.imageThumb!,
            ),
          ),
          height: _headerSize,
          width: ScreenUtil.defaultSize.width,
        ),
        Positioned(
          left: 20,
          bottom: 10,
          child: RunnningStateCategory(
            state: _eventModel.runningState,
            fontSize: 12,
            padding: EdgeInsets.zero,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 15.0,
          child: WidgetButton.backCircleButton(
            context,
            callback: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
