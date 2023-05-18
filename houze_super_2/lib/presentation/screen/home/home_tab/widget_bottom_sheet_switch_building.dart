import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:houze_super/app/blocs/overlay/index.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';

const String switchBuildingKey = 'switchBuildingKey';

class SwitchBuilding {
  //Service converter
  static Future<String> serviceConverter() {
    return ServiceConverter.convertTypeBuilding("apartment");
  }

  static void showBottomSheet({
    required BuildContext contextParent,
    required List<BuildingMessageModel> buildings,
    required String currentBuildingID,
    ValueChanged<int>? setChipIndex,
  }) {
    showModalBottomSheet(
      context: contextParent,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      builder: (context) {
        final overlayBloc = BlocProvider.of<OverlayBloc>(contextParent);
        final tabbarBloc = BlocProvider.of<TabbarTitleBloc>(contextParent);
        return SafeArea(
          maintainBottomViewPadding: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(StyleHomePage.borderRadius),
                topRight: Radius.circular(
                  StyleHomePage.borderRadius,
                ),
              ),
            ),
            child: SizedBox(
              height: StyleHomePage.bottomSheetHeight(context),
              child: Column(
                children: <Widget>[
                  HeaderBottomSheet(
                    title: LocalizationsUtil.of(context)
                        .translate('change_a_building'),
                    parentContext: contextParent,
                  ),
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
                            child: DecoratedBox(
                              decoration: BaseWidget.dividerBottom(
                                  height: 1, color: AppColor.gray_f5f5f5),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 15,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Radio(
                                      value: item.id,
                                      activeColor: AppColor.purple_6001d2,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      groupValue: currentBuildingID,
                                      hoverColor: AppColor.purple_6001d2,
                                      focusColor: AppColor.purple_6001d2,
                                      onChanged: (dynamic value) async {
                                        overlayBloc.add(BuildingPicked());
                                        tabbarBloc.add(
                                          GetTabbarTitle(
                                            service:
                                                (item.service ?? "building") +
                                                    item.type.toString(),
                                          ),
                                        );
                                        await Sqflite.pickBuildingID(
                                                id: item.id!)
                                            .whenComplete(
                                          () {
                                            if (setChipIndex != null)
                                              setChipIndex(0);

                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xfff2f2f2),
                                            width: 2.0),
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
                                          clipBehavior: Clip.hardEdge,
                                          children: <Widget>[
                                            CachedImageWidget(
                                              cacheKey: switchBuildingKey,
                                              imgUrl: item.company!.imageThumb!,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          item.name ?? '',
                                          style: AppFonts.medium14,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        const SizedBox(
                                          height: 6,
                                        ),
                                        _apartment.length > 0
                                            ? SizedBox(
                                                width: ScreenUtil
                                                        .defaultSize.width *
                                                    0.6,
                                                child: FutureBuilder(
                                                  future: Future.wait(
                                                    [
                                                      SwitchBuilding
                                                          .serviceConverter(),
                                                      Sqflite
                                                          .getCurrentBuilding()
                                                    ],
                                                  ),
                                                  builder: (context, snap) {
                                                    if (snap.connectionState ==
                                                        ConnectionState
                                                            .waiting) {
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
                                                              text:
                                                                  _convertService(
                                                                      context,
                                                                      item),
                                                              style: AppFont
                                                                  .SEMIBOLD_GRAY_838383_13
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          0.26)),
                                                          TextSpan(
                                                              text: ' ' +
                                                                  _apartment,
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
                                    // const SizedBox(
                                    //   width: 5,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () async {
                              overlayBloc.add(BuildingPicked());
                              tabbarBloc.add(
                                GetTabbarTitle(
                                  service: (item.service ?? "building") +
                                      item.type.toString(),
                                ),
                              );
                              await Sqflite.pickBuildingID(id: item.id!)
                                  .whenComplete(
                                () {
                                  if (setChipIndex != null) setChipIndex(0);

                                  Navigator.pop(context);
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
