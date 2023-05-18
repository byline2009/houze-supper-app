import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewArgument {
  final String? title;
  final String? url;
  const VideoPlayerViewArgument({this.url, this.title});
}

class VideoPlayerScreen extends StatefulWidget {
  final VideoPlayerViewArgument? params;
  const VideoPlayerScreen({this.params});
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends RouteAwareState<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(
      widget.params!.url!,
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: true,
          title: Text(
            widget.params!.title!,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[],
        ),
      ),

      backgroundColor: Colors.black,
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return GestureDetector(
              onTap: () {
                // If the video is playing, pause it.
                if (_controller.value.isPlaying) {
                  _controller.pause();
                }
                setState(() {});
              },
              child: Stack(
                children: [
                  Center(
                    child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: Platform.isAndroid
                            ? ClipRect(
                                child: VideoPlayer(_controller),
                                clipper: RectClipper(),
                              )
                            : VideoPlayer(_controller)),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // If the video is playing, pause it.
                          if (_controller.value.isPlaying) {
                            _controller.pause();
                          } else {
                            // If the video is paused, play it.
                            _controller.play();
                          }
                        });
                      },
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 20,
                        color: _controller.value.isPlaying
                            ? Colors.transparent
                            : Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10.0),
                          primary: !_controller.value.isPlaying
                              ? Colors.white
                              : Colors.transparent),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class RectClipper extends CustomClipper<Rect> {
  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }

  @override
  Rect getClip(Size size) {
    return const Rect.fromLTRB(0, 0, 1075, 650);
  }
}
