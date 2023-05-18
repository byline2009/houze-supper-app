import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/detail/history/widget_facility_history.dart';

class FacilityHistoryScreenArgument {
  final FacilityDetailModel? facility;
  const FacilityHistoryScreenArgument({this.facility});
}

class FacilityHistoryScreen extends StatefulWidget {
  final FacilityHistoryScreenArgument args;

  FacilityHistoryScreen({Key? key, required this.args}) : super(key: key);

  @override
  FacilityHistoryScreenState createState() => new FacilityHistoryScreenState();
}

class FacilityHistoryScreenState extends RouteAwareState<FacilityHistoryScreen> {
  final fpickerFacility = DropdownWidgetController();
  KeyValueModel defaultSelectBox =
      KeyValueModel(key: "", value: "all_facilities");
  late FacilityDetailModel? _model;

  @override
  void initState() {
    super.initState();
    _model = widget.args.facility!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          LocalizationsUtil.of(context).translate('history_registry'),
          style: AppFonts.medium16,
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: AppColor.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _facilityName(),
              _selectFacilityDropdown(),
              SizedBox(height: 10),
              Expanded(
                child: WidgetFacilityHistory(
                  facility: _model,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectFacilityDropdown() {
    return _model == null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownWidget(
              controller: fpickerFacility,
              defaultHintText: "choose_a_facility",
              dataSource: <KeyValueModel>[defaultSelectBox],
              customDialog: (instance) {
                // AppRouter.pushDialog(context, AppRouter.FACILITY_LIST_SCREEN, {
                //   "title": 'Chọn Tiện ích tòa nhà',
                //   "type": "picker",
                //   "callback": (KeyValueModel objc) {
                //     if (objc == null) {
                //       objc = defaultSelectBox;
                //       instance.setValue(defaultSelectBox);
                //     } else {
                //       instance.setValue(objc);
                //     }
                //     //print("callback ${objc.key}");
                //     widget.params['facility_id'] = objc.key;
                //     _facilityBloc.historyStatus = null;
                //     _facilityBloc.add(
                //         FacilityGetHistoryPager(page: 1, facilityId: objc.key));
                //   },
                // });
              },
              doneEvent: (index) async {},
              cancelEvent: (index) async {},
              centerText: true,
              initIndex: 0,
            ),
          )
        : Center();
  }

  Widget _facilityName() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Row(
        children: <Widget>[
          TextLimitWidget(
            _model?.title ?? "",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: AppFont.BOLD_BLACK_22,
          ),
        ],
      ),
    );
  }
}
