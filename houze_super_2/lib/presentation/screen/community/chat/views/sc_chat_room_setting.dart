// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:houze_super/middle/local/storage.dart';
// import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/index.dart';
// import 'package:houze_super/presentation/index.dart';
// import 'package:houze_super/presentation/screen/base/base_widget.dart';
// import '../index.dart';
// /*
//  * Screen: Thông tin nhóm
//  */

// class ChatRoomSettingScreenArgument {
//   final LastMessageModel chat;

//   final String roomName;
//   const ChatRoomSettingScreenArgument({
//     required this.roomName,
//     required this.chat,
//   });
// }

// class ChatRoomSettingScreen extends StatefulWidget {
//   final ChatRoomSettingScreenArgument param;
//   const ChatRoomSettingScreen({
//     required this.param,
//   });
//   @override
//   _ChatRoomSettingScreenState createState() => _ChatRoomSettingScreenState();
// }

// class _ChatRoomSettingScreenState extends State<ChatRoomSettingScreen> {
//   ChatRoomSettingScreenArgument param;
//   bool _isNotiOn = true;

//   @override
//   void initState() {
//     super.initState();
//     param = widget.param;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final datasource = [
//       'Trong 1 giờ',
//       'Trong 4 giờ',
//       'Trong 8 giờ',
//       'Cho đến khi tôi mở lại',
//     ];
//     return BaseScaffold(
//       title: 'Thông tin nhóm',
//       child: Container(
//         decoration: BaseWidget.dividerTop(
//           height: 5,
//         ),
//         padding: const EdgeInsets.all(20),
//         child: CustomRefreshIndicator(
//           leadingGlowVisible: false,
//           trailingGlowVisible: false,
//           indicatorBuilder:
//               (BuildContext context, CustomRefreshIndicatorData d) {
//             if (d.isDraging) {
//               return Positioned(
//                 top: 20,
//                 right: 0,
//                 left: 0,
//                 child: Center(
//                   child: DraggingActivityIndicator(
//                     percentageComplete: d.value,
//                     radius: 12,
//                   ),
//                 ),
//               );
//             }

//             if (d.isArmed) {
//               return Positioned(
//                 top: 20,
//                 right: 0,
//                 left: 0,
//                 child: CupertinoActivityIndicator(radius: 12),
//               );
//             }

//             return const SizedBox.shrink();
//           },
//           onRefresh: () async {},
//           child: Stack(
//             children: [
//               CustomScrollView(
//                 shrinkWrap: true,
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 slivers: [
//                   SliverToBoxAdapter(
//                     child: headerSection(datasource),
//                   ),
//                   SliverToBoxAdapter(
//                     child: SectionPhotoLibrary(),
//                   ),
//                   SliverToBoxAdapter(
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: param.chat.users.length,
//                         physics: const NeverScrollableScrollPhysics(),
//                         padding: const EdgeInsets.all(0),
//                         itemBuilder: (c, i) {
//                           return MemberChatItem(
//                             user: param.chat.users[i],
//                           );
//                         }),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget headerSection(List<String> datasource) => Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 5,
//         ),
//         child: Column(
//           children: [
//             param.chat.user != null ||
//                     (param.chat.users != null && param.chat.users.length > 0)
//                 ? GroupChatAvatarWidget(
//                     user: param.chat.user,
//                     users: param.chat.users,
//                   )
//                 : BaseWidget.avatar(
//                     imageUrl: Storage.getAvatar(),
//                     fullname: Storage.getUserName(),
//                   ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               param.roomName,
//               textAlign: TextAlign.center,
//               style: AppFonts.bold18,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             SizedBox(
//               height: 36,
//               width: 36,
//               child: GestureDetector(
//                 onTap: () {
//                   if (!_isNotiOn) {
//                     setState(
//                       () {
//                         _isNotiOn = !_isNotiOn;
//                       },
//                     );
//                     return;
//                   }
//                   showModalBottomSheet(
//                       context: context,
//                       elevation: 0.0,
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25.0)),
//                       builder: (context) {
//                         return SafeArea(
//                           maintainBottomViewPadding: true,
//                           child: BottomSheetSettingNoti(
//                             title: 'Tắt thông báo',
//                             parentContext: context,
//                             datasource: datasource,
//                             callback: (value) async {
//                               Navigator.of(context).pop();
//                               if (value != null && datasource.contains(value))
//                                 setState(
//                                   () {
//                                     _isNotiOn = !_isNotiOn;
//                                   },
//                                 );
//                             },
//                           ),
//                         );
//                       });
//                 },
//                 child: SvgPicture.asset(
//                   _isNotiOn ? AppVectors.icNotiOn : AppVectors.icNotiOff,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text(
//               _isNotiOn ? 'Tắt thông báo' : 'Bật thông báo',
//               textAlign: TextAlign.center,
//               style: AppFonts.semibold.copyWith(
//                 fontSize: 13,
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//           ],
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//         ),
//       );

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
