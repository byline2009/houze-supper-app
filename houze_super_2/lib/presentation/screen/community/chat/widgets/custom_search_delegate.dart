import 'package:flutter/material.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'index.dart';
import '../models/index.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({
    required this.searchFieldText,
    required this.conservations,
  });
  final String searchFieldText;
  List<LastMessageModel> conservations = [];
  List<LastMessageModel> suggestions = [];

  @override
  String get searchFieldLabel => searchFieldText;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      Visibility(
        visible: this.query.length != 0,
        child: IconButton(
          tooltip: 'Xóa',
          icon: const Icon((Icons.clear)),
          onPressed: () {
            query = '';
            suggestions.clear();
          },
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return resultDisplay(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestions = [];
    if (query.trim().isNotEmpty) {
      conservations.forEach((cons) {
        if (cons.title!.toLowerCase().contains(query.trim().toLowerCase())) {
          suggestions.add(cons);
        }
      });
    }
    return resultDisplay(context);
  }

  Widget resultDisplay(BuildContext context) {
    if (suggestions.length == 0) {
      String text =
          '-- ' + LocalizationsUtil.of(context).translate('k_no_data') + ' --';
      return Center(child: Text(text, textAlign: TextAlign.center));
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        return ChatItemWidget(
          chat: suggestions[i],
        );
      },
    );
  }
}
