import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/sc_image_view.dart';
import 'package:houze_super/presentation/common_widgets/stateful/sc_video_player.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/widget_row.dart';
import 'widgets.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/utils.dart';
import 'package:video_player/video_player.dart';

const String ticketImageKey = 'ticketImageKey';

class TicketInfoSection extends StatelessWidget {
  final TicketDetailModel ticket;
  const TicketInfoSection({
    @required this.ticket,
  });

  Widget _videoViewer() {
    if (ticket.videoUrl != null && ticket.videoUrl.length > 0) {
      return VideoViewer(
        videoUrl: ticket.videoUrl,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        WidgetSectionTitle(title: 'request_information'),
        BaseWidget.makeContentWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder(
                  future:
                      ServiceConverter.getTextToConvert("apartment_with_colon"),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    return WidgetRow(
                        label: snap.data, value: ticket?.apartment?.name ?? '');
                  }),
              WidgetRow(
                  label: 'type_with_colon',
                  value: Utils.getIssueCategory(ticket.category)),
              WidgetRow(
                  label: 'code_with_colon', value: ticket?.codeIssue ?? ''),
              const SizedBox(height: 19),
              BaseWidget.containerRounder(Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  width: double.infinity,
                  child: Text(
                    ticket.description,
                    textAlign: TextAlign.justify,
                    style: AppFonts.medium14.copyWith(color: Colors.black),
                  ))),
              _videoViewer(),
              SizedBox(
                height: ticket.images.length == 0 ? 0 : 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: ticket.images.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10, top: 20),
                      child: SizedBox(
                        height: ticket.images.length == 0 ? 0 : 100,
                        width: ticket.images.length == 0 ? 0 : 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(
                            overflow: Overflow.clip,
                            children: <Widget>[
                              GestureDetector(
                                child: CachedImageWidget(
                                  imgUrl: ticket.images[index]["url"],
                                  height: double.infinity,
                                  width: double.infinity,
                                  cacheKey: ticket.images[index]['id'],
                                ),
                                onTap: () {
                                  List<String> _imgs = [];

                                  ticket.images.forEach(
                                      (element) => _imgs.add(element["url"]));

                                  AppRouter.pushDialog(
                                    context,
                                    AppRouter.imageViewPage,
                                    ImageViewPageArgument(
                                        images: _imgs, initImg: index),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class VideoViewer extends StatefulWidget {
  final String videoUrl;
  const VideoViewer({this.videoUrl});
  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _videoPlayerController.pause();
            _videoPlayerController.setLooping(true);
          });
        } else {
          print('Không được setState() khi widget not mounted');
        }
      });
    super.initState();
  }

  Widget _isVideoLoading() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: ParkingCardSkeleton(
          height: 140.0,
          width: 100.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _videoPlayerController.value.initialized
        ? GestureDetector(
            onTap: () {
              AppRouter.pushDialog(
                context,
                AppRouter.videoPlayerPage,
                VideoPlayerViewArgument(url: widget.videoUrl, title: ''),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 0.0, right: 0.0),
              height: 140.0,
              width: 100.0,
              padding: const EdgeInsets.only(top: 20.0),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    ClipRRect(
                      child: VideoPlayer(_videoPlayerController),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          AppRouter.pushDialog(
                            context,
                            AppRouter.videoPlayerPage,
                            VideoPlayerViewArgument(
                                url: widget.videoUrl, title: ''),
                          );
                        },
                        child: Icon(
                          _videoPlayerController.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 20,
                          color: Colors.black,
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0.0,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(10.0),
                            primary: !_videoPlayerController.value.isPlaying
                                ? Colors.white
                                : Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : _isVideoLoading();
  }
}
