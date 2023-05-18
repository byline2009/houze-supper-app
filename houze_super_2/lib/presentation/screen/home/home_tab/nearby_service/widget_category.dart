import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/group_radio_circle_widget.dart';
import 'package:houze_super/presentation/common_widgets/group_radio_tags_widget.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/settings/places_categories.dart';

typedef void CallBackHandler(int index, dynamic value);

class CategoryWidget extends StatefulWidget {
  final CallBackHandler? callback;
  final int? defaultIndex;
  final List<CategoryItem>? datasource;
  const CategoryWidget({
    this.datasource,
    this.callback,
    this.defaultIndex,
  });
  static CategoryItem getCategory(int id) {
    return Voucher.categories.firstWhere((o) => o.id == id, orElse: null);
  }

  @override
  State<StatefulWidget> createState() => CategoryWidgetState();
}

class CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return GroupRadioCircleWidget(
      tags: widget.datasource
          ?.map((f) => GroupRadioTags(
                id: f.id,
                icon: f.icon,
                title: LocalizationsUtil.of(context).translate(f.title),
              ))
          .toList(),
      callback: (int index, dynamic value) {
        widget.callback!(index, value);
      },
      defaultIndex: widget.defaultIndex,
    );
  }
}
