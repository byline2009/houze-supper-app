import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/middle/repo/facility_repository.dart';
import 'package:houze_super/presentation/index.dart';

import 'facility/widget_facility_loading.dart';

/*
Tiện ích xung quanh
 */
class WidgetFacilitiesBox extends StatefulWidget {
  const WidgetFacilitiesBox({Key? key}) : super(key: key);
  @override
  _WidgetFacilitiesBoxState createState() => _WidgetFacilitiesBoxState();
}

class _WidgetFacilitiesBoxState extends State<WidgetFacilitiesBox> {
  final repo = FacilityRepository();
  late Future<PageModel> _pageModel;
  Future? _buildingFacility;

  @override
  void initState() {
    super.initState();
    _buildingFacility = ServiceConverter.getTextToConvert("building_facility");
    _pageModel = repo.getFacilities();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder<PageModel>(
        future: _pageModel,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return WidgetBoxesContainer(child: FacilityIsLoadingBox());
            default:
              if (snapshot.hasError)
                return WidgetBoxesContainer(
                  child: snapshot.error.toString().contains('NoDataException')
                      ? SomethingWentWrong(true)
                      : SomethingWentWrong(),
                );
              else {
                List<FacilityModel> list = (snapshot.data!.results as List)
                    .map((i) {
                      return FacilityModel.fromJson(i);
                    })
                    .take(5)
                    .toList();

                if (list.length == 0) {
                  return WidgetBoxesContainer(
                      hasLine: false, child: Container(color: Colors.white));
                }
                return FutureBuilder(
                  future: _buildingFacility,
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return WidgetBoxesContainer(
                          child: FacilityIsLoadingBox());
                    }
                    return WidgetBoxesContainer(
                      hasLine: false,
                      title: snap.data as String,
                      action: WidgetTextBase.textTopRight(
                          LocalizationsUtil.of(context).translate('see_all'),
                          () {
                        AppRouter.push(context, AppRouter.FACILITY_LIST_PAGE,
                            FacilityScreenArgument(title: snap.data as String));
                      }),
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return WidgetFacilityItem(model: list[index]);
                        },
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
