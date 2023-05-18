import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/domain/facility_list/index.dart';
import 'package:houze_super/middle/model/facility/facility_page_model.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/pull_to_refresh.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_slide_animation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/widget_facility_item.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/widget_footer.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

import 'widget_facility_loading.dart';

class FacilityScreenArgument {
  final String title;
  final String type;
  const FacilityScreenArgument({this.title, this.type});
}

class FacilityScreen extends StatefulWidget {
  final FacilityScreenArgument args;

  const FacilityScreen({Key key, this.args}) : super(key: key);

  @override
  FacilityScreenState createState() => new FacilityScreenState();
}

class FacilityScreenState extends State<FacilityScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  KeyValueModel pickedvalue;

  //BLoc stream
  FacilityScreenState() {
    pickedvalue = null;
  }

  Widget _buildBody() {
    return BlocProvider<FacilityListBloc>(
      create: (_) => _facilityListBloc,
      child: BlocBuilder<FacilityListBloc, FacilityPageModel>(
          builder: (BuildContext context, FacilityPageModel facilityResults) {
        if (facilityResults == null) {
          return FacilityIsLoadingBox();
        }

        if (!this._facilityListBloc.isLoading) {
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
        }
        var _facilities = facilityResults.facility;

        if (!this._facilityListBloc.isNext &&
            _facilities != null &&
            _facilities.length == 0) {
          return Align(
            child: Text(LocalizationsUtil.of(context)
                .translate("there_is_no_facility")),
          );
        }

        return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            header: MaterialClassicHeader(),
            footer: WidgetFooter(
              datasource: _facilities,
              shouldLoadMore: this._facilityListBloc.isNext,
            ),
            onRefresh: () {
              this._facilityListBloc.add(
                    FacilityHistoryLoadList(page: 1),
                  );
            },
            onLoading: () {
              if (mounted) {
                this._facilityListBloc.add(
                      FacilityHistoryLoadList(),
                    );
              }
            },
            child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: _facilities.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  FacilityModel fa = _facilities[index];

                  return GestureDetector(
                      onTap: () {
                        AppRouter.push(
                          context,
                          AppRouter.FACILITY_DETAIL_PAGE,
                          FacilityDetailScreenArgument(
                            faciliyID: fa.id,
                          ),
                        );
                      },
                      child: WidgetSlideAnimation(
                          position: index,
                          child: WidgetFacilityItem(model: fa)));
                }));
      }),
    );
  }

  final _facilityListBloc = FacilityListBloc(isLoading: false);

  @override
  void initState() {
    super.initState();

    _facilityListBloc.add(
      FacilityHistoryLoadList(page: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: widget.args.title,
      actions: <Widget>[
        (widget.args.type == 'picker')
            ? Container(
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Text(
                    LocalizationsUtil.of(context).translate('select_all'),
                  ),
                ),
              )
            : const SizedBox.shrink(),
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
