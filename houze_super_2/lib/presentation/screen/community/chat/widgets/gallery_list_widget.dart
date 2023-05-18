// import 'package:flutter/material.dart';
// import 'package:houze_super/presentation/common_widgets/stateless/sc_image_view.dart';
// import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';

// import '../../../../../app_router.dart';

// class GalleryListWidget extends StatelessWidget {
//   final List<String> images;
//   final double width;
//   final double height;
//   final BuildContext parentContext;
//   const GalleryListWidget({
//     Key? key,
//     required this.images,
//     required this.width,
//     required this.height,
//     required this.parentContext,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(0),
//         scrollDirection: Axis.horizontal,
//         shrinkWrap: true,
//         itemCount: images.length,
//         itemBuilder: (BuildContext context, int index) {
//           double _right = (index == images.length - 1) ? 10.0 : 0.0;

//           return GestureDetector(
//             onTap: () {
//               AppRouter.push(
//                 context,
//                 AppRouter.imageViewPage,
//                 ImageViewPageArgument(images: images.toList(), initImg: index),
//               );
//             },
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 10,
//                 right: _right,
//               ),
//               child: ClipRRect(
//                 key: Key(images[index]),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(
//                     5.0,
//                   ),
//                 ),
//                 child: CachedImageWidget(
//                   height: height,
//                   width: width,
//                   cacheKey: images[index],
//                   imgUrl: images[index],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
