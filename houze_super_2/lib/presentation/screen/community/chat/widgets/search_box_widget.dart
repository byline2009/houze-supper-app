import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/local/storage.dart';

import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';
import 'package:houze_super/utils/index.dart';
import '../models/index.dart';
import 'index.dart';

class SearchBoxWidget extends StatelessWidget {
  final List<LastMessageModel> datasource;

  const SearchBoxWidget({
    Key? key,
    required this.datasource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Firebase Analytics
        GetIt.instance<FBAnalytics>()
            .sendEventSearchGroupName(userID: Storage.getUserID() ?? "");
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(
            conservations: datasource,
            searchFieldText: LocalizationsUtil.of(context)
                .translate('k_search_by_group_name'),
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.all(
            Radius.circular(100.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.search,
                size: 24.0,
                color: Color(0xff838383),
              ),
              const SizedBox(width: 10),
              Text(
                LocalizationsUtil.of(context)
                    .translate('k_search_by_group_name'),
                style: AppFonts.regular15.copyWith(
                  color: Color(0xff838383),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
