import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/presentation/common_widgets/stateful/dropdown_widget.dart';
import 'package:houze_super/presentation/screen/ticket/widget_mini_box.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

typedef IntVoidFunc = void Function(int);

class WidgetTicketTypeBox extends StatefulWidget {
  final DropdownWidgetController controller;
  final IntVoidFunc callbackResult;

  WidgetTicketTypeBox({@required this.controller, this.callbackResult});

  @override
  WidgetTicketTypeBoxState createState() => new WidgetTicketTypeBoxState();
}

class WidgetTicketTypeBoxState extends State<WidgetTicketTypeBox> {
  @override
  void initState() {
    super.initState();
  }

  List<dynamic> initData() {
    return [
      KeyValueModel(
          key: "0", value: LocalizationsUtil.of(context).translate('internet')),
      KeyValueModel(
          key: "1",
          value: LocalizationsUtil.of(context).translate('electricity')),
      KeyValueModel(
          key: "2", value: LocalizationsUtil.of(context).translate('water')),
      KeyValueModel(
          key: "3", value: LocalizationsUtil.of(context).translate('sanitary')),
      KeyValueModel(
          key: "4", value: LocalizationsUtil.of(context).translate('amenity')),
      KeyValueModel(
          key: "5",
          value: LocalizationsUtil.of(context).translate('common_facility')),
      KeyValueModel(
          key: "6", value: LocalizationsUtil.of(context).translate('elevator')),
      KeyValueModel(
          key: "7", value: LocalizationsUtil.of(context).translate('parking')),
      KeyValueModel(
          key: "8", value: LocalizationsUtil.of(context).translate('criminal')),
      KeyValueModel(
          key: "9", value: LocalizationsUtil.of(context).translate('others')),
      KeyValueModel(
          key: "10",
          value: LocalizationsUtil.of(context).translate('feedback')),
      KeyValueModel(
          key: "11",
          value: LocalizationsUtil.of(context).translate('facility_booking')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> dataSourceIssue = initData();
    return WidgetMiniBox(
      title: "category_of_issue_with_colon",
      child: DropdownWidget(
        controller: widget.controller,
        defaultHintText: 'select_one',
        dataSource: dataSourceIssue,
        buildChild: (index) {
          return Center(
            child: Text(
              dataSourceIssue[index].value,
              style: TextStyle(fontFamily: AppFonts.font_family_display),
            ),
          );
        },
        doneEvent: (index) {
          widget.callbackResult(
            int.parse(dataSourceIssue[index].key),
          );
        },
        cancelEvent: (index) {
          widget.callbackResult(null);
        },
      ),
    );
  }
}
