// import 'package:flutter/material.dart';
// import 'package:houze_super/presentation/common_widgets/bottom_sheet/index.dart';
// import 'package:houze_super/presentation/index.dart';
// import 'package:houze_super/presentation/screen/base/base_widget.dart';
// import 'package:houze_super/utils/index.dart';

// typedef void TurnOffNotiCallbackHander(String value);

// class BottomSheetSettingNoti extends StatelessWidget {
//   const BottomSheetSettingNoti({
//     Key key,
//     @required this.parentContext,
//     @required this.callback,
//     @required this.title,
//     @required this.datasource,
//   }) : super(key: key);

//   final String title;
//   final List<String> datasource;
//   final BuildContext parentContext;
//   final TurnOffNotiCallbackHander callback;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       maintainBottomViewPadding: true,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(
//               StyleHomePage.borderRadius,
//             ),
//             topRight: Radius.circular(
//               StyleHomePage.borderRadius,
//             ),
//           ),
//         ),
//         height: StyleHomePage.bottomSheetHeight(
//           parentContext,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             HeaderBottomSheet(
//               title: title,
//               parentContext: parentContext,
//             ),
//             Expanded(
//               child: ListView(
//                 padding: const EdgeInsets.all(0),
//                 shrinkWrap: true,
//                 primary: false,
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 children: datasource
//                     .map(
//                       (e) => GestureDetector(
//                         onTap: () => callback(e),
//                         child: Container(
//                           key: Key(e),
//                           alignment: Alignment.center,
//                           width: double.infinity,
//                           decoration: BaseWidget.dividerBottom(
//                             color: Color(0xfff5f5f5),
//                             height: 1,
//                           ),
//                           padding:const EdgeInsets.symmetric(
//                             vertical: 28,
//                           ),
//                           child: Text(
//                             e,
//                             style:
//                                 AppFonts.medium18.copyWith(letterSpacing: 0.29),
//                           ),
//                         ),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );

//     // BottomSheetCornerWidget(
//     //   title: title,
//     //   body: Expanded(
//     //     child: ListView(
//     //       padding: const EdgeInsets.all(0),
//     //       shrinkWrap: true,
//     //       primary: false,
//     //       physics: const AlwaysScrollableScrollPhysics(),
//     //       children: datasource
//     //           .map(
//     //             (e) => GestureDetector(
//     //               onTap: () => callback(e),
//     //               child: Container(
//     //                 width: double.infinity,
//     //                 decoration: BaseWidget.dividerBottom(
//     //                   color: Color(0xfff5f5f5),
//     //                   height: 1,
//     //                 ),
//     //                 padding: EdgeInsets.symmetric(
//     //                   vertical: 28,
//     //                 ),
//     //                 child: Text(
//     //                   e,
//     //                   style: AppFonts.medium18.copyWith(letterSpacing: 0.29),
//     //                 ),
//     //               ),
//     //             ),
//     //           )
//     //           .toList(),
//     //     ),
//     //   ),
//     // );
//   }
// }
