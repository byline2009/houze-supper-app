import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/domain/index.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/register/picker/sc_facility_pickevent.dart';
import 'package:houze_super/utils/index.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class WidgetPlacePickBottomSheet extends StatelessWidget {
  final BuildContext parentContext;
  final DateTime pickedDate;
  final CallBackFacilityRegistryModel? callback;
  final panelFacilityBloc;
  final panelController;

  WidgetPlacePickBottomSheet(
      {required this.parentContext,
      required this.pickedDate,
      this.callback,
      required this.panelController,
      required this.panelFacilityBloc});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
        controller: panelController,
        parallaxEnabled: true,
        parallaxOffset: .5,
        minHeight: 0,
        backdropEnabled: true,
        isDraggable: false,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
        renderPanelSheet: true,
        panelBuilder: (sc) => _panel(sc),
        onPanelClosed: () {});
  }

  Widget _panel(ScrollController sc) {
    final height = 65.0;
    var _characterGroup = '';
    final _screenSize = MediaQuery.of(parentContext).size;
    final padding = _screenSize.width * 15 / 100;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: height,
                width: padding,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColor.black,
                  ),
                  onPressed: () {
                    panelController.close();
                  },
                )),
            BlocBuilder<FacilityBloc, FacilityState>(
                bloc: panelFacilityBloc,
                builder: (
                  BuildContext context,
                  FacilityState facilityState,
                ) {
                  final _params =
                      panelFacilityBloc.getFacilitySlotParams(facilityState);
                  var timeBetween = "";
                  if (_params != null) {
                    timeBetween =
                        "${_params['start_time']} - ${_params['end_time']}";
                  }

                  return Container(
                      height: height,
                      padding: const EdgeInsets.all(10),
                      child: Center(
                          child:
                              Text(timeBetween, style: AppFont.BOLD_BLACK_24)));
                }),
            SizedBox(
              height: height,
              width: padding,
            ),
          ],
        ),
        Container(
            width: double.infinity,
            height: 50,
            color: AppColor.gray_f5f7f8,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(children: <Widget>[
              Text(
                  LocalizationsUtil.of(parentContext)
                      .translate('please_choose_the_location_below'),
                  textAlign: TextAlign.left,
                  style: AppFont.MEDIUM_GRAY_838383_14)
            ])),
        Expanded(
            child: BlocBuilder<FacilityBloc, FacilityState>(
                bloc: panelFacilityBloc,
                builder: (
                  BuildContext context,
                  FacilityState facilityState,
                ) {
                  List<FacilitySlotModel> slots =
                      panelFacilityBloc.getFacilitySlot(facilityState);
                  final _params =
                      panelFacilityBloc.getFacilitySlotParams(facilityState);

                  if (facilityState is FacilityLoadingInProgress) {
                    return Center(child: CupertinoActivityIndicator());
                  }

                  if (slots.length > 0) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        controller: sc,
                        itemCount: slots.length,
                        itemBuilder: (BuildContext context, int index) {
                          FacilitySlotModel item = slots[index];
                          return GestureDetector(
                              onTap: () {
                                if (item.isFree == true && callback != null) {
                                  callback!(FacilityRegistryModel(
                                    startTime: _params['start_time'],
                                    endTime: _params['end_time'],
                                    dateTime: pickedDate,
                                    facilitySlotId: item.id,
                                    facilityName: item.name,
                                  ));
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Container(
                                  key: Key(item.id!),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            color: AppColor.gray_f5f5f5,
                                            width: 1,
                                            style: BorderStyle.solid)),
                                  ),
                                  padding: const EdgeInsets.only(
                                      right: 20, top: 20, bottom: 20, left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 50,
                                        child: slots[index].isFree == true
                                            ? Radio(
                                                value: item.id,
                                                activeColor:
                                                    AppColor.purple_6001d2,
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                groupValue: _characterGroup,
                                                hoverColor:
                                                    AppColor.purple_6001d2,
                                                focusColor:
                                                    AppColor.purple_6001d2,
                                                onChanged:
                                                    (dynamic value) async {
                                                  print(
                                                      '-----------Radio: onChanged() $value---');
                                                  if (item.isFree == true &&
                                                      callback != null) {
                                                    callback!(
                                                        FacilityRegistryModel(
                                                      startTime:
                                                          _params['start_time'],
                                                      endTime:
                                                          _params['end_time'],
                                                      dateTime: pickedDate,
                                                      facilitySlotId: item.id,
                                                      facilityName: item.name,
                                                    ));
                                                    Navigator.of(context).pop();
                                                    await Future.delayed(
                                                        Duration(
                                                            milliseconds: 500));
                                                  }
                                                })
                                            : Center(),
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            slots[index].name!,
                                            style: AppFonts.medium14,
                                          ),
                                          const SizedBox(height: 5),
                                          statusRegistry(
                                              context, slots[index].isFree!)
                                        ],
                                      ))
                                    ],
                                  )));
                        });
                  }

                  return Center(
                      child: Text(LocalizationsUtil.of(context)
                          .translate("no_registration_location_yet")));
                }))
      ],
    );
  }

  Widget statusRegistry(BuildContext context, bool isFree) {
    if (isFree == true) {
      return Text(
        LocalizationsUtil.of(context).translate('available_for_booking'),
        style: AppFonts.medium14.copyWith(color: AppColor.green_00aa7d),
      );
    }
    return Text(
      LocalizationsUtil.of(context).translate('not_available_for_booking'),
      style: AppFonts.medium14.copyWith(color: AppColor.red_c50000),
    );
  }
}
