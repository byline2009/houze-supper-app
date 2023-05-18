// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:houze_super/presentation/app_router.dart';
// import 'package:houze_super/utils/index.dart';

// import 'index.dart';

// class SectionPhotoLibrary extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     List<String> _images = [
//       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTthFenDyIJBAyJXi7KzGqO2JjhjvQMewQ3Q&usqp=CAU',
//       'https://i1.wp.com/iphoneswallpapers.com/wp-content/uploads/2017/09/Beautiful-Sky-Clouds-Sunset-Wallpaper-iPhone-Wallpaper-iphoneswallpapers_com.jpg',
//       'https://i.pinimg.com/originals/8a/9a/77/8a9a77646989742c64d246655cbdf0be.jpg',
//       'https://c4.wallpaperflare.com/wallpaper/700/818/381/anime-original-city-dawn-wallpaper-preview.jpg',
//     ];
//     return Container(
//       margin: EdgeInsets.only(bottom: 30),
//       padding: const EdgeInsets.all(
//         15,
//       ),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Color(0xfff5f5f5),
//           width: 2,
//           style: BorderStyle.solid,
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(
//             5.0,
//           ),
//         ),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               SvgPicture.asset(
//                 AppVectors.icAttachImage,
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Expanded(
//                 child: Text(
//                   'Thư viện ảnh',
//                   style: AppFonts.bold15,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   AppRouter.pushNoParams(
//                     context,
//                     AppRouter.CHAT_ROOM_GALLERY_PAGE,
//                   );
//                 },
//                 child: SvgPicture.asset(
//                   AppVectors.ic_arrow_right,
//                   color: Color(0xff6001d2),
//                 ),
//               ),
//             ],
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//           ),
//           const SizedBox(height: 10),
//           GalleryListWidget(
//             parentContext: context,
//             images: _images.toList(),
//             height: 95,
//             width: 100,
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }
