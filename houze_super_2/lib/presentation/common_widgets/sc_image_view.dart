import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewPageArgument {
  final String? title;
  final List<String>? images;
  final int? initImg;
  const ImageViewPageArgument({
    this.images,
    this.title,
    this.initImg,
  });
}

class ImageViewPage extends StatelessWidget {
  const ImageViewPage({
    required this.params,
  });

  final ImageViewPageArgument params;

  @override
  Widget build(BuildContext context) {
    final title = params.title ?? '';
    final int initPage = params.initImg ?? 0;
    final PageController _pageController = PageController(
      initialPage: initPage,
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          centerTitle: true,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[],
        ),
      ),
      body: Container(
        color: Colors.black,
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          // : Center(
          //   child: Icon(Icons.error_outline, color: Colors.white),
          // ),
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                backgroundColor: Colors.orange,
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
                imageProvider:
                    CachedNetworkImageProvider(params.images![index]),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 1.8,
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: params.images![index]));
          },
          itemCount: params.images?.length,
          pageController: _pageController,
        ),
      ),
    );
  }
}
