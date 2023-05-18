import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/repo/feed_repository.dart';

import 'package:houze_super/presentation/index.dart';

class WidgetNewsImportantBox extends StatefulWidget {
  const WidgetNewsImportantBox({Key? key}) : super(key: key);
  @override
  _WidgetNewsImportantBoxState createState() => _WidgetNewsImportantBoxState();
}

class _WidgetNewsImportantBoxState extends State<WidgetNewsImportantBox> {
  final _repo = FeedRepository();
  late Future<List<FeedMessageModel>> _feedList;

  @override
  void initState() {
    super.initState();
    _feedList = _repo.getFeeds(
      0,
      tags: AppStrings.important,
      limit: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<FeedMessageModel>>(
        future: _feedList,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            var feedImportant = snapshot.data;

            if (feedImportant!.length > 0) {
              FeedMessageModel _feed = feedImportant[0];

              Map<String, String> options = {};
              for (var j = 0; j < _feed.options!.length; ++j) {
                final f = _feed.options![j];
                options[f.key] = f.value;
              }

              return WidgetBoxesContainer(
                title:
                    LocalizationsUtil.of(context).translate('important_news'),
                action: WidgetTextBase.textTopRight(
                    LocalizationsUtil.of(context).translate('see_all'), () {
                  AppRouter.pushNoParams(
                      context, AppRouter.FEED_IMPORTANT_LIST_PAGE);
                }),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    AppRouter.navigateToDetailFeed(
                      context: context,
                      feed: _feed,
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 30),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffd2d4d6),
                          offset: Offset(0, 0),
                          blurRadius: 15,
                        )
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          SvgPicture.asset(AppVectors.icStarsCircle),
                          SizedBox(width: 10),
                          Expanded(
                              child: Text(_feed.title!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: options.containsKey("max_line")
                                      ? int.parse(options["max_line"]!)
                                      : 1,
                                  softWrap: false,
                                  style: AppFonts.medium14))
                        ]),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _feed.fields!.map((f) {
                            return Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          ScreenUtil.defaultSize.width * 9 / 10,
                                    ),
                                    child: Text(
                                        f.value.replaceAll("&nbsp;", " "),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: options
                                                .containsKey("max_line")
                                            ? int.parse(options["max_line"]!)
                                            : 1,
                                        softWrap: false,
                                        style:
                                            AppFont.SEMIBOLD_GRAY_9c9c9c_13)));
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return WidgetBoxesContainer(
              hasLine: false,
              child: Container(color: Colors.white),
            );
          } else if (snapshot.hasError) {
            return WidgetBoxesContainer(
              child: snapshot.error.toString().contains('NoDataException')
                  ? SomethingWentWrong(true)
                  : SomethingWentWrong(),
            );
          }
          return WidgetBoxesContainer(
            child: CardListSkeleton(
              shrinkWrap: true,
              length: 1,
              config: SkeletonConfig(
                theme: SkeletonTheme.Light,
                bottomLinesCount: 0,
                radius: 0.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
