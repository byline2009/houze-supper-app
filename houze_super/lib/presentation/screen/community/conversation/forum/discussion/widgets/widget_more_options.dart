import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/constants/app_constants.dart';
import 'package:houze_super/utils/constants/app_fonts.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/discussion_bloc.dart';

typedef void CallBackhandler(bool value);

class MoreOptions extends StatelessWidget {
  final DiscussionModel discussionModel;
  final DiscussionBloc discussionBloc;
  final CallBackhandler callback;
  final bool isRenderedInDetailPage;

  MoreOptions(
      {this.discussionBloc,
      this.discussionModel,
      this.callback,
      this.isRenderedInDetailPage});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.more_horiz,
      ),
      onPressed: () {
        _showModalBottomSheet(context);
      },
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(StyleHomePage.borderRadius),
                          topRight: Radius.circular(StyleHomePage.borderRadius),
                        )),
                    height: MediaQuery.of(context).size.height * 0.42,
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: const EdgeInsets.all(20),
                            margin: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: SvgPicture.asset(AppVectors.icClose),
                                )
                              ],
                            )),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding:const EdgeInsets.only(left: 5),
                                child: ListTile(
                                    onTap: () {
                                      if (discussionBloc != null) {
                                        discussionBloc.add(DeleteDiscussion(
                                            id: discussionModel.id));

                                        Navigator.pop(context);
                                        if (callback != null) callback(true);
                                        if (isRenderedInDetailPage) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    leading: Icon(Icons.delete_forever,
                                        color: Color(0xffc50000)),
                                    title: Align(
                                      child: Text(
                                        LocalizationsUtil.of(context)
                                            .translate("delete_discussion"),
                                        style: AppFonts.bold15.copyWith(
                                            color: Color(0xffc50000),
                                            fontSize: 16),
                                      ),
                                      alignment: Alignment(-1.2, 0),
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
