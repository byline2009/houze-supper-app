import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/sc_video_player.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

typedef void CallBackHandler(bool value);

//image_picker only works on virtual android devices and physical android devices
//To test on IOS, must have physical iOS devices.
// ignore: must_be_immutable
class WidgetVideoPicker extends StatefulWidget {
  String? videoUrl;
  File? thumbnail;
  Function(BuildContext parentCtx)? pickVideo;
  BuildContext? parentCtx;
  CallBackHandler? callback;
  WidgetVideoPicker(
      {this.videoUrl,
      this.thumbnail,
      this.pickVideo,
      this.parentCtx,
      this.callback});

  @override
  _VideoPickerState createState() => _VideoPickerState();
}

class _VideoPickerState extends State<WidgetVideoPicker> {
  bool isCloseButtonClicked = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoUrl != null) {
      return _videoThumbnailView(widget.videoUrl!);
    } else {
      return _videoNotSelected();
    }
  }

  void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Widget _videoThumbnailView(String url) {
    return Container(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              AppRouter.pushDialog(
                context,
                AppRouter.VIDEO_PLAYER_SCREEN,
                VideoPlayerViewArgument(url: url, title: ''),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  ClipRRect(
                    child: widget.thumbnail != null
                        ? Image.file(
                            this.widget.thumbnail!,
                            fit: BoxFit.cover,
                            height: 140.0,
                            width: 100.0,
                          )
                        : SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          AppRouter.pushDialog(
                            context,
                            AppRouter.VIDEO_PLAYER_SCREEN,
                            VideoPlayerViewArgument(url: url, title: ''),
                          );
                        },
                        child: Icon(
                          Icons.play_arrow,
                          size: 20,
                          color: Colors.black,
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(10.0),
                            primary: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/svg/icon/ic-close-bgred.svg',
                        width: 25.0,
                        height: 25.0,
                      ),
                      iconSize: 35,
                      onPressed: () {
                        setState(() {
                          this.isCloseButtonClicked = true;
                          if (widget.callback != null && isCloseButtonClicked) {
                            widget.callback!(true);
                          }
                          this.widget.videoUrl = null;
                          this.widget.thumbnail = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _videoNotSelected() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            widget.pickVideo!(widget.parentCtx!);
          },
          child: Container(
            width: 100,
            height: 140,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Color(0xffb5b5b5),
                width: 1.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svg/ticket/slow_motion_video.svg'),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  LocalizationsUtil.of(context).translate("upload_video"),
                  style: AppFonts.semibold13.copyWith(
                    color: Color(
                      0xff838383,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 22.0,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.04),
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(0xFF725ef6),
                  Color(0xFF8e01d1),
                ],
              ),
              shape: ArrowMessageBorder(),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xFF725ef6),
                    Color(0xFF8e01d1),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    LocalizationsUtil.of(context)
                        .translate("msg_video_feedback"),
                    style: AppFonts.semibold13.copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  SvgPicture.asset(
                    'assets/svg/ticket/graphic.svg',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ArrowMessageBorder extends ShapeBorder {
  final bool usePadding;

  ArrowMessageBorder({this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: usePadding ? 10 : 0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(
        rect.centerLeft - Offset(0, 35), rect.centerLeft - Offset(0, 35));
    return Path()
      ..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
      ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
      ..relativeLineTo(10, 10)
      ..relativeLineTo(10, -25)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
