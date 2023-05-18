import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/card_horizontal_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/widget_floating_button.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/parking/sc_parking/widget_vertical_vehicle_card_list.dart';
import '../../base/route_aware_state.dart';
import 'bloc/parking_bloc.dart';
import 'bloc/parking_event.dart';
import 'sc_parking/widget_horizontal_vehicle_card_list.dart';
import 'sc_parking/widget_pick_apartment_box.dart';

class ParkingPage extends StatefulWidget {
  const ParkingPage();
  @override
  _ParkingPageState createState() => _ParkingPageState();
}

class _ParkingPageState extends RouteAwareState<ParkingPage> {
  final StreamController<ApartmentMessageModel> _streamController =
      StreamController();
  final DropdownWidgetController controller = DropdownWidgetController();

  @override
  void dispose() {
    _streamController.close();
    controller.controller.dispose();
    super.dispose();
  }

  final _vehicleBloc = ParkingVehicleBloc();
  final _bookingBloc = ParkingHistoryBookingBloc();
  final RefreshController refreshController = RefreshController();
  var id;
  void _onRefresh(String id) {
    HapticFeedback.heavyImpact();

    _vehicleBloc.add(
      ParkingVehicleGetList(params: {'apartment_id': id}),
    );

    _bookingBloc.add(
      ParkingHistoryBookingGetList(params: {'apartment_id': id}),
    );

    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: 'list_parking',
      child: Stack(children: [
        MultiBlocProvider(
            providers: <BlocProvider>[
              BlocProvider<ParkingVehicleBloc>(create: (_) => _vehicleBloc),
              BlocProvider<ParkingHistoryBookingBloc>(
                  create: (_) => _bookingBloc),
            ],
            child: Column(children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                child: PickApartmentBox(
                  controller: controller,
                  callbackResult: (value) {
                    if (value.id != null) {
                      _streamController.sink.add(value);
                    }
                    print(value.name!.toUpperCase());
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder<ApartmentMessageModel>(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return ParkingIsLoading();
                        default:
                          if (snapshot.hasError) {
                            return SomethingWentWrong();
                          }

                          this.id = snapshot.data!.id;

                          _vehicleBloc.add(ParkingVehicleGetList(
                              params: {'apartment_id': snapshot.data!.id}));
                          _bookingBloc.add(ParkingHistoryBookingGetList(
                              params: {'apartment_id': snapshot.data!.id}));

                          return SmartRefresher(
                            controller: refreshController,
                            onRefresh: () => _onRefresh(snapshot.data!.id!),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  HorizontalVehicleCardList(),
                                  const SizedBox(height: 40),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: VerticalRegisterVehicleList(
                                        apartment: snapshot.data!),
                                  )
                                ],
                              ),
                            ),
                          );
                      }
                    }),
              ),
            ])),
        Positioned(
            bottom: 35,
            right: 20,
            child: FloatingButtonWidget(callback: () {
              AppRouter.pushNoParamsWithCallback(
                  context, AppRouter.PARKING_REGISTER, _onCallBack);
            })),
      ]),
    );
  }

  _onCallBack(dynamic value) {
    //refresh paking list
    _onRefresh(this.id ?? "");
  }
}

class ParkingIsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 180,
            padding: const EdgeInsets.only(left: 20, top: 30),
            child: CardListHorizontalSkeleton(
                length: 3,
                config: SkeletonConfig(
                    isCircleAvatar: true,
                    isShowAvatar: true,
                    theme: SkeletonTheme.Light,
                    bottomLinesCount: 0,
                    radius: 0.0)),
          ),
          ListSkeleton(
            length: 3,
            shrinkWrap: true,
            config: SkeletonConfig(
                isCircleAvatar: true,
                isShowAvatar: true,
                bottomLinesCount: 2,
                theme: SkeletonTheme.Light,
                radius: 5),
          )
        ],
      ),
    );
  }
}
