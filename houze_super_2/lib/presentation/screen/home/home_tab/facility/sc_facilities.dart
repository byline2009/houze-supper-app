import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/domain/facility_list/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/facility/facility_page_model.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/widget_slide_animation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/chat/widgets/widget_footer.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';

import 'widget_facility_loading.dart';

class FacilityScreenArgument {
  final String? title;
  final String? type;
  const FacilityScreenArgument({this.title, this.type});
}

class FacilityScreen extends StatefulWidget {
  final FacilityScreenArgument? args;

  const FacilityScreen({Key? key, this.args}) : super(key: key);

  @override
  FacilityScreenState createState() => new FacilityScreenState();
}

class FacilityScreenState extends RouteAwareState<FacilityScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  KeyValueModel? pickedvalue;
  int page = 1;
  bool shouldLoadMore = true;
  var _listTemp = <FacilityModel>[];
  var _list = <FacilityModel>[];

  void _onLoading() {
    if (this.shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      this._facilityListBloc.add(
            FacilityHistoryLoadList(page: page),
          );
    }
    _refreshController.loadComplete();
  }

  void _onRefresh() {
    this.page = 1;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    this._facilityListBloc.add(
          FacilityHistoryLoadList(page: 1),
        );
    _refreshController.refreshCompleted();
    _refreshController.loadComplete();
  }

  //BLoc stream
  FacilityScreenState() {
    pickedvalue = null;
  }

  Widget _buildBody() {
    return BlocProvider<FacilityListBloc>(
      create: (_) => _facilityListBloc,
      child: BlocBuilder<FacilityListBloc, FacilityPageModel?>(
        builder: (BuildContext context, FacilityPageModel? facilityResults) {
          if (facilityResults == null) {
            return Center(
              child: Text(
                LocalizationsUtil.of(context).translate("lost_connection"),
              ),
            );
          }

          if (!this._facilityListBloc.isLoading) {
            _refreshController.loadComplete();
            _refreshController.refreshCompleted();
          }

          final _facilities = facilityResults.facility;

          if (!this._facilityListBloc.isNext &&
              _facilities != null &&
              _facilities.length == 0) {
            return Align(
              child: Text(LocalizationsUtil.of(context)
                  .translate("there_is_no_facility")),
            );
          }
          if (_facilities!.length > 0 && _listTemp.isEmpty) {
            final List<FacilityModel> test = _facilities;
            shouldLoadMore = test.length >= AppConstant.limitDefault;
            _listTemp.addAll(test);
            _list.addAll(test.toList());

            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: MaterialClassicHeader(),
              footer: WidgetFooter(
                datasource: _list,
                shouldLoadMore: this._facilityListBloc.isNext,
              ),
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: facilityResults.facility!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  FacilityModel model = facilityResults.facility![index];

                  return GestureDetector(
                    onTap: () {
                      AppRouter.push(
                        context,
                        AppRouter.FACILITY_DETAIL_PAGE,
                        FacilityDetailScreenArgument(
                          faciliyID: model.id!,
                        ),
                      );
                    },
                    child: WidgetSlideAnimation(
                      position: index,
                      child: WidgetFacilityItem(model: model),
                    ),
                  );
                },
              ),
            );
          }
          return FacilityIsLoadingBox();
        },
      ),
    );
  }

  final _facilityListBloc = FacilityListBloc(isLoading: false);

  @override
  void initState() {
    super.initState();
    //Firebase Analytics
    GetIt.instance<FBAnalytics>()
        .sendEventViewBuildingFacilityList(userID: Storage.getUserID() ?? "");
    _facilityListBloc.add(
      FacilityHistoryLoadList(page: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: widget.args?.title ?? "",
      actions: <Widget>[
        (widget.args?.type == 'picker')
            ? Container(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.transparent;
                      return null;
                    }),
                  ),
                  // highlightColor: Colors.transparent,
                  child: Text(
                    LocalizationsUtil.of(context).translate('select_all'),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
      child: SafeArea(
        child: Scrollbar(
          child: Container(color: Colors.white, child: _buildBody()),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
