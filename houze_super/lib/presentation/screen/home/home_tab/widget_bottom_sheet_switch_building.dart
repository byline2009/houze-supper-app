import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/app/bloc/apartment/index.dart';

import 'package:houze_super/app/bloc/overlay/index.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';
import 'package:houze_super/utils/index.dart';

const String switchBuildingKey = 'switchBuildingKey';

class SwitchBuilding {
  //Service converter
  static Future<String> serviceConverter() {
    Future<String> service;
    service = ServiceConverter.convertTypeBuilding("apartment");
    return service;
  }

  static void showBottomSheet({
    @required BuildContext contextParent,
    @required List<BuildingMessageModel> buildings,
    @required String currentBuildingID,
    ValueChanged<int> setChipIndex,
    ApartmentBloc apartmentBloc,
  }) {
    showModalBottomSheet(
      context: contextParent,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      builder: (context) {
        final bloc = BlocProvider.of<OverlayBloc>(contextParent);
        final cubit = BlocProvider.of<TabbarTitleBloc>(contextParent);
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(StyleHomePage.borderRadius),
                topRight: Radius.circular(
                  StyleHomePage.borderRadius,
                ),
              ),
            ),
            height: StyleHomePage.bottomSheetHeight(context),
            child: Column(
              children: <Widget>[
                HeaderBottomSheet(
                    title: LocalizationsUtil.of(context)
                        .translate('change_a_building'),
                    parentContext: contextParent),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    primary: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: buildings.map(
                      (item) {
                        String _apartment = item.convertApartments();
                        return GestureDetector(
                          child: Container(
                            decoration: BaseWidget.dividerBottom(
                                height: 1, color: Color(0xfff5f5f5)),
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            margin: const EdgeInsets.only(
                              left: 15,
                            ),
                            child: Row(
                              children: <Widget>[
                                Radio(
                                  value: item.id,
                                  activeColor: Color(0xff6001d2),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  groupValue: currentBuildingID,
                                  hoverColor: Color(0xff6001d2),
                                  focusColor: Color(0xff6001d2),
                                  onChanged: (String value) {
                                    bloc.add(BuildingPicked());
                                    cubit.add(GetTabbarTitle(
                                        service: item.service +
                                            item.type.toString()));
                                    Sqflite.pickBuildingID(id: item.id)
                                        .whenComplete(
                                      () {
                                        Navigator.pop(context);

                                        if (setChipIndex != null)
                                          setChipIndex(0);

                                        if (apartmentBloc != null)
                                          apartmentBloc
                                              .add(ApartmentLoadList());
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xfff2f2f2), width: 2.0),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        14.0,
                                      ),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        12.0,
                                      ),
                                    ),
                                    child: Stack(
                                      overflow: Overflow.clip,
                                      children: <Widget>[
                                        CachedImageWidget(
                                          cacheKey: switchBuildingKey,
                                          imgUrl: item.company?.imageThumb,
                                          width: 40.0,
                                          height: 40.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      item.name,
                                      style: AppFonts.medium14
                                          .copyWith(color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    _apartment.length > 0
                                        ? SizedBox(
                                            width: ScreenUtil.screenWidth * 0.6,
                                            child: FutureBuilder(
                                              future: Future.wait(
                                                [
                                                  SwitchBuilding
                                                      .serviceConverter(),
                                                  Sqflite.getCurrentBuilding()
                                                ],
                                              ),
                                              builder: (context, snap) {
                                                if (snap.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                                return RichText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: _convertService(
                                                              context, item),
                                                          style: AppFonts.bold13
                                                              .copyWith(
                                                                  color: Color(
                                                                      0xff838383),
                                                                  letterSpacing:
                                                                      0.26)),
                                                      TextSpan(
                                                          text:
                                                              ' ' + _apartment,
                                                          style: AppFonts
                                                              .semibold13),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            bloc.add(BuildingPicked());
                            cubit.add(
                              GetTabbarTitle(
                                service: item.service + item.type.toString(),
                              ),
                            );
                            Sqflite.pickBuildingID(id: item.id).whenComplete(
                              () {
                                Navigator.pop(context);

                                if (setChipIndex != null) setChipIndex(0);

                                if (apartmentBloc != null)
                                  apartmentBloc.add(ApartmentLoadList());
                              },
                            );
                          },
                        );
                      },
                    ).toList(),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static _convertService(BuildContext context, BuildingMessageModel item) {
    if (item.service == "z") {
      return LocalizationsUtil.of(context).translate("room");
    }
    if (item.service == "building" && item.type == 1) {
      return LocalizationsUtil.of(context).translate("house_number");
    }
    return LocalizationsUtil.of(context).translate("apartment");
  }
}
