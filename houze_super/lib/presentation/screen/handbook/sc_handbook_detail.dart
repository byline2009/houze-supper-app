import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/handbook_model.dart';
import 'package:houze_super/middle/repo/handbook_repo.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateful/widget_webview.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/handbook/widget_created_day_top.dart';
import 'package:houze_super/presentation/screen/handbook/widget_file_attach_button.dart';

class HandbookDetailScreen extends StatefulWidget {
  final Handbook handbook;
  const HandbookDetailScreen({@required this.handbook});

  @override
  _HandbookDetailScreenState createState() => _HandbookDetailScreenState();
}

class _HandbookDetailScreenState extends State<HandbookDetailScreen> {
  final repo = HandbookRepo();
  Future<Handbook> _data;
  @override
  void initState() {
    super.initState();
    _data = repo.getHandbookByID(widget.handbook.id);
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
        title: 'announcement',
        child: FutureBuilder<Handbook>(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                if (snapshot.error.toString().contains('NoDataException'))
                  return SomethingWentWrong(true);
                else
                  return SomethingWentWrong();
              } else if (snapshot.hasData) {
                Handbook rs = snapshot.data;

                return Column(
                  children: <Widget>[
                    WidgetCreateDay(createdDay: rs.created),
                    WidgetBody(rs: rs)
                  ],
                );
              }
              return Center(child: CupertinoActivityIndicator());
            }));
  }
}

class WidgetBody extends StatelessWidget {
  final Handbook rs;
  const WidgetBody({this.rs});
  @override
  Widget build(BuildContext context) {
    var html = AppStrings.htmlBuilder(rs.description);
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            rs.title,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: AppFonts.font_family_display,
                fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: WebviewWidget(content: html))),
        WidgetFileAttach(file: rs.file)
      ],
    ));
  }
}
