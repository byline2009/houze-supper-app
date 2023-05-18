// import 'package:flutter/material.dart';
// import 'package:houze_super/presentation/index.dart';
// import '../widgets/index.dart';

// class ChatRoomGalleryScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       title: 'Thư viện ảnh',
//       child: CustomScrollView(
//         shrinkWrap: true,
//         slivers: [
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: WidgetBoxesContainer(
//                 child: GalleryListWidget(
//                   parentContext: context,
//                   height: 105,
//                   width: 103,
//                   images: [
//                     'https://i1.wp.com/iphoneswallpapers.com/wp-content/uploads/2017/09/Beautiful-Sky-Clouds-Sunset-Wallpaper-iPhone-Wallpaper-iphoneswallpapers_com.jpg',
//                     'https://i.pinimg.com/originals/8a/9a/77/8a9a77646989742c64d246655cbdf0be.jpg',
//                     'https://c4.wallpaperflare.com/wallpaper/700/818/381/anime-original-city-dawn-wallpaper-preview.jpg',
//                     'https://i.pinimg.com/originals/8a/9a/77/8a9a77646989742c64d246655cbdf0be.jpg',
//                     'https://c4.wallpaperflare.com/wallpaper/700/818/381/anime-original-city-dawn-wallpaper-preview.jpg',
//                   ],
//                 ),
//                 title: 'Hôm nay',
//                 padding: const EdgeInsets.all(
//                   10,
//                 ),
//                 noLine: true,
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: WidgetBoxesContainer(
//                 child: GalleryListWidget(
//                   parentContext: context,
//                   height: 105,
//                   width: 103,
//                   images: [
//                     'https://i1.wp.com/iphoneswallpapers.com/wp-content/uploads/2017/09/Beautiful-Sky-Clouds-Sunset-Wallpaper-iPhone-Wallpaper-iphoneswallpapers_com.jpg',
//                   ],
//                 ),
//                 title: 'Hôm qua',
//                 padding: const EdgeInsets.all(
//                   10,
//                 ),
//                 noLine: true,
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: WidgetBoxesContainer(
//                 child: GalleryListWidget(
//                   parentContext: context,
//                   height: 105,
//                   width: 103,
//                   images: [
//                     'https://i.pinimg.com/originals/8a/9a/77/8a9a77646989742c64d246655cbdf0be.jpg',
//                     'https://c4.wallpaperflare.com/wallpaper/700/818/381/anime-original-city-dawn-wallpaper-preview.jpg',
//                   ],
//                 ),
//                 title: 'Hôm nay',
//                 padding: const EdgeInsets.all(
//                   10,
//                 ),
//                 noLine: true,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
