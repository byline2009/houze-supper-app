// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:houze_super/middle/repo/ekyc_repo.dart';
// import 'package:houze_super/presentation/common_widgets/widget_button_custom.dart';
// import 'package:houze_super/presentation/common_widgets/widget_photo_review_scaffold.dart';
// import 'package:houze_super/presentation/common_widgets/widget_progress_indicator.dart';
// import 'package:houze_super/presentation/index.dart';
// import 'package:houze_super/presentation/screen/ekyc/sc_ekyc_review.dart';
// import 'package:houze_super/utils/index.dart';

// class PhotoReviewScreen extends StatelessWidget {
//   final Map<String, dynamic> args;
//   PhotoReviewScreen({@required this.args});

//   final _isProgressingSubject = StreamController<bool>.broadcast();

//   Stream<bool> get _isProgressing => _isProgressingSubject.stream;

//   @override
//   Widget build(BuildContext context) {
//     final bool isCard = !args['title'].contains('S');

//     final String adviceText = isCard
//         ? 'please_make_sure_your_photo_to_be_clear_readable_and_took_from_an_original_document'
//         : 'make_sure_that_your_taken_photo_is_clear_to_be_verified_by_our_system';

//     final String _imagePath = isCard
//         ? args['title'].contains('F')
//             ? args['instance']['card_front_image']
//             : args['instance']['card_back_image']
//         : args['instance']['portrait_image'];

//     Future<void> _postEKYC() async {
//       final EKYCRepository repo = EKYCRepository();

//       await repo.postEKYC(instance: args['instance']);
//     }

//     return PhotoReviewScaffold(
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: EdgeInsets.symmetric(
//               horizontal: isCard ? 20.0 : 0,
//               vertical: 20.0,
//             ),
//             child: Column(
//               children: [
//                 Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: isCard ? 32.0 : 64.0),
//                   child: Text(
//                     LocalizationsUtil.of(context).translate(adviceText),
//                     style: AppFonts.regular15,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(height: 30.0),
//                 Image.file(File(_imagePath), filterQuality: FilterQuality.high),
//                 Container(
//                   margin: isCard
//                       ? EdgeInsets.only(top: 80.0)
//                       : EdgeInsets.only(
//                           left: 20.0,
//                           top: 30.0,
//                           right: 20.0,
//                           bottom: 44.0,
//                         ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Flexible(
//                         child: FlatButtonCustom(
//                             buttonText: 'take_the_picture_again'),
//                       ),
//                       SizedBox(width: 16.0),
//                       Flexible(
//                         child: RaisedButtonCustom(
//                           buttonText: 'use_this_photo',
//                           onPressed: args['title'].contains('F')
//                               ? () => AppRouter.pushDialog(
//                                   context,
//                                   AppRouter.CAMERA_SCREEN,
//                                   args..update('title', (value) => 'B'))
//                               : () async {
//                                   if (args['title'].contains('S')) {
//                                     _isProgressingSubject.add(true);

//                                     try {
//                                       await _postEKYC();
//                                     } finally {
//                                       _isProgressingSubject.add(false);
//                                     }
//                                   }
//                                   Navigator.of(context).pushAndRemoveUntil(
//                                     MaterialPageRoute(
//                                       builder: (_) =>
//                                           EKYCReviewScreen(args: args),
//                                       settings: RouteSettings(
//                                         name: 'eKYC/review',
//                                       ),
//                                     ),
//                                     args['title'].contains('S')
//                                         ? ModalRoute.withName(AppRouter.PROFILE)
//                                         : ModalRoute.withName(AppRouter.EKYC),
//                                   );
//                                 },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ProgressIndicatorWidget(_isProgressing),
//         ],
//       ),
//     );
//   }
// }
