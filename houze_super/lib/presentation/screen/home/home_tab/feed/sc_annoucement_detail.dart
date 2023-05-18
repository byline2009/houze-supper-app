import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/announcement_model.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/repo/annoucement_repo.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateful/widget_webview.dart';
import 'package:houze_super/presentation/screen/handbook/widget_created_day_top.dart';
import 'package:houze_super/presentation/screen/handbook/widget_file_attach_button.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

import '../../../../index.dart';

class AnnouncementScreenArgument {
  final FeedMessageModel feedMessageModel;

  const AnnouncementScreenArgument({
    @required this.feedMessageModel,
  });
}

const double horizontalPadding = 20.0;

typedef void AnnouncementScreenCallback(FeedMessageModel feed);

class AnnouncementScreen extends StatefulWidget {
  // final dynamic params;
  final AnnouncementScreenArgument argument;
  const AnnouncementScreen({@required this.argument});

  @override
  AnnouncementScreenState createState() => AnnouncementScreenState(
        feedMessageModel: this.argument.feedMessageModel,
      );
}

class AnnouncementScreenState extends State<AnnouncementScreen> {
  FeedMessageModel feedMessageModel;
  final _announcementBloc = BaseBloc();
  final announcementRepository = AnnouncementRepository();

  AnnouncementScreenState({
    this.feedMessageModel,
  }) {
    _announcementBloc.resultFunc = (dynamic args) async {
      return await announcementRepository.getAnnouncement(
        feedMessageModel.refID,
      );
    };
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: 'announcement',
      child: Container(
        color: Colors.white,
        child: BlocBuilder(
            cubit: this._announcementBloc,
            builder: (BuildContext context, BaseState announcementState) {
              if (announcementState is BaseInitial) {
                this
                    ._announcementBloc
                    .add(BaseLoadList(params: feedMessageModel.refID));
              }

              if (announcementState is BaseFailure) {
                if (announcementState.error.error is NoDataException)
                  return SomethingWentWrong(true);
                else
                  return SomethingWentWrong();
              }

              if (announcementState is BaseListSuccessful) {
                final result = announcementState.result as AnnouncementModel;

                return Column(
                  children: <Widget>[
                    WidgetCreateDay(createdDay: result.created),
                    WidgetBody(result: result)
                  ],
                );
              }

              return Center(child: CupertinoActivityIndicator());
            }),
      ),
    );
  }

  @override
  void dispose() {
    _announcementBloc.close();
    super.dispose();
  }
}

class WidgetBody extends StatelessWidget {
  final AnnouncementModel result;
  const WidgetBody({this.result});

  @override
  Widget build(BuildContext context) {
    final html = AppStrings.htmlBuilder(result.description);
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              result.title,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: AppFonts.font_family_display,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: WebviewWidget(content: html),
            ),
          ),
          WidgetFileAttach(file: result.file),
        ],
      ),
    );
  }
}
