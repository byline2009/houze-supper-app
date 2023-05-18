import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/app/bloc/apartment/index.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateful/dropdown_box_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/payment/sc_fee_checkout.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/localizations_util.dart';

import 'order/fee/sc_fee_list_overview.dart';

class FeeOverviewScreenArgument {
  final String apartmentId;
  final String buildingId;
  final String title;
  final Function callback;
  final String typeService;
  FeeOverviewScreenArgument(
      {@required this.apartmentId,
      this.buildingId,
      this.title,
      this.callback,
      this.typeService});
}

class FeeOverviewScreen extends StatefulWidget {
  final FeeOverviewScreenArgument args;
  FeeOverviewScreen({Key key, this.args}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeeOverviewScreenState();
}

class _FeeOverviewScreenState extends State<FeeOverviewScreen>
    with
        AutomaticKeepAliveClientMixin<FeeOverviewScreen>,
        TickerProviderStateMixin {
  final apartmentBloc = ApartmentBloc(
    apartmentRepo: ApartmentRepository(),
  );

  final feeBloc = FeeBloc();

  ApartmentMessageModel _apartment = ApartmentMessageModel();

  final _refreshController = RefreshController();

  // final buildingModel = Sqflite.currentBuilding;

  // final _overlayBloc = (BlocRegistry.get("overlay_bloc") as OverlayBloc);

  final fees = <FeeMessageModel>[];

  double totalAllBuilding;

  @override
  void initState() {
    super.initState();

    apartmentBloc.add(GetAllApartment(buildingId: widget.args.buildingId));
  }

  @override
  void dispose() {
    _refreshController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Future<void> onRefresh() async {
      feeBloc.add(
        FeeLoadList(
          building: _apartment.buildingId,
          apartment: _apartment.id,
        ),
      );
    }

    return BaseScaffold(
      title: widget.args.title,
      child: MultiBlocProvider(
        providers: <BlocProvider>[
          BlocProvider<ApartmentBloc>(create: (_) => apartmentBloc),
          BlocProvider<FeeBloc>(create: (_) => feeBloc),
        ],
        child: BlocBuilder<FeeBloc, FeeState>(
          builder: (_, FeeState feeState) {
            if (feeState is FeeInitial)
              feeBloc.add(
                FeeLoadList(
                  building: _apartment.buildingId ?? widget.args.buildingId,
                  apartment: _apartment.id ?? widget.args.apartmentId,
                ),
              );

            if (feeState is FeeFailure) {
              if (feeState.error.error is NoDataException)
                return SomethingWentWrong(true);
              else
                return SomethingWentWrong();
            }

            if (feeState is FeeLoadListSuccessful) {
              fees
                ..clear()
                ..addAll(feeState.result);

              totalAllBuilding = feeBloc.financeModel.totalAllBuilding ?? 0;

              return BlocBuilder<ApartmentBloc, List<ApartmentMessageModel>>(
                builder: (_, List<ApartmentMessageModel> apartments) {
                  if (apartments.isNotEmpty) {
                    if (_apartment.id == null)
                      _apartment = apartments
                          .firstWhere((e) => e.id == widget.args.apartmentId);

                    return Column(
                      children: [
                        DropdownBoxCustom(
                          margin: EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 20.0,
                          ),
                          title: _convertTitle(),
                          item: _apartment,
                          items: apartments,
                          setItem: (value) {
                            _apartment = value;

                            feeBloc.add(
                              FeeLoadList(
                                building: _apartment.buildingId,
                                apartment: _apartment.id,
                              ),
                            );
                          },
                        ),
                        Flexible(
                          child: SmartRefresher(
                            controller: _refreshController,
                            header: MaterialClassicHeader(),
                            onRefresh: onRefresh,
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                return SizedBox(
                                  height: 80,
                                  child: Align(
                                      alignment: Alignment.topCenter,
                                      child: body),
                                );
                              },
                            ),
                            child: SingleChildScrollView(
                              child: FeeListOverviewScreen(
                                fees: fees,
                                apartmentId: _apartment.id,
                                buildingId: _apartment.buildingId,
                              ),
                            ),
                          ),
                        ),
                        bottomButtonPayment(totalAllBuilding),
                      ],
                    );
                  }

                  return Align(child: CupertinoActivityIndicator());
                },
              );
            }

            return CardListSkeleton(
              shrinkWrap: true,
              length: 5,
              config: SkeletonConfig(
                theme: SkeletonTheme.Light,
                isShowAvatar: true,
                isCircleAvatar: true,
                bottomLinesCount: 0,
                radius: 0.0,
              ),
            );
          },
        ),
      ),
    );
  }

  _convertTitle() {
    switch (widget.args.typeService) {
      case "apartment":
        return "you_are_viewing_this_apartment's_invoice_with_colon";
      case "room":
        return "you_are_viewing_this_room's_invoice_with_colon";
      case "house_number":
        return "you_are_viewing_this_house's_invoice_with_colon";
    }
  }

  Widget bottomButtonPayment(double totalAllBuilding) {
    Future<BuildingMessageModel> buildingModel =
        Sqflite.getBuildingWithId(widget.args.buildingId);
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
                      style: AppFonts.bold15,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      LocalizationsUtil.of(context).translate(
                          "đ ${StringUtil.numberFormat(totalAllBuilding)}"),
                      style: AppFonts.bold18.copyWith(color: Color(0xff6001d2)),
                    ),
                  ],
                ),
              ),
              FutureBuilder<BuildingMessageModel>(
                  future: buildingModel,
                  builder: (BuildContext context,
                      AsyncSnapshot<BuildingMessageModel> snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data != null &&
                              snapshot.data.gateways.length > 0) &&
                          totalAllBuilding > 0)
                        return SizedBox(
                          width: 120.w,
                          child: ButtonWidget(
                            defaultHintText:
                                LocalizationsUtil.of(context).translate('pay'),
                            callback: () {
                              AppRouter.pushDialog(
                                context,
                                AppRouter.PAYMENT_FEE_CHECK_PAGE,
                                FeeCheckoutScreenArgument(
                                  fees: fees,
                                  buildingId: _apartment.buildingId,
                                  apartmentId: _apartment.id,
                                  callback: widget.args.callback,
                                ),
                              );
                            },
                            isActive: true,
                          ),
                        );
                    }
                    return SizedBox(
                      width: 120.w,
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

