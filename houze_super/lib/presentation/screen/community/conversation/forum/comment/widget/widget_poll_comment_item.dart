import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/common_widgets/stateless/sc_image_view.dart';
import 'package:houze_super/presentation/common_widgets/stateless/translator_vi_to_en.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/utils/index.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetPollCommentItem extends StatefulWidget {
  final PollCommentModel comment;
  const WidgetPollCommentItem({@required this.comment});

  @override
  _WidgetPollCommentItemState createState() => _WidgetPollCommentItemState();
}

class _WidgetPollCommentItemState extends State<WidgetPollCommentItem> {
  Widget _imageView(BuildContext context, double width, double height,
      PollCommentModel comment) {
    try {
      return comment.images.first.image.isNotEmpty
          ? Container(
              margin: comment.description.isNotEmpty
                  ? EdgeInsets.only(top: 10.0)
                  : EdgeInsets.only(top: 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: GestureDetector(
                    child: CachedImageWidget(
                      cacheKey: avatarHomeKey,
                      imgUrl: comment.images.first.imageThumb,
                      width: width,
                      height: height,
                    ),
                    onTap: () {
                      List<String> _imgs = [];
                      comment.images
                          .forEach((element) => _imgs.add(element.image));
                      AppRouter.pushDialog(
                        context,
                        AppRouter.imageViewPage,
                        ImageViewPageArgument(images: _imgs),
                      );
                    },
                  ),
                ),
              ),
            )
          : const SizedBox.shrink();
    } catch (e) {
      print(e.toString());
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Text(
            LocalizationsUtil.of(context).translate("feedback_msg_error"),
            textAlign: TextAlign.center,
            style: AppFonts.regular.copyWith(color: Color(0xff808080))),
      );
    }
  }

  dynamic _checkInvalidUrl(dynamic url) {
    if (url.toString().toLowerCase().substring(0, 5).contains('http')) {
      url = url;
      print(url);
    } else if (url.toString().toLowerCase().substring(0, 6).contains('https')) {
      url = url;
    } else if (!url.toString().toLowerCase().substring(0, 5).contains('http')) {
      url = 'https://' + url;
    } else if (!url
        .toString()
        .toLowerCase()
        .substring(0, 6)
        .contains('https')) {
      url = 'https://' + url;
    }
    return url;
  }

  void _launchURL(dynamic url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    final getLanguage = Storage.getLanguage();

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xffc4c4c4),
                borderRadius: BorderRadius.all(new Radius.circular(20)),
                border: Border.all(
                  color: Color(0xfff2f2f2),
                  width: 1.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.comment.user.imageThumb != null
                    ? CachedImageWidget(
                        cacheKey: avatarHomeKey,
                        imgUrl: widget.comment.user.imageThumb,
                        width: 48.0,
                        height: 48.0,
                      )
                    : Center(
                        child: Text(
                          widget.comment.user.fullname[0].toUpperCase(),
                          style: AppFonts.bold20.copyWith(color: Colors.white),
                        ),
                      ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                widget.comment.displayType == 0
                    ? Text(widget.comment.user.fullname, style: AppFonts.bold15)
                    : Text(
                        "0" +
                            widget.comment.user.phoneNumber
                                .toString()
                                .substring(0, 6) +
                            "***",
                        style: AppFonts.bold15),
                SizedBox(height: 5),
                widget.comment.description.isNotEmpty
                    ? Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color(0xfff5f5f5),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  DateUtil.format("dd/MM/yyyy - HH:mm",
                                      widget.comment.created.toIso8601String()),
                                  style: AppFonts.medium10
                                      .copyWith(color: Color(0xff808080))),
                              SizedBox(height: 5),
                              widget.comment.description.isNotEmpty
                                  ? Container(
                                      constraints: BoxConstraints(
                                          maxWidth: screenWidth * 0.5),
                                      child: ParsedText(
                                          text: widget.comment.description,
                                          parse: <MatchText>[
                                            MatchText(
                                              type: ParsedType.URL,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 14,
                                              ),
                                              onTap: (url) {
                                                final validURL =
                                                    _checkInvalidUrl(url);
                                                print(validURL);
                                                _launchURL(validURL
                                                    .toString()
                                                    .toLowerCase());
                                              },
                                            ),
                                          ],
                                          style: AppFonts.regular14),
                                    )
                                  : const SizedBox.shrink(),
                              getLanguage.name != 'Tiếng Việt'
                                  ? Container(
                                      child:
                                          widget.comment.description.isNotEmpty
                                              ? TranslatorViToEn(
                                                  widget.comment.description,
                                                  getLanguage.locale)
                                              : const SizedBox.shrink(),
                                    )
                                  : Center(),
                              widget.comment.images.isNotEmpty
                                  ? _imageView(context, screenWidth * 0.18,
                                      screenHeight * 0.13, widget.comment)
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                DateUtil.format("dd/MM/yyyy - HH:mm",
                                    widget.comment.created.toIso8601String()),
                                style: AppFonts.medium10
                                    .copyWith(color: Color(0xff808080))),
                            SizedBox(height: 5),
                            _imageView(context, screenWidth * 0.25,
                                screenHeight * 0.15, widget.comment),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ));
  }
}
