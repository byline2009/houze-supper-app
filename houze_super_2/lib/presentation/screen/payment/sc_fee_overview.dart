import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/model/fee/fee_model.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/index.dart';
import 'package:houze_super/presentation/common_widgets/dropdown_box_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/payment/sc_fee_checkout.dart';

import 'blocs/fee/index.dart';
import 'order/fee/sc_fee_list_overview.dart';

class FeeOverviewScreenArgument {
  final String apartmentId;
  final Function callback;
  final String typeService;
  final FeeGroupByApartments feeGroupByApartments;

  FeeOverviewScreenArgument({
    required this.apartmentId,
    required this.feeGroupByApartments,
    required this.callback,
    required this.typeService,
  });
}

class FeeOverviewScreen extends StatefulWidget {
  final FeeOverviewScreenArgument args;
  FeeOverviewScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeeOverviewScreenState();
}

class _FeeOverviewScreenState extends RouteAwareState<FeeOverviewScreen>
    with
        AutomaticKeepAliveClientMixin<FeeOverviewScreen>,
        TickerProviderStateMixin {
  final _refreshController = RefreshController();
  final StreamController<List<FeeMessageModel>> _feesController =
      StreamController<List<FeeMessageModel>>.broadcast();
  // late ApartmentMessageModel _apartment;
  late String _currentApartmentID;
  late double totalAllBuilding;
  @override
  void initState() {
    super.initState();
    _currentApartmentID = widget.args.apartmentId;

    _getApartmentList();
  }

  Future<dynamic> _getApartmentList() async {
    return await context.read<ApartmentRepository>().getApartments(
          buildingId: widget.args.feeGroupByApartments.buildingId!,
        );
  }

  @override
  void dispose() {
    _feesController.close();
    _refreshController.dispose();
    super.dispose();
  }

  late List<ApartmentMessageModel> _apartmentList = [];
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BaseScaffold(
      title: widget.args.feeGroupByApartments.buildingName!,
      child: FutureBuilder<dynamic>(
        future: _getApartmentList(),
        builder: (context, snapshot) {
          _apartmentList.clear();
          if (snapshot.data != null && snapshot.data!.length > 0) {
            _apartmentList.addAll(snapshot.data ?? []);
            ApartmentMessageModel _currentApartment = _apartmentList.firstWhere(
              (element) => element.id == _currentApartmentID,
            );
            context.read<FeeBloc>().add(
                  FeeLoadList(
                    buildingID: _currentApartment.buildingId!,
                    apartmentID: _currentApartment.id!,
                  ),
                );
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.16),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: DropdownBox(
                          title: _convertTitle(),
                          datasource: _apartmentList,
                          initialIndex:
                              _apartmentList.indexOf(_currentApartment),
                          callback: (newIndex) {
                            _currentApartment = _apartmentList[newIndex];
                            _currentApartmentID = _apartmentList[newIndex].id!;
                            context.read<FeeBloc>().add(
                                  FeeLoadList(
                                    buildingID: _currentApartment.buildingId!,
                                    apartmentID: _currentApartmentID,
                                  ),
                                );
                          },
                        ),
                      ),
                      Flexible(
                        child: BlocBuilder<FeeBloc, FeeState>(
                          builder: (context, state) {
                            if (state is FeeLoadListSuccessful) {
                              _feesController.sink.add(state.result);
                              return CustomRefreshIndicator(
                                leadingGlowVisible: false,
                                trailingGlowVisible: false,
                                indicatorBuilder: (BuildContext context,
                                    CustomRefreshIndicatorData d) {
                                  if (d.isDraging) {
                                    return Positioned(
                                      top: 20,
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
                                    return const Positioned(
                                      top: 20,
                                      right: 0,
                                      left: 0,
                                      child: CupertinoActivityIndicator(
                                        radius: 12,
                                      ),
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                                onRefresh: () async {
                                  await Future.delayed(Duration.zero, () {
                                    context.read<FeeBloc>().add(
                                          FeeLoadList(
                                            buildingID:
                                                _currentApartment.buildingId!,
                                            apartmentID: _currentApartment.id!,
                                          ),
                                        );
                                  });
                                },
                                child: FeeListOverviewScreen(
                                  apartmentId: _currentApartmentID,
                                  buildingId: _currentApartment.buildingId!,
                                  fees: state.result,
                                ),
                              );
                            }
                            if (state is FeeFailure) {
                              return Align(
                                child: SomethingWentWrong(true),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: ListSkeleton(
                                length: 6,
                                shrinkWrap: true,
                                config: SkeletonConfig(
                                  isCircleAvatar: true,
                                  isShowAvatar: true,
                                  theme: SkeletonTheme.Light,
                                  bottomLinesCount: 0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.pink,
                    child: StreamBuilder<List<FeeMessageModel>>(
                        initialData: [],
                        stream: _feesController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            double _total = 0;
                            snapshot.data!.forEach(
                                (e) => _total += (e.total?.toDouble() ?? 0));
                            return bottomButtonPayment(_total, snapshot.data!);
                          }
                          return SizedBox.shrink();
                        }),
                  ),
                ),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: ListSkeleton(
              length: 6,
              shrinkWrap: true,
              config: SkeletonConfig(
                isCircleAvatar: true,
                isShowAvatar: true,
                theme: SkeletonTheme.Light,
                bottomLinesCount: 0,
              ),
            ),
          );
        },
      ),
    );
    // return BaseScaffold(
    //   title: widget
    //       .args.feeGroupByApartments.buildingName!, //widget.args.title ?? '',
    //   child: MultiBlocProvider(
    //     providers: <BlocProvider>[
    //       BlocProvider<ApartmentBloc>(create: (_) => apartmentBloc),
    //       BlocProvider<FeeBloc>(create: (_) => feeBloc),
    //     ],
    //     child: BlocBuilder<FeeBloc, FeeState>(
    //       builder: (_, FeeState feeState) {
    //         if (feeState is FeeInitial) _addEvent();

    //         if (feeState is FeeFailure) {
    //           if (feeState.error.error is NoDataException)
    //             return SomethingWentWrong(true);
    //           else
    //             return SomethingWentWrong();
    //         }

    //         if (feeState is FeeLoadListSuccessful) {
    //           fees
    //             ..clear()
    //             ..addAll(feeState.result);

    //           totalAllBuilding = feeBloc.financeModel.totalAllBuilding;

    //           return BlocBuilder<ApartmentBloc, List<ApartmentMessageModel>>(
    //             builder: (_, List<ApartmentMessageModel> apartments) {
    //               if (apartments.isNotEmpty) {
    //                 // if (_apartment.id == null) {
    //                 _apartment = apartments.firstWhere(
    //                   (e) => e.id == widget.args.apartmentId,
    //                 );
    //                 // }
    //                 ApartmentMessageModel _currentApartment =
    //                     apartments.firstWhere(
    //                         (element) => element.id == widget.args.apartmentId);
    //                 int _currentIndexApartment =
    //                     apartments.indexOf(_currentApartment);
    //                 return Column(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.symmetric(
    //                         vertical: 16.0,
    //                         horizontal: 20.0,
    //                       ),
    //                       child: DropdownBox(
    //                         title: _convertTitle(),
    //                         datasource: apartments,
    //                         initialIndex: _currentIndexApartment,
    //                         callback: (newIndex) {
    //                           _currentIndexApartment = newIndex;
    //                           _apartment = apartments[_currentIndexApartment];
    //                           feeBloc.add(
    //                             FeeLoadList(
    //                               buildingID: _apartment.buildingId!,
    //                               apartmentID: _apartment.id!,
    //                             ),
    //                           );
    //                         },
    //                       ),
    //                     ),
    //                     Flexible(
    //                       child: SmartRefresher(
    //                         controller: _refreshController,
    //                         header: MaterialClassicHeader(),
    //                         onRefresh: () {
    //                           onRefresh();
    //                         },
    //                         footer: CustomFooter(
    //                           builder: (BuildContext context, LoadStatus mode) {
    //                             return SizedBox(
    //                               height: 50.0,
    //                               child: Center(
    //                                 child: NoDataBottomLine(
    //                                   parentContext: context,
    //                                 ),
    //                               ),
    //                             );
    //                           },
    //                         ),
    //                         child: SingleChildScrollView(
    //                           child: FeeListOverviewScreen(
    //                               fees: fees,
    //                               apartmentId:
    //                                   _apartment.id ?? widget.args.apartmentId,
    //                               buildingId: _apartment.buildingId ??
    //                                   widget.args.feeGroupByApartments
    //                                       .buildingId! //widget.args.buildingId,
    //                               ),
    //                         ),
    //                       ),
    //                     ),
    //                     bottomButtonPayment(totalAllBuilding),
    //                   ],
    //                 );
    //               }

    //               return const Align(child: CupertinoActivityIndicator());
    //             },
    //           );
    //         }

    //         return CardListSkeleton(
    //           shrinkWrap: true,
    //           length: 5,
    //           config: SkeletonConfig(
    //             theme: SkeletonTheme.Light,
    //             isShowAvatar: true,
    //             isCircleAvatar: true,
    //             bottomLinesCount: 0,
    //             radius: 0.0,
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );
  }

  String _convertTitle() {
    switch (widget.args.typeService) {
      case "apartment":
        return "you_are_viewing_this_apartment's_invoice_with_colon";
      case "room":
        return "you_are_viewing_this_room's_invoice_with_colon";
      case "house_number":
        return "you_are_viewing_this_house's_invoice_with_colon";
    }
    return '';
  }

  Future<BuildingMessageModel> getCurrentBuilding() async {
    final builings = await Sqflite.getBuildingList();
    final currentBuilding = builings.firstWhere((element) =>
        element.id == (widget.args.feeGroupByApartments.buildingId!));
    return currentBuilding;
  }

  Widget bottomButtonPayment(
    double totalAllBuilding,
    List<FeeMessageModel> fees,
  ) {
    // final builings =await Sqflite.getBuildingList();
    // builings
    // Future<BuildingMessageModel> buildingModel =
    //     Sqflite.getBuildingWithId(widget.args.feeGroupByApartments.buildingId!);
    return BaseWidget.containerBodyTopShadow(
      SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(left: 20, right: 20, bottom: 20.0, top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      LocalizationsUtil.of(context)
                          .translate("need_to_pay_with_colon"),
                      style: AppFont.BOLD_BOLD_BLACK_15,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      LocalizationsUtil.of(context).translate(
                          "đ ${StringUtil.numberFormat(totalAllBuilding)}"),
                      style: AppFont.BOLD_PURPLE_6001d2_18,
                    ),
                  ],
                ),
              ),
              FutureBuilder<BuildingMessageModel>(
                  future: getCurrentBuilding(),
                  builder: (BuildContext context,
                      AsyncSnapshot<BuildingMessageModel?> snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data != null &&
                              snapshot.data!.gateways!.length > 0) &&
                          totalAllBuilding > 0)
                        return SizedBox(
                          width: 120,
                          child: ButtonWidget(
                            defaultHintText:
                                LocalizationsUtil.of(context).translate('pay'),
                            callback: () {
                              AppRouter.pushDialog(
                                  context,
                                  AppRouter.PAYMENT_FEE_CHECK_PAGE,
                                  FeeCheckoutScreenArgument(
                                    fees: fees,
                                    buildingId: widget
                                        .args.feeGroupByApartments.buildingId!,
                                    apartmentId: _currentApartmentID,
                                    callback: widget.args.callback,
                                  ));
                            },
                            isActive: true,
                          ),
                        );
                    }
                    return SizedBox(
                      width: 120,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
